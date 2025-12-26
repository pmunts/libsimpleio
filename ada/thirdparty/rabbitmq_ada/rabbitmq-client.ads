--  RabbitMQ.Client - High-level AMQP client API
--  Provides simplified publish/subscribe operations with URL-based connections

private with Ada.Finalization;
with Ada.Strings.Unbounded;

with RabbitMQ.Channels;
with RabbitMQ.Connections;
with RabbitMQ.Consuming;
with RabbitMQ.Exchanges;
with RabbitMQ.Messages;

package RabbitMQ.Client is

   package SU renames Ada.Strings.Unbounded;

   --  High-level connection managing both AMQP connection and channel
   type Connection is tagged limited private;

   --  Optional TLS configuration (for amqps:// URLs)
   type TLS_Config is record
      CA_Cert         : SU.Unbounded_String := SU.Null_Unbounded_String;
      Client_Cert     : SU.Unbounded_String := SU.Null_Unbounded_String;
      Client_Key      : SU.Unbounded_String := SU.Null_Unbounded_String;
      Verify_Peer     : Boolean := True;
      Verify_Hostname : Boolean := True;
   end record;

   --  Default TLS config (no client certificates)
   No_TLS : constant TLS_Config := (others => <>);

   ---------------------------------------------------------------------------
   --  Connection Management
   ---------------------------------------------------------------------------

   --  Connect using AMQP URL (auto-detects TLS from amqps:// scheme)
   --  URL format: amqp://[user:password@]host[:port][/vhost]
   --  Raises Invalid_URL, Connection_Error, SSL_Error
   procedure Connect
     (C   : out Connection;
      URL : String;
      TLS : TLS_Config := No_TLS);

   --  Check if connection is open
   function Is_Connected (C : Connection) return Boolean;

   --  Close the connection explicitly (also happens on finalization)
   procedure Close (C : in out Connection);

   ---------------------------------------------------------------------------
   --  Queue/Exchange Declaration
   ---------------------------------------------------------------------------

   --  Declare a named queue
   procedure Declare_Queue
     (C           : Connection;
      Queue       : String;
      Durable     : Boolean := False;
      Exclusive   : Boolean := False;
      Auto_Delete : Boolean := False);

   --  Declare a temporary queue with broker-assigned name
   --  Returns the assigned queue name
   function Declare_Queue
     (C           : Connection;
      Durable     : Boolean := False;
      Exclusive   : Boolean := True;
      Auto_Delete : Boolean := True) return String;

   --  Declare an exchange
   procedure Declare_Exchange
     (C           : Connection;
      Exchange    : String;
      Kind        : String := RabbitMQ.Exchanges.Direct;
      Durable     : Boolean := False;
      Auto_Delete : Boolean := False);

   --  Bind a queue to an exchange
   procedure Bind_Queue
     (C           : Connection;
      Queue       : String;
      Exchange    : String;
      Routing_Key : String := "");

   ---------------------------------------------------------------------------
   --  Publishing
   ---------------------------------------------------------------------------

   --  Publish a string message directly to a queue
   procedure Publish
     (C       : Connection;
      Queue   : String;
      Message : String);

   --  Publish a Message object directly to a queue
   procedure Publish
     (C       : Connection;
      Queue   : String;
      Message : RabbitMQ.Messages.Message);

   --  Publish a string to an exchange with routing key
   procedure Publish
     (C           : Connection;
      Exchange    : String;
      Routing_Key : String;
      Message     : String);

   --  Publish a Message object to an exchange with routing key
   procedure Publish
     (C           : Connection;
      Exchange    : String;
      Routing_Key : String;
      Message     : RabbitMQ.Messages.Message);

   ---------------------------------------------------------------------------
   --  Subscription
   ---------------------------------------------------------------------------

   --  Message handler callback type (for auto-ack mode)
   type Message_Handler is access procedure
     (Message : RabbitMQ.Messages.Message);

   --  Subscribe to a queue with auto-acknowledgment (blocking)
   --  Handler is called for each received message
   --  Blocks until Unsubscribe is called or connection closes
   procedure Subscribe
     (C       : in out Connection;
      Queue   : String;
      Handler : Message_Handler);

   --  Message handler with manual acknowledgment
   --  Call Ack to acknowledge, Reject to reject the message
   type Ack_Message_Handler is access procedure
     (Delivery : RabbitMQ.Consuming.Delivery;
      Ack      : not null access procedure;
      Reject   : not null access procedure);

   --  Subscribe with manual acknowledgment (blocking)
   procedure Subscribe
     (C       : in out Connection;
      Queue   : String;
      Handler : Ack_Message_Handler);

   --  Cancel active subscription
   --  Can be called from handler or another task
   procedure Unsubscribe (C : in out Connection);

private

   type Connection is new Ada.Finalization.Limited_Controlled with record
      Conn         : RabbitMQ.Connections.Connection;
      Channel      : RabbitMQ.Channels.Channel;
      Consumer_Tag : SU.Unbounded_String := SU.Null_Unbounded_String;
      Subscribed   : Boolean := False;
   end record;

   overriding procedure Finalize (C : in out Connection);

end RabbitMQ.Client;
