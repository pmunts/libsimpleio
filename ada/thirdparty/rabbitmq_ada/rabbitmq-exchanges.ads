--  RabbitMQ Ada bindings - Exchange management
--  Provides Ada-idiomatic exchange operations

with RabbitMQ.Channels;

package RabbitMQ.Exchanges is

   --  Standard exchange types
   Direct  : constant String := "direct";
   Fanout  : constant String := "fanout";
   Topic   : constant String := "topic";
   Headers : constant String := "headers";

   --  Declare an exchange
   procedure Declare_Exchange
     (Ch          : RabbitMQ.Channels.Channel'Class;
      Name        : String;
      Kind        : String := Direct;
      Passive     : Boolean := False;
      Durable     : Boolean := False;
      Auto_Delete : Boolean := False;
      Internal    : Boolean := False);

   --  Delete an exchange
   procedure Delete
     (Ch        : RabbitMQ.Channels.Channel'Class;
      Name      : String;
      If_Unused : Boolean := False);

   --  Bind an exchange to another exchange (exchange-to-exchange binding)
   procedure Bind
     (Ch          : RabbitMQ.Channels.Channel'Class;
      Destination : String;
      Source      : String;
      Routing_Key : String := "");

   --  Unbind an exchange from another exchange
   procedure Unbind
     (Ch          : RabbitMQ.Channels.Channel'Class;
      Destination : String;
      Source      : String;
      Routing_Key : String := "");

end RabbitMQ.Exchanges;
