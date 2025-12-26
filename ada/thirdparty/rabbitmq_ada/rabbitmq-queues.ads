--  RabbitMQ Ada bindings - Queue management
--  Provides Ada-idiomatic queue operations

with RabbitMQ.Channels;

package RabbitMQ.Queues is

   --  Queue declaration result
   type Queue_Info is record
      Name           : String (1 .. 256);
      Name_Length    : Natural;
      Message_Count  : Natural;
      Consumer_Count : Natural;
   end record;

   --  Declare a queue
   --  If Name is empty, the broker will generate a unique name
   --  Returns information about the declared queue
   function Declare_Queue
     (Ch          : RabbitMQ.Channels.Channel'Class;
      Name        : String := "";
      Passive     : Boolean := False;
      Durable     : Boolean := False;
      Exclusive   : Boolean := False;
      Auto_Delete : Boolean := False) return Queue_Info;

   --  Bind a queue to an exchange
   procedure Bind
     (Ch          : RabbitMQ.Channels.Channel'Class;
      Queue       : String;
      Exchange    : String;
      Routing_Key : String := "");

   --  Unbind a queue from an exchange
   procedure Unbind
     (Ch          : RabbitMQ.Channels.Channel'Class;
      Queue       : String;
      Exchange    : String;
      Routing_Key : String := "");

   --  Purge all messages from a queue
   --  Returns the number of messages purged
   function Purge
     (Ch    : RabbitMQ.Channels.Channel'Class;
      Queue : String) return Natural;

   --  Delete a queue
   --  Returns the number of messages deleted
   function Delete
     (Ch        : RabbitMQ.Channels.Channel'Class;
      Queue     : String;
      If_Unused : Boolean := False;
      If_Empty  : Boolean := False) return Natural;

   --  Delete a queue (procedure version, ignores message count)
   procedure Delete
     (Ch        : RabbitMQ.Channels.Channel'Class;
      Queue     : String;
      If_Unused : Boolean := False;
      If_Empty  : Boolean := False);

end RabbitMQ.Queues;
