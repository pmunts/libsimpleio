--  RabbitMQ Ada bindings - Channel management implementation

with Interfaces.C;
with RabbitMQ.Exceptions;

package body RabbitMQ.Channels is

   package CB renames C_Binding;

   use type Interfaces.C.int;
   use type CB.amqp_connection_state_t;
   use type CB.amqp_response_type_enum;

   --  Helper to check and raise exception for RPC reply errors
   procedure Check_RPC_Reply
     (State   : CB.amqp_connection_state_t;
      Context : String)
   is
      Reply : constant CB.amqp_rpc_reply_t := CB.amqp_get_rpc_reply (State);
   begin
      case Reply.reply_type is
         when CB.AMQP_RESPONSE_NORMAL =>
            null;  --  Success

         when CB.AMQP_RESPONSE_NONE =>
            raise Exceptions.Protocol_Error
              with Context & ": missing RPC reply";

         when CB.AMQP_RESPONSE_LIBRARY_EXCEPTION =>
            declare
               Err : constant Interfaces.C.int := Reply.library_error;
            begin
               if Err = CB.amqp_status_enum_u_AMQP_STATUS_NO_MEMORY then
                  raise Exceptions.No_Memory with Context;
               elsif Err =
                  CB.amqp_status_enum_u_AMQP_STATUS_CONNECTION_CLOSED
               then
                  raise Exceptions.Connection_Closed with Context;
               elsif Err = CB.amqp_status_enum_u_AMQP_STATUS_SOCKET_ERROR
                  or else Err = CB.amqp_status_enum_u_AMQP_STATUS_TCP_ERROR
               then
                  raise Exceptions.Socket_Error with Context;
               elsif Err = CB.amqp_status_enum_u_AMQP_STATUS_TIMEOUT then
                  raise Exceptions.Timeout_Error with Context;
               else
                  raise Exceptions.Channel_Error
                    with Context & ": library error";
               end if;
            end;

         when CB.AMQP_RESPONSE_SERVER_EXCEPTION =>
            raise Exceptions.Channel_Error
              with Context & ": server exception";
      end case;
   end Check_RPC_Reply;

   ----------
   -- Open --
   ----------

   procedure Open
     (Ch     : out Channel;
      Conn   : RabbitMQ.Connections.Connection'Class;
      Number : Channel_Number := 1)
   is
      Result : access CB.amqp_channel_open_ok_t;
      pragma Unreferenced (Result);
   begin
      if not Connections.Is_Open (Conn) then
         raise Exceptions.Connection_Closed
           with "Cannot open channel on closed connection";
      end if;

      Ch.Conn_State := Connections.Get_State (Conn);
      Ch.Number := CB.amqp_channel_t (Number);

      --  Open the channel
      Result := CB.amqp_channel_open (Ch.Conn_State, Ch.Number);
      Check_RPC_Reply (Ch.Conn_State, "Failed to open channel");

      Ch.Open := True;
   end Open;

   -------------
   -- Is_Open --
   -------------

   function Is_Open (Ch : Channel) return Boolean is
   begin
      return Ch.Open;
   end Is_Open;

   ----------------
   -- Get_Number --
   ----------------

   function Get_Number (Ch : Channel) return Channel_Number is
   begin
      return Channel_Number (Ch.Number);
   end Get_Number;

   -----------
   -- Close --
   -----------

   procedure Close (Ch : in out Channel) is
      Reply : CB.amqp_rpc_reply_t;
      pragma Unreferenced (Reply);
   begin
      if Ch.Open and then Ch.Conn_State /= null then
         Reply := CB.amqp_channel_close
           (Ch.Conn_State, Ch.Number, CB.AMQP_REPLY_SUCCESS);
         Ch.Open := False;
      end if;

      Ch.Conn_State := null;
      Ch.Number := 0;
   end Close;

   --------------------------
   -- Get_Connection_State --
   --------------------------

   function Get_Connection_State
     (Ch : Channel) return CB.amqp_connection_state_t
   is
   begin
      return Ch.Conn_State;
   end Get_Connection_State;

   -------------------
   -- Get_C_Channel --
   -------------------

   function Get_C_Channel
     (Ch : Channel) return CB.amqp_channel_t
   is
   begin
      return Ch.Number;
   end Get_C_Channel;

end RabbitMQ.Channels;
