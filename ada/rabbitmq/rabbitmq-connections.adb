--  RabbitMQ Ada bindings - Connection management implementation

with Interfaces.C.Strings;
with RabbitMQ.Exceptions;

package body RabbitMQ.Connections is

   package CB renames C_Binding;

   use type Interfaces.C.int;
   use type CB.amqp_connection_state_t;
   use type CB.amqp_response_type_enum;
   use type SU.Unbounded_String;

   --  Helper to convert Ada String to C string
   function To_C (S : String) return Interfaces.C.Strings.chars_ptr
     renames Interfaces.C.Strings.New_String;

   --  Helper to check and raise exception for RPC reply errors
   procedure Check_RPC_Reply
     (Reply   : CB.amqp_rpc_reply_t;
      Context : String)
   is
      use CB;
   begin
      case Reply.reply_type is
         when AMQP_RESPONSE_NORMAL =>
            null;  --  Success

         when AMQP_RESPONSE_NONE =>
            raise Exceptions.Protocol_Error
              with Context & ": missing RPC reply";

         when AMQP_RESPONSE_LIBRARY_EXCEPTION =>
            declare
               Err : constant Interfaces.C.int := Reply.library_error;
            begin
               if Err = amqp_status_enum_u_AMQP_STATUS_NO_MEMORY then
                  raise Exceptions.No_Memory with Context;
               elsif Err =
                  amqp_status_enum_u_AMQP_STATUS_HOSTNAME_RESOLUTION_FAILED
               then
                  raise Exceptions.Hostname_Resolution_Failed with Context;
               elsif Err =
                  amqp_status_enum_u_AMQP_STATUS_INCOMPATIBLE_AMQP_VERSION
               then
                  raise Exceptions.Incompatible_Protocol_Version with Context;
               elsif Err =
                  amqp_status_enum_u_AMQP_STATUS_CONNECTION_CLOSED
               then
                  raise Exceptions.Connection_Closed with Context;
               elsif Err = amqp_status_enum_u_AMQP_STATUS_SOCKET_ERROR
                  or else Err = amqp_status_enum_u_AMQP_STATUS_TCP_ERROR
               then
                  raise Exceptions.Socket_Error with Context;
               elsif Err = amqp_status_enum_u_AMQP_STATUS_SOCKET_CLOSED then
                  raise Exceptions.Socket_Closed with Context;
               elsif Err = amqp_status_enum_u_AMQP_STATUS_TIMEOUT then
                  raise Exceptions.Timeout_Error with Context;
               elsif Err = amqp_status_enum_u_AMQP_STATUS_HEARTBEAT_TIMEOUT
               then
                  raise Exceptions.Heartbeat_Timeout with Context;
               elsif Err = amqp_status_enum_u_AMQP_STATUS_SSL_ERROR then
                  raise Exceptions.SSL_Error with Context;
               elsif Err = amqp_status_enum_u_AMQP_STATUS_INVALID_PARAMETER
               then
                  raise Exceptions.Invalid_Parameter with Context;
               elsif Err = amqp_status_enum_u_AMQP_STATUS_TABLE_TOO_BIG then
                  raise Exceptions.Table_Too_Big with Context;
               else
                  raise Exceptions.RabbitMQ_Error
                    with Context & ": library error";
               end if;
            end;

         when AMQP_RESPONSE_SERVER_EXCEPTION =>
            --  Server-side error
            raise Exceptions.Protocol_Error
              with Context & ": server exception";
      end case;
   end Check_RPC_Reply;

   -------------
   -- Connect --
   -------------

   procedure Connect
     (Conn         : out Connection;
      Host         : String;
      Port         : Natural := Default_Port;
      User         : String := Default_User;
      Password     : String := Default_Password;
      Virtual_Host : String := Default_Virtual_Host;
      Channel_Max  : Natural := Default_Channel_Max;
      Frame_Max    : Natural := Default_Frame_Max;
      Heartbeat    : Natural := Default_Heartbeat)
   is
      use Interfaces.C;

      Status   : int;
      Reply    : CB.amqp_rpc_reply_t;
      Ignored  : int;
      pragma Unreferenced (Ignored);

      C_Host     : Interfaces.C.Strings.chars_ptr := To_C (Host);
      C_User     : Interfaces.C.Strings.chars_ptr := To_C (User);
      C_Password : Interfaces.C.Strings.chars_ptr := To_C (Password);
      C_Vhost    : Interfaces.C.Strings.chars_ptr := To_C (Virtual_Host);

      procedure Cleanup is
      begin
         Interfaces.C.Strings.Free (C_Host);
         Interfaces.C.Strings.Free (C_User);
         Interfaces.C.Strings.Free (C_Password);
         Interfaces.C.Strings.Free (C_Vhost);
      end Cleanup;
   begin
      --  Create connection state
      Conn.State := CB.amqp_new_connection;
      if Conn.State = null then
         Cleanup;
         raise Exceptions.No_Memory
           with "Failed to allocate connection state";
      end if;

      --  Create TCP socket
      Conn.Socket := CB.amqp_tcp_socket_new (Conn.State);
      if Conn.Socket = null then
         Ignored := CB.amqp_destroy_connection (Conn.State);
         Conn.State := null;
         Cleanup;
         raise Exceptions.No_Memory with "Failed to create TCP socket";
      end if;

      --  Open socket connection
      Status := CB.amqp_socket_open (Conn.Socket, C_Host, int (Port));
      Interfaces.C.Strings.Free (C_Host);
      C_Host := Interfaces.C.Strings.Null_Ptr;

      if Status /= 0 then
         Ignored := CB.amqp_destroy_connection (Conn.State);
         Conn.State := null;
         Interfaces.C.Strings.Free (C_User);
         Interfaces.C.Strings.Free (C_Password);
         Interfaces.C.Strings.Free (C_Vhost);
         raise Exceptions.Connection_Error
           with "Failed to open socket connection";
      end if;

      --  Login to broker using PLAIN authentication
      Reply := CB.rabbitmq_ada_login_plain
        (state       => Conn.State,
         vhost       => C_Vhost,
         channel_max => int (Channel_Max),
         frame_max   => int (Frame_Max),
         heartbeat   => int (Heartbeat),
         username    => C_User,
         password    => C_Password);

      Interfaces.C.Strings.Free (C_User);
      Interfaces.C.Strings.Free (C_Password);
      Interfaces.C.Strings.Free (C_Vhost);

      if Reply.reply_type /= CB.AMQP_RESPONSE_NORMAL then
         Ignored := CB.amqp_destroy_connection (Conn.State);
         Conn.State := null;
         Check_RPC_Reply (Reply, "Login failed");
      end if;

      Conn.Open := True;
   end Connect;

   -----------------
   -- Connect_TLS --
   -----------------

   procedure Connect_TLS
     (Conn         : out Connection;
      Host         : String;
      Port         : Natural := Default_TLS_Port;
      User         : String := Default_User;
      Password     : String := Default_Password;
      Virtual_Host : String := Default_Virtual_Host;
      TLS          : TLS_Options := Default_TLS_Options;
      Channel_Max  : Natural := Default_Channel_Max;
      Frame_Max    : Natural := Default_Frame_Max;
      Heartbeat    : Natural := Default_Heartbeat)
   is
      use Interfaces.C;

      Status   : int;
      Reply    : CB.amqp_rpc_reply_t;
      Ignored  : int;
      pragma Unreferenced (Ignored);

      C_Host     : Interfaces.C.Strings.chars_ptr := To_C (Host);
      C_User     : Interfaces.C.Strings.chars_ptr := To_C (User);
      C_Password : Interfaces.C.Strings.chars_ptr := To_C (Password);
      C_Vhost    : Interfaces.C.Strings.chars_ptr := To_C (Virtual_Host);

      --  Helper to convert TLS_Version to C constant
      function To_C_TLS_Version (V : TLS_Version) return CB.amqp_tls_version_t
      is
      begin
         case V is
            when TLSv1      => return CB.AMQP_TLSv1;
            when TLSv1_1    => return CB.AMQP_TLSv1_1;
            when TLSv1_2    => return CB.AMQP_TLSv1_2;
            when TLS_Latest => return CB.AMQP_TLSvLATEST;
         end case;
      end To_C_TLS_Version;

      --  Helper to convert Boolean to amqp_boolean_t
      function To_Bool (B : Boolean) return CB.amqp_boolean_t is
      begin
         if B then
            return 1;
         else
            return 0;
         end if;
      end To_Bool;

      procedure Cleanup is
      begin
         Interfaces.C.Strings.Free (C_Host);
         Interfaces.C.Strings.Free (C_User);
         Interfaces.C.Strings.Free (C_Password);
         Interfaces.C.Strings.Free (C_Vhost);
      end Cleanup;

      procedure Destroy_Connection is
      begin
         Ignored := CB.amqp_destroy_connection (Conn.State);
         Conn.State := null;
         Conn.Socket := null;
      end Destroy_Connection;

   begin
      --  Create connection state
      Conn.State := CB.amqp_new_connection;
      if Conn.State = null then
         Cleanup;
         raise Exceptions.No_Memory
           with "Failed to allocate connection state";
      end if;

      --  Create SSL socket
      Conn.Socket := CB.amqp_ssl_socket_new (Conn.State);
      if Conn.Socket = null then
         Destroy_Connection;
         Cleanup;
         raise Exceptions.No_Memory with "Failed to create SSL socket";
      end if;

      --  Set CA certificate if provided
      if TLS.CA_Cert_Path /= SU.Null_Unbounded_String then
         declare
            C_CA : Interfaces.C.Strings.chars_ptr :=
              To_C (SU.To_String (TLS.CA_Cert_Path));
         begin
            Status := CB.amqp_ssl_socket_set_cacert (Conn.Socket, C_CA);
            Interfaces.C.Strings.Free (C_CA);
            if Status /= 0 then
               Destroy_Connection;
               Cleanup;
               raise Exceptions.SSL_Error with "Failed to set CA certificate";
            end if;
         end;
      end if;

      --  Set client certificate and key for mutual TLS
      if TLS.Client_Cert /= SU.Null_Unbounded_String
        and then TLS.Client_Key /= SU.Null_Unbounded_String
      then
         --  Set key password first if provided
         if TLS.Key_Password /= SU.Null_Unbounded_String then
            declare
               C_Passwd : Interfaces.C.Strings.chars_ptr :=
                 To_C (SU.To_String (TLS.Key_Password));
            begin
               CB.amqp_ssl_socket_set_key_passwd (Conn.Socket, C_Passwd);
               Interfaces.C.Strings.Free (C_Passwd);
            end;
         end if;

         declare
            C_Cert : Interfaces.C.Strings.chars_ptr :=
              To_C (SU.To_String (TLS.Client_Cert));
            C_Key  : Interfaces.C.Strings.chars_ptr :=
              To_C (SU.To_String (TLS.Client_Key));
         begin
            Status := CB.amqp_ssl_socket_set_key (Conn.Socket, C_Cert, C_Key);
            Interfaces.C.Strings.Free (C_Cert);
            Interfaces.C.Strings.Free (C_Key);
            if Status /= 0 then
               Destroy_Connection;
               Cleanup;
               raise Exceptions.SSL_Error
                 with "Failed to set client certificate/key";
            end if;
         end;
      end if;

      --  Set verification options
      CB.amqp_ssl_socket_set_verify_peer
        (Conn.Socket, To_Bool (TLS.Verify_Peer));
      CB.amqp_ssl_socket_set_verify_hostname
        (Conn.Socket, To_Bool (TLS.Verify_Hostname));

      --  Set TLS version range
      Status := CB.amqp_ssl_socket_set_ssl_versions
        (Conn.Socket,
         To_C_TLS_Version (TLS.Min_TLS_Version),
         To_C_TLS_Version (TLS.Max_TLS_Version));
      if Status /= 0 then
         Destroy_Connection;
         Cleanup;
         raise Exceptions.SSL_Error with "Failed to set TLS version";
      end if;

      --  Open socket connection
      Status := CB.amqp_socket_open (Conn.Socket, C_Host, int (Port));
      Interfaces.C.Strings.Free (C_Host);
      C_Host := Interfaces.C.Strings.Null_Ptr;

      if Status /= 0 then
         Destroy_Connection;
         Interfaces.C.Strings.Free (C_User);
         Interfaces.C.Strings.Free (C_Password);
         Interfaces.C.Strings.Free (C_Vhost);
         raise Exceptions.Connection_Error
           with "Failed to open TLS socket connection";
      end if;

      --  Login to broker using PLAIN authentication
      Reply := CB.rabbitmq_ada_login_plain
        (state       => Conn.State,
         vhost       => C_Vhost,
         channel_max => int (Channel_Max),
         frame_max   => int (Frame_Max),
         heartbeat   => int (Heartbeat),
         username    => C_User,
         password    => C_Password);

      Interfaces.C.Strings.Free (C_User);
      Interfaces.C.Strings.Free (C_Password);
      Interfaces.C.Strings.Free (C_Vhost);

      if Reply.reply_type /= CB.AMQP_RESPONSE_NORMAL then
         Destroy_Connection;
         Check_RPC_Reply (Reply, "TLS login failed");
      end if;

      Conn.Open := True;
   end Connect_TLS;

   ----------------------
   -- TLS_With_CA_Cert --
   ----------------------

   function TLS_With_CA_Cert (CA_Cert_Path : String) return TLS_Options is
   begin
      return (CA_Cert_Path    => SU.To_Unbounded_String (CA_Cert_Path),
              Client_Cert     => SU.Null_Unbounded_String,
              Client_Key      => SU.Null_Unbounded_String,
              Key_Password    => SU.Null_Unbounded_String,
              Verify_Peer     => True,
              Verify_Hostname => True,
              Min_TLS_Version => TLSv1_2,
              Max_TLS_Version => TLS_Latest);
   end TLS_With_CA_Cert;

   -------------
   -- Is_Open --
   -------------

   function Is_Open (Conn : Connection) return Boolean is
   begin
      return Conn.Open;
   end Is_Open;

   -----------
   -- Close --
   -----------

   procedure Close (Conn : in out Connection) is
      Reply   : CB.amqp_rpc_reply_t;
      Ignored : Interfaces.C.int;
      pragma Unreferenced (Reply, Ignored);
   begin
      if Conn.Open and then Conn.State /= null then
         --  Close connection gracefully
         Reply := CB.amqp_connection_close (Conn.State, CB.AMQP_REPLY_SUCCESS);
         Conn.Open := False;
      end if;

      if Conn.State /= null then
         Ignored := CB.amqp_destroy_connection (Conn.State);
         Conn.State := null;
         Conn.Socket := null;
      end if;
   end Close;

   ---------------
   -- Get_State --
   ---------------

   function Get_State
     (Conn : Connection) return CB.amqp_connection_state_t
   is
   begin
      return Conn.State;
   end Get_State;

   --------------
   -- Finalize --
   --------------

   overriding procedure Finalize (Conn : in out Connection) is
   begin
      Close (Conn);
   end Finalize;

end RabbitMQ.Connections;
