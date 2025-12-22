--  RabbitMQ Ada bindings - Message consuming
--  Provides Ada-idiomatic message consuming operations

with RabbitMQ.Channels;
with RabbitMQ.Messages;
with Ada.Strings.Unbounded;

package RabbitMQ.Consuming is

   package SU renames Ada.Strings.Unbounded;

   --  Delivery information for a consumed message
   type Delivery is record
      Channel      : Natural := 0;
      Consumer_Tag : SU.Unbounded_String := SU.Null_Unbounded_String;
      Delivery_Tag : Natural := 0;
      Redelivered  : Boolean := False;
      Exchange     : SU.Unbounded_String := SU.Null_Unbounded_String;
      Routing_Key  : SU.Unbounded_String := SU.Null_Unbounded_String;
      Message      : Messages.Message;
   end record;

   --  Start consuming messages from a queue
   --  Returns the consumer tag assigned by the broker
   function Start_Consumer
     (Ch           : RabbitMQ.Channels.Channel'Class;
      Queue        : String;
      Consumer_Tag : String := "";  --  Empty = broker generates tag
      No_Local     : Boolean := False;
      No_Ack       : Boolean := False;
      Exclusive    : Boolean := False) return String;

   --  Wait for and consume a message (blocking)
   --  Timeout_Ms = 0 means wait forever
   --  Returns True if a message was received, False on timeout
   function Consume_Message
     (Ch         : RabbitMQ.Channels.Channel'Class;
      Msg        : out Delivery;
      Timeout_Ms : Natural := 0) return Boolean;

   --  Synchronously get a single message from a queue (polling)
   --  Returns True if a message was available, False if queue was empty
   function Get_Message
     (Ch     : RabbitMQ.Channels.Channel'Class;
      Queue  : String;
      Msg    : out Delivery;
      No_Ack : Boolean := False) return Boolean;

   --  Acknowledge a message
   procedure Ack
     (Ch           : RabbitMQ.Channels.Channel'Class;
      Delivery_Tag : Natural;
      Multiple     : Boolean := False);

   --  Reject a message
   procedure Reject
     (Ch           : RabbitMQ.Channels.Channel'Class;
      Delivery_Tag : Natural;
      Should_Requeue : Boolean := True);

   --  Negatively acknowledge a message (can nack multiple)
   procedure Nack
     (Ch           : RabbitMQ.Channels.Channel'Class;
      Delivery_Tag : Natural;
      Multiple     : Boolean := False;
      Should_Requeue : Boolean := True);

   --  Cancel a consumer
   procedure Cancel_Consumer
     (Ch           : RabbitMQ.Channels.Channel'Class;
      Consumer_Tag : String);

end RabbitMQ.Consuming;
