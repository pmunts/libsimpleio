--  RabbitMQ.Client.URLs - AMQP URL parser
--  Parses amqp:// and amqps:// URLs into connection parameters

with Ada.Strings.Unbounded;

package RabbitMQ.Client.URLs is

   use Ada.Strings.Unbounded;

   --  Default connection values
   Default_Port     : constant Natural := 5672;
   Default_TLS_Port : constant Natural := 5671;
   Default_User     : constant String := "guest";
   Default_Password : constant String := "guest";
   Default_Vhost    : constant String := "/";

   --  Parsed connection parameters
   type Connection_Params is record
      Host         : Unbounded_String;
      Port         : Natural;
      User         : Unbounded_String;
      Password     : Unbounded_String;
      Virtual_Host : Unbounded_String;
      Use_TLS      : Boolean;
   end record;

   --  Parse an AMQP URL into connection parameters
   --  Supported formats:
   --    amqp://host
   --    amqp://host:port
   --    amqp://user:password@host
   --    amqp://user:password@host:port
   --    amqp://user:password@host:port/vhost
   --    amqps://... (same patterns, enables TLS)
   --
   --  Raises RabbitMQ.Exceptions.Invalid_URL on parse failure
   function Parse (URL : String) return Connection_Params;

end RabbitMQ.Client.URLs;
