--  RabbitMQ Ada bindings - Message publishing implementation

with Interfaces.C;
with Interfaces;
with Ada.Strings.Unbounded;
with RabbitMQ.C_Binding;
with RabbitMQ.Exceptions;

package body RabbitMQ.Publishing is

   package CB renames C_Binding;
   package SU renames Ada.Strings.Unbounded;

   use type Interfaces.C.int;
   use type Interfaces.C.size_t;
   use type Interfaces.Unsigned_32;
   use type SU.Unbounded_String;
   use type Messages.Delivery_Mode;

   --  Helper to create amqp_bytes_t from a char_array
   function To_Bytes
     (C_Str : Interfaces.C.char_array) return CB.amqp_bytes_t
   is
      Len : constant Interfaces.C.size_t := Interfaces.C.To_Ada (C_Str)'Length;
   begin
      if Len = 0 then
         return CB.amqp_empty_bytes;
      end if;
      return (len   => Len,
              bytes => C_Str (C_Str'First)'Address);
   end To_Bytes;

   --  Helper to convert Boolean to amqp_boolean_t
   function To_Bool (B : Boolean) return CB.amqp_boolean_t is
   begin
      if B then
         return 1;
      else
         return 0;
      end if;
   end To_Bool;

   --  Set basic properties on C struct, returning the flags that were set
   procedure Set_Basic_Properties
     (Props   : Messages.Message_Properties;
      C_Props : in out CB.amqp_basic_properties_t;
      Flags   : in out CB.amqp_flags_t;
      --  C string storage (must remain valid during publish)
      C_Content_Type     : Interfaces.C.char_array;
      C_Content_Encoding : Interfaces.C.char_array;
      C_Correlation_Id   : Interfaces.C.char_array;
      C_Reply_To         : Interfaces.C.char_array;
      C_Expiration       : Interfaces.C.char_array;
      C_Message_Id       : Interfaces.C.char_array;
      C_Message_Type     : Interfaces.C.char_array;
      C_User_Id          : Interfaces.C.char_array;
      C_App_Id           : Interfaces.C.char_array)
   is
   begin
      --  Content-Type
      if Props.Content_Type /= SU.Null_Unbounded_String then
         C_Props.content_type := To_Bytes (C_Content_Type);
         Flags := Flags or CB.AMQP_BASIC_CONTENT_TYPE_FLAG;
      end if;

      --  Content-Encoding
      if Props.Content_Encoding /= SU.Null_Unbounded_String then
         C_Props.content_encoding := To_Bytes (C_Content_Encoding);
         Flags := Flags or CB.AMQP_BASIC_CONTENT_ENCODING_FLAG;
      end if;

      --  Delivery mode
      if Props.Delivery_Mode = Messages.Persistent then
         C_Props.delivery_mode := 2;  --  AMQP_DELIVERY_PERSISTENT
         Flags := Flags or CB.AMQP_BASIC_DELIVERY_MODE_FLAG;
      elsif Props.Delivery_Mode = Messages.Non_Persistent then
         C_Props.delivery_mode := 1;  --  AMQP_DELIVERY_NONPERSISTENT
         Flags := Flags or CB.AMQP_BASIC_DELIVERY_MODE_FLAG;
      end if;

      --  Priority
      if Props.Priority > 0 then
         C_Props.priority := Interfaces.Unsigned_8 (Props.Priority mod 256);
         Flags := Flags or CB.AMQP_BASIC_PRIORITY_FLAG;
      end if;

      --  Correlation-Id
      if Props.Correlation_Id /= SU.Null_Unbounded_String then
         C_Props.correlation_id := To_Bytes (C_Correlation_Id);
         Flags := Flags or CB.AMQP_BASIC_CORRELATION_ID_FLAG;
      end if;

      --  Reply-To
      if Props.Reply_To /= SU.Null_Unbounded_String then
         C_Props.reply_to := To_Bytes (C_Reply_To);
         Flags := Flags or CB.AMQP_BASIC_REPLY_TO_FLAG;
      end if;

      --  Expiration
      if Props.Expiration /= SU.Null_Unbounded_String then
         C_Props.expiration := To_Bytes (C_Expiration);
         Flags := Flags or CB.AMQP_BASIC_EXPIRATION_FLAG;
      end if;

      --  Message-Id
      if Props.Message_Id /= SU.Null_Unbounded_String then
         C_Props.message_id := To_Bytes (C_Message_Id);
         Flags := Flags or CB.AMQP_BASIC_MESSAGE_ID_FLAG;
      end if;

      --  Timestamp
      if Props.Timestamp > 0 then
         C_Props.timestamp := Interfaces.Unsigned_64 (Props.Timestamp);
         Flags := Flags or CB.AMQP_BASIC_TIMESTAMP_FLAG;
      end if;

      --  Type
      if Props.Message_Type /= SU.Null_Unbounded_String then
         C_Props.c_type := To_Bytes (C_Message_Type);
         Flags := Flags or CB.AMQP_BASIC_TYPE_FLAG;
      end if;

      --  User-Id
      if Props.User_Id /= SU.Null_Unbounded_String then
         C_Props.user_id := To_Bytes (C_User_Id);
         Flags := Flags or CB.AMQP_BASIC_USER_ID_FLAG;
      end if;

      --  App-Id
      if Props.App_Id /= SU.Null_Unbounded_String then
         C_Props.app_id := To_Bytes (C_App_Id);
         Flags := Flags or CB.AMQP_BASIC_APP_ID_FLAG;
      end if;

      C_Props.u_flags := Flags;
   end Set_Basic_Properties;

   --  Helper: get string from Unbounded_String or return empty
   function Get_Str (S : SU.Unbounded_String) return String is
   begin
      if S = SU.Null_Unbounded_String then
         return "";
      else
         return SU.To_String (S);
      end if;
   end Get_Str;

   -------------
   -- Publish --
   -------------

   procedure Publish
     (Ch          : RabbitMQ.Channels.Channel'Class;
      Exchange    : String;
      Routing_Key : String;
      Message     : RabbitMQ.Messages.Message;
      Mandatory   : Boolean := False;
      Immediate   : Boolean := False)
   is
      State  : constant CB.amqp_connection_state_t :=
        Channels.Get_Connection_State (Ch);
      Chan   : constant CB.amqp_channel_t := Channels.Get_C_Channel (Ch);
      Status : Interfaces.C.int;
      Props  : Messages.Message_Properties renames Message.Properties;

      --  Stack-allocated C strings for exchange and routing key
      C_Exchange    : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Exchange);
      C_Routing_Key : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Routing_Key);

      --  Message body
      Msg_Content : constant String := Messages.Get_Content (Message);
      C_Body      : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Msg_Content);

      --  Properties - declare C strings here so they persist through the call
      C_Props            : aliased CB.amqp_basic_properties_t :=
        (u_flags          => 0,
         content_type     => CB.amqp_empty_bytes,
         content_encoding => CB.amqp_empty_bytes,
         headers          => CB.amqp_empty_table,
         delivery_mode    => 0,
         priority         => 0,
         correlation_id   => CB.amqp_empty_bytes,
         reply_to         => CB.amqp_empty_bytes,
         expiration       => CB.amqp_empty_bytes,
         message_id       => CB.amqp_empty_bytes,
         timestamp        => 0,
         c_type           => CB.amqp_empty_bytes,
         user_id          => CB.amqp_empty_bytes,
         app_id           => CB.amqp_empty_bytes,
         cluster_id       => CB.amqp_empty_bytes);
      Flags              : CB.amqp_flags_t := 0;

      --  C string storage - sizes determined at runtime from property values
      C_Content_Type     : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Get_Str (Props.Content_Type));
      C_Content_Encoding : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Get_Str (Props.Content_Encoding));
      C_Correlation_Id   : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Get_Str (Props.Correlation_Id));
      C_Reply_To         : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Get_Str (Props.Reply_To));
      C_Expiration       : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Get_Str (Props.Expiration));
      C_Message_Id       : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Get_Str (Props.Message_Id));
      C_Message_Type     : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Get_Str (Props.Message_Type));
      C_User_Id          : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Get_Str (Props.User_Id));
      C_App_Id           : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Get_Str (Props.App_Id));
   begin
      Set_Basic_Properties
        (Props              => Props,
         C_Props            => C_Props,
         Flags              => Flags,
         C_Content_Type     => C_Content_Type,
         C_Content_Encoding => C_Content_Encoding,
         C_Correlation_Id   => C_Correlation_Id,
         C_Reply_To         => C_Reply_To,
         C_Expiration       => C_Expiration,
         C_Message_Id       => C_Message_Id,
         C_Message_Type     => C_Message_Type,
         C_User_Id          => C_User_Id,
         C_App_Id           => C_App_Id);

      Status := CB.amqp_basic_publish
        (state       => State,
         channel     => Chan,
         exchange    => To_Bytes (C_Exchange),
         routing_key => To_Bytes (C_Routing_Key),
         mandatory   => To_Bool (Mandatory),
         immediate   => To_Bool (Immediate),
         properties  => C_Props'Unchecked_Access,
         c_body      => To_Bytes (C_Body));

      if Status /= 0 then
         raise Exceptions.RabbitMQ_Error with "Failed to publish message";
      end if;
   end Publish;

   -------------
   -- Publish --
   -------------

   procedure Publish
     (Ch          : RabbitMQ.Channels.Channel'Class;
      Exchange    : String;
      Routing_Key : String;
      Data        : String;
      Mandatory   : Boolean := False;
      Immediate   : Boolean := False)
   is
   begin
      Publish (Ch, Exchange, Routing_Key,
               Messages.Text_Message (Data),
               Mandatory, Immediate);
   end Publish;

   ----------------------
   -- Publish_To_Queue --
   ----------------------

   procedure Publish_To_Queue
     (Ch        : RabbitMQ.Channels.Channel'Class;
      Queue     : String;
      Message   : RabbitMQ.Messages.Message;
      Mandatory : Boolean := False)
   is
   begin
      --  Use default exchange (empty string) with queue name as routing key
      Publish (Ch, "", Queue, Message, Mandatory, False);
   end Publish_To_Queue;

   ----------------------
   -- Publish_To_Queue --
   ----------------------

   procedure Publish_To_Queue
     (Ch        : RabbitMQ.Channels.Channel'Class;
      Queue     : String;
      Data      : String;
      Mandatory : Boolean := False)
   is
   begin
      Publish_To_Queue (Ch, Queue, Messages.Text_Message (Data), Mandatory);
   end Publish_To_Queue;

end RabbitMQ.Publishing;
