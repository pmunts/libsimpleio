--  RabbitMQ Ada bindings - Connection management
--  Provides Ada-idiomatic connection handling with RAII

private with Ada.Finalization;
with Ada.Strings.Unbounded;
with RabbitMQ.C_Binding;

package RabbitMQ.Connections is

   package SU renames Ada.Strings.Unbounded;

   --  Connection to a RabbitMQ broker
   --  Automatically closes when it goes out of scope
   type Connection is tagged limited private;

   --  Default connection parameters
   Default_Port : constant := 5672;
   Default_TLS_Port : constant := 5671;
   Default_User : constant String := "guest";
   Default_Password : constant String := "guest";
   Default_Virtual_Host : constant String := "/";
   Default_Channel_Max : constant := 0;      --  No limit (use server default)
   Default_Frame_Max : constant := 131072;   --  128KB
   Default_Heartbeat : constant := 0;        --  No heartbeat

   --  TLS version options
   type TLS_Version is (TLSv1, TLSv1_1, TLSv1_2, TLS_Latest);

   --  TLS connection options
   --  Use Null_Unbounded_String for optional paths that are not needed
   type TLS_Options is record
      CA_Cert_Path    : SU.Unbounded_String := SU.Null_Unbounded_String;
      Client_Cert     : SU.Unbounded_String := SU.Null_Unbounded_String;
      Client_Key      : SU.Unbounded_String := SU.Null_Unbounded_String;
      Key_Password    : SU.Unbounded_String := SU.Null_Unbounded_String;
      Verify_Peer     : Boolean := True;   --  Verify server certificate
      Verify_Hostname : Boolean := True;   --  Verify hostname matches cert
      Min_TLS_Version : TLS_Version := TLSv1_2;
      Max_TLS_Version : TLS_Version := TLS_Latest;
   end record;

   --  Default TLS options (verification enabled, TLS 1.2+)
   Default_TLS_Options : constant TLS_Options := (others => <>);

   --  Helper to create TLS options with CA cert path
   function TLS_With_CA_Cert (CA_Cert_Path : String) return TLS_Options;

   --  Create a new connection to a RabbitMQ broker
   --  Raises Connection_Error on failure
   procedure Connect
     (Conn         : out Connection;
      Host         : String;
      Port         : Natural := Default_Port;
      User         : String := Default_User;
      Password     : String := Default_Password;
      Virtual_Host : String := Default_Virtual_Host;
      Channel_Max  : Natural := Default_Channel_Max;
      Frame_Max    : Natural := Default_Frame_Max;
      Heartbeat    : Natural := Default_Heartbeat);

   --  Create a new TLS/SSL connection to a RabbitMQ broker
   --  Raises Connection_Error or SSL_Error on failure
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
      Heartbeat    : Natural := Default_Heartbeat);

   --  Check if connection is open
   function Is_Open (Conn : Connection) return Boolean;

   --  Close the connection explicitly
   --  Safe to call multiple times
   procedure Close (Conn : in out Connection);

   --  Get the underlying connection state for use with thin binding
   --  For advanced users who need direct access to C API
   function Get_State
     (Conn : Connection) return C_Binding.amqp_connection_state_t;

private

   type Connection is new Ada.Finalization.Limited_Controlled with record
      State  : C_Binding.amqp_connection_state_t := null;
      Socket : access C_Binding.amqp_socket_t_u := null;
      Open   : Boolean := False;
   end record;

   overriding procedure Finalize (Conn : in out Connection);

end RabbitMQ.Connections;
