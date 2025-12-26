--  RabbitMQ Ada bindings - Channel management
--  Provides Ada-idiomatic channel handling

with RabbitMQ.C_Binding;
with RabbitMQ.Connections;

package RabbitMQ.Channels is

   --  Channel for communicating with RabbitMQ broker
   --  Channels are lightweight connections that share a single TCP connection
   type Channel is tagged limited private;

   --  Channel number type (1-65535, 0 is reserved)
   subtype Channel_Number is Positive range 1 .. 65535;

   --  Open a new channel on a connection
   --  Each channel must have a unique number on the connection
   --  Raises Channel_Error on failure
   procedure Open
     (Ch     : out Channel;
      Conn   : RabbitMQ.Connections.Connection'Class;
      Number : Channel_Number := 1);

   --  Check if channel is open
   function Is_Open (Ch : Channel) return Boolean;

   --  Get the channel number
   function Get_Number (Ch : Channel) return Channel_Number
     with Pre => Is_Open (Ch);

   --  Close the channel explicitly
   --  Safe to call multiple times
   procedure Close (Ch : in out Channel);

   --  Get the underlying connection state for use with thin binding
   --  For advanced users who need direct access to C API
   function Get_Connection_State
     (Ch : Channel) return C_Binding.amqp_connection_state_t
     with Pre => Is_Open (Ch);

   --  Get the channel number as C type for use with thin binding
   function Get_C_Channel
     (Ch : Channel) return C_Binding.amqp_channel_t
     with Pre => Is_Open (Ch);

private

   type Channel is tagged limited record
      Conn_State : C_Binding.amqp_connection_state_t := null;
      Number     : C_Binding.amqp_channel_t := 0;
      Open       : Boolean := False;
   end record;

end RabbitMQ.Channels;
