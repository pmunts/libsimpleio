--  RabbitMQ Ada bindings - Message publishing
--  Provides Ada-idiomatic message publishing operations

with RabbitMQ.Channels;
with RabbitMQ.Messages;

package RabbitMQ.Publishing is

   --  Publish a message to an exchange
   --  Routing_Key is used by the exchange to route the message to queues
   procedure Publish
     (Ch          : RabbitMQ.Channels.Channel'Class;
      Exchange    : String;
      Routing_Key : String;
      Message     : RabbitMQ.Messages.Message;
      Mandatory   : Boolean := False;
      Immediate   : Boolean := False);

   --  Publish a simple string message
   procedure Publish
     (Ch          : RabbitMQ.Channels.Channel'Class;
      Exchange    : String;
      Routing_Key : String;
      Data        : String;
      Mandatory   : Boolean := False;
      Immediate   : Boolean := False);

   --  Publish directly to a queue (via default exchange)
   --  The queue name is used as the routing key
   procedure Publish_To_Queue
     (Ch        : RabbitMQ.Channels.Channel'Class;
      Queue     : String;
      Message   : RabbitMQ.Messages.Message;
      Mandatory : Boolean := False);

   --  Publish a simple string directly to a queue
   procedure Publish_To_Queue
     (Ch        : RabbitMQ.Channels.Channel'Class;
      Queue     : String;
      Data      : String;
      Mandatory : Boolean := False);

end RabbitMQ.Publishing;
