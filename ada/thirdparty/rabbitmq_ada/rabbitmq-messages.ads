--  RabbitMQ Ada bindings - Message types
--  Provides Ada-idiomatic message representation

with Ada.Strings.Unbounded;

package RabbitMQ.Messages is

   package SU renames Ada.Strings.Unbounded;

   --  Delivery modes
   type Delivery_Mode is (Non_Persistent, Persistent);

   --  Message properties (AMQP basic properties)
   type Message_Properties is record
      Content_Type     : SU.Unbounded_String := SU.Null_Unbounded_String;
      Content_Encoding : SU.Unbounded_String := SU.Null_Unbounded_String;
      Delivery_Mode    : Messages.Delivery_Mode := Non_Persistent;
      Priority         : Natural := 0;
      Correlation_Id   : SU.Unbounded_String := SU.Null_Unbounded_String;
      Reply_To         : SU.Unbounded_String := SU.Null_Unbounded_String;
      Expiration       : SU.Unbounded_String := SU.Null_Unbounded_String;
      Message_Id       : SU.Unbounded_String := SU.Null_Unbounded_String;
      Timestamp        : Natural := 0;  --  Unix timestamp, 0 = not set
      Message_Type     : SU.Unbounded_String := SU.Null_Unbounded_String;
      User_Id          : SU.Unbounded_String := SU.Null_Unbounded_String;
      App_Id           : SU.Unbounded_String := SU.Null_Unbounded_String;
   end record;

   --  Default (empty) properties
   No_Properties : constant Message_Properties :=
     (others => <>);

   --  Message with content and properties
   type Message is record
      Content    : SU.Unbounded_String := SU.Null_Unbounded_String;
      Properties : Message_Properties := No_Properties;
   end record;

   --  Helper to create a simple text message
   function Text_Message (Data : String) return Message;

   --  Helper to create a message with content type
   function Create
     (Data         : String;
      Content_Type : String := "application/octet-stream") return Message;

   --  Helper to create a persistent message
   function Persistent_Message
     (Data         : String;
      Content_Type : String := "application/octet-stream") return Message;

   --  Get message content as String
   function Get_Content (Msg : Message) return String;

   --  Set message content from String
   procedure Set_Content (Msg : in out Message; Data : String);

end RabbitMQ.Messages;
