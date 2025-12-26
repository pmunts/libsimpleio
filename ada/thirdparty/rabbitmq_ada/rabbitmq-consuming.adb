--  RabbitMQ Ada bindings - Message consuming implementation

with Interfaces.C;
with Interfaces;
with System;
with RabbitMQ.C_Binding;
with RabbitMQ.Exceptions;

package body RabbitMQ.Consuming is

   package CB renames C_Binding;

   use type Interfaces.C.int;
   use type Interfaces.C.size_t;
   use type Interfaces.Unsigned_8;
   use type Interfaces.Unsigned_32;
   use type Interfaces.Unsigned_64;
   use type CB.amqp_response_type_enum;

   --  Method ID for AMQP_BASIC_GET_OK_METHOD (from amqp_framing.h)
   AMQP_BASIC_GET_OK_METHOD : constant := 16#003C0047#;

   --  Define timeval since it's incomplete in the binding
   type C_Timeval is record
      tv_sec  : Interfaces.C.long;
      tv_usec : Interfaces.C.long;
   end record
   with Convention => C;

   --  Helper to convert Boolean to amqp_boolean_t
   function To_Bool (B : Boolean) return CB.amqp_boolean_t is
   begin
      if B then
         return 1;
      else
         return 0;
      end if;
   end To_Bool;

   --  Helper to create amqp_bytes_t from a char_array
   function To_Bytes
     (C_Str : Interfaces.C.char_array) return CB.amqp_bytes_t
   is
      Len : constant Interfaces.C.size_t :=
        Interfaces.C.To_Ada (C_Str)'Length;
   begin
      if Len = 0 then
         return CB.amqp_empty_bytes;
      end if;
      return (len   => Len,
              bytes => C_Str (C_Str'First)'Address);
   end To_Bytes;

   --  Helper to convert amqp_bytes_t to String
   function From_Bytes (Bytes : CB.amqp_bytes_t) return String is
      use type System.Address;
   begin
      if Bytes.len = 0 or else Bytes.bytes = System.Null_Address then
         return "";
      end if;

      declare
         subtype Constrained_String is String (1 .. Natural (Bytes.len));
         Result : Constrained_String;
         for Result'Address use Bytes.bytes;
         pragma Import (Ada, Result);
      begin
         return Result;
      end;
   end From_Bytes;

   --  Helper to convert C properties to Ada Message_Properties
   function To_Ada_Properties
     (C_Props : CB.amqp_basic_properties_t;
      Flags   : CB.amqp_flags_t) return Messages.Message_Properties
   is
      Props : Messages.Message_Properties;
   begin
      if (Flags and CB.AMQP_BASIC_CONTENT_TYPE_FLAG) /= 0 then
         Props.Content_Type :=
           SU.To_Unbounded_String (From_Bytes (C_Props.content_type));
      end if;

      if (Flags and CB.AMQP_BASIC_CONTENT_ENCODING_FLAG) /= 0 then
         Props.Content_Encoding :=
           SU.To_Unbounded_String (From_Bytes (C_Props.content_encoding));
      end if;

      if (Flags and CB.AMQP_BASIC_DELIVERY_MODE_FLAG) /= 0 then
         if C_Props.delivery_mode = 2 then
            Props.Delivery_Mode := Messages.Persistent;
         else
            Props.Delivery_Mode := Messages.Non_Persistent;
         end if;
      end if;

      if (Flags and CB.AMQP_BASIC_PRIORITY_FLAG) /= 0 then
         Props.Priority := Natural (C_Props.priority);
      end if;

      if (Flags and CB.AMQP_BASIC_CORRELATION_ID_FLAG) /= 0 then
         Props.Correlation_Id :=
           SU.To_Unbounded_String (From_Bytes (C_Props.correlation_id));
      end if;

      if (Flags and CB.AMQP_BASIC_REPLY_TO_FLAG) /= 0 then
         Props.Reply_To :=
           SU.To_Unbounded_String (From_Bytes (C_Props.reply_to));
      end if;

      if (Flags and CB.AMQP_BASIC_EXPIRATION_FLAG) /= 0 then
         Props.Expiration :=
           SU.To_Unbounded_String (From_Bytes (C_Props.expiration));
      end if;

      if (Flags and CB.AMQP_BASIC_MESSAGE_ID_FLAG) /= 0 then
         Props.Message_Id :=
           SU.To_Unbounded_String (From_Bytes (C_Props.message_id));
      end if;

      if (Flags and CB.AMQP_BASIC_TIMESTAMP_FLAG) /= 0 then
         Props.Timestamp := Natural (C_Props.timestamp);
      end if;

      if (Flags and CB.AMQP_BASIC_TYPE_FLAG) /= 0 then
         Props.Message_Type :=
           SU.To_Unbounded_String (From_Bytes (C_Props.c_type));
      end if;

      if (Flags and CB.AMQP_BASIC_USER_ID_FLAG) /= 0 then
         Props.User_Id :=
           SU.To_Unbounded_String (From_Bytes (C_Props.user_id));
      end if;

      if (Flags and CB.AMQP_BASIC_APP_ID_FLAG) /= 0 then
         Props.App_Id :=
           SU.To_Unbounded_String (From_Bytes (C_Props.app_id));
      end if;

      return Props;
   end To_Ada_Properties;

   --------------------
   -- Start_Consumer --
   --------------------

   function Start_Consumer
     (Ch           : RabbitMQ.Channels.Channel'Class;
      Queue        : String;
      Consumer_Tag : String := "";
      No_Local     : Boolean := False;
      No_Ack       : Boolean := False;
      Exclusive    : Boolean := False) return String
   is
      State : constant CB.amqp_connection_state_t :=
        Channels.Get_Connection_State (Ch);
      Chan  : constant CB.amqp_channel_t := Channels.Get_C_Channel (Ch);

      C_Queue : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Queue);
      C_Tag   : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Consumer_Tag);

      Result : access CB.amqp_basic_consume_ok_t;
      Reply  : CB.amqp_rpc_reply_t;
   begin
      Result := CB.amqp_basic_consume
        (state        => State,
         channel      => Chan,
         queue        => To_Bytes (C_Queue),
         consumer_tag => To_Bytes (C_Tag),
         no_local     => To_Bool (No_Local),
         no_ack       => To_Bool (No_Ack),
         exclusive    => To_Bool (Exclusive),
         arguments    => CB.amqp_empty_table);

      Reply := CB.amqp_get_rpc_reply (State);

      if Reply.reply_type /= CB.AMQP_RESPONSE_NORMAL then
         raise Exceptions.Channel_Error with "Failed to start consumer";
      end if;

      if Result = null then
         return "";
      end if;

      return From_Bytes (Result.consumer_tag);
   end Start_Consumer;

   ---------------------
   -- Consume_Message --
   ---------------------

   function Consume_Message
     (Ch         : RabbitMQ.Channels.Channel'Class;
      Msg        : out Delivery;
      Timeout_Ms : Natural := 0) return Boolean
   is
      State    : constant CB.amqp_connection_state_t :=
        Channels.Get_Connection_State (Ch);
      Envelope : aliased CB.amqp_envelope_t;
      Reply    : CB.amqp_rpc_reply_t;

      --  Local wrapper for amqp_consume_message with proper timeval
      function Consume_With_Timeout
        (S       : CB.amqp_connection_state_t;
         Env     : access CB.amqp_envelope_t;
         Timeout : access constant C_Timeval;
         Flags   : Interfaces.C.int) return CB.amqp_rpc_reply_t
      with Import => True,
           Convention => C,
           External_Name => "amqp_consume_message";

      --  Timeout structure
      TV     : aliased C_Timeval;
      TV_Ptr : access constant C_Timeval := null;
   begin
      if Timeout_Ms > 0 then
         TV.tv_sec := Interfaces.C.long (Timeout_Ms / 1000);
         TV.tv_usec := Interfaces.C.long ((Timeout_Ms mod 1000) * 1000);
         TV_Ptr := TV'Unchecked_Access;
      end if;

      Reply := Consume_With_Timeout
        (S       => State,
         Env     => Envelope'Unchecked_Access,
         Timeout => TV_Ptr,
         Flags   => 0);

      if Reply.reply_type /= CB.AMQP_RESPONSE_NORMAL then
         --  Check if it was a timeout
         if Reply.reply_type = CB.AMQP_RESPONSE_LIBRARY_EXCEPTION
           and then Reply.library_error =
             CB.amqp_status_enum_u_AMQP_STATUS_TIMEOUT
         then
            return False;
         end if;

         --  Other error
         if Reply.reply_type = CB.AMQP_RESPONSE_LIBRARY_EXCEPTION then
            raise Exceptions.RabbitMQ_Error with "Failed to consume message";
         else
            raise Exceptions.Channel_Error with "Failed to consume message";
         end if;
      end if;

      --  Convert envelope to Delivery
      Msg.Channel := Natural (Envelope.channel);
      Msg.Consumer_Tag :=
        SU.To_Unbounded_String (From_Bytes (Envelope.consumer_tag));
      Msg.Delivery_Tag := Natural (Envelope.delivery_tag);
      Msg.Redelivered := Envelope.redelivered /= 0;
      Msg.Exchange :=
        SU.To_Unbounded_String (From_Bytes (Envelope.exchange));
      Msg.Routing_Key :=
        SU.To_Unbounded_String (From_Bytes (Envelope.routing_key));

      --  Convert message body and properties
      Msg.Message.Content :=
        SU.To_Unbounded_String (From_Bytes (Envelope.message.c_body));
      Msg.Message.Properties :=
        To_Ada_Properties
          (Envelope.message.properties,
           Envelope.message.properties.u_flags);

      --  Clean up the envelope
      CB.amqp_destroy_envelope (Envelope'Unchecked_Access);

      return True;
   end Consume_Message;

   -----------------
   -- Get_Message --
   -----------------

   function Get_Message
     (Ch     : RabbitMQ.Channels.Channel'Class;
      Queue  : String;
      Msg    : out Delivery;
      No_Ack : Boolean := False) return Boolean
   is
      State : constant CB.amqp_connection_state_t :=
        Channels.Get_Connection_State (Ch);
      Chan  : constant CB.amqp_channel_t := Channels.Get_C_Channel (Ch);

      C_Queue : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Queue);

      Reply   : CB.amqp_rpc_reply_t;
      Message : aliased CB.amqp_message_t;
   begin
      Reply := CB.amqp_basic_get
        (state   => State,
         channel => Chan,
         queue   => To_Bytes (C_Queue),
         no_ack  => To_Bool (No_Ack));

      --  Check response
      if Reply.reply_type /= CB.AMQP_RESPONSE_NORMAL then
         raise Exceptions.Channel_Error with "Failed to get message";
      end if;

      --  Check if there was a message (AMQP_BASIC_GET_OK_METHOD vs GET_EMPTY)
      if Reply.reply.id /= AMQP_BASIC_GET_OK_METHOD then
         return False;  --  Queue was empty
      end if;

      --  Read the message content
      Reply := CB.amqp_read_message
        (state   => State,
         channel => Chan,
         message => Message'Unchecked_Access,
         flags   => 0);

      if Reply.reply_type /= CB.AMQP_RESPONSE_NORMAL then
         raise Exceptions.Channel_Error with "Failed to read message";
      end if;

      --  Extract delivery info from the get-ok reply
      --  Note: For basic.get, we need to extract from the decoded reply
      declare
         use type System.Address;
         Get_Ok : CB.amqp_basic_get_ok_t;
         for Get_Ok'Address use Reply.reply.decoded;
         pragma Import (Ada, Get_Ok);
      begin
         if Reply.reply.decoded /= System.Null_Address then
            Msg.Delivery_Tag := Natural (Get_Ok.delivery_tag);
            Msg.Redelivered := Get_Ok.redelivered /= 0;
            Msg.Exchange :=
              SU.To_Unbounded_String (From_Bytes (Get_Ok.exchange));
            Msg.Routing_Key :=
              SU.To_Unbounded_String (From_Bytes (Get_Ok.routing_key));
         end if;
      end;

      Msg.Channel := Natural (Chan);
      Msg.Consumer_Tag := SU.Null_Unbounded_String;  --  Not applicable for get

      --  Convert message body and properties
      Msg.Message.Content :=
        SU.To_Unbounded_String (From_Bytes (Message.c_body));
      Msg.Message.Properties :=
        To_Ada_Properties (Message.properties, Message.properties.u_flags);

      --  Clean up
      CB.amqp_destroy_message (Message'Unchecked_Access);

      return True;
   end Get_Message;

   ---------
   -- Ack --
   ---------

   procedure Ack
     (Ch           : RabbitMQ.Channels.Channel'Class;
      Delivery_Tag : Natural;
      Multiple     : Boolean := False)
   is
      State  : constant CB.amqp_connection_state_t :=
        Channels.Get_Connection_State (Ch);
      Chan   : constant CB.amqp_channel_t := Channels.Get_C_Channel (Ch);
      Status : Interfaces.C.int;
   begin
      Status := CB.amqp_basic_ack
        (state        => State,
         channel      => Chan,
         delivery_tag => Interfaces.Unsigned_64 (Delivery_Tag),
         multiple     => To_Bool (Multiple));

      if Status /= 0 then
         raise Exceptions.Channel_Error with "Failed to acknowledge message";
      end if;
   end Ack;

   ------------
   -- Reject --
   ------------

   procedure Reject
     (Ch             : RabbitMQ.Channels.Channel'Class;
      Delivery_Tag   : Natural;
      Should_Requeue : Boolean := True)
   is
      State  : constant CB.amqp_connection_state_t :=
        Channels.Get_Connection_State (Ch);
      Chan   : constant CB.amqp_channel_t := Channels.Get_C_Channel (Ch);
      Status : Interfaces.C.int;
   begin
      Status := CB.amqp_basic_reject
        (state        => State,
         channel      => Chan,
         delivery_tag => Interfaces.Unsigned_64 (Delivery_Tag),
         c_requeue    => To_Bool (Should_Requeue));

      if Status /= 0 then
         raise Exceptions.Channel_Error with "Failed to reject message";
      end if;
   end Reject;

   ----------
   -- Nack --
   ----------

   procedure Nack
     (Ch             : RabbitMQ.Channels.Channel'Class;
      Delivery_Tag   : Natural;
      Multiple       : Boolean := False;
      Should_Requeue : Boolean := True)
   is
      State  : constant CB.amqp_connection_state_t :=
        Channels.Get_Connection_State (Ch);
      Chan   : constant CB.amqp_channel_t := Channels.Get_C_Channel (Ch);
      Status : Interfaces.C.int;
   begin
      Status := CB.amqp_basic_nack
        (state        => State,
         channel      => Chan,
         delivery_tag => Interfaces.Unsigned_64 (Delivery_Tag),
         multiple     => To_Bool (Multiple),
         c_requeue    => To_Bool (Should_Requeue));

      if Status /= 0 then
         raise Exceptions.Channel_Error with "Failed to nack message";
      end if;
   end Nack;

   ---------------------
   -- Cancel_Consumer --
   ---------------------

   procedure Cancel_Consumer
     (Ch           : RabbitMQ.Channels.Channel'Class;
      Consumer_Tag : String)
   is
      State : constant CB.amqp_connection_state_t :=
        Channels.Get_Connection_State (Ch);
      Chan  : constant CB.amqp_channel_t := Channels.Get_C_Channel (Ch);

      C_Tag : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Consumer_Tag);

      Result : access CB.amqp_basic_cancel_ok_t;
      Reply  : CB.amqp_rpc_reply_t;
      pragma Unreferenced (Result);
   begin
      Result := CB.amqp_basic_cancel
        (state        => State,
         channel      => Chan,
         consumer_tag => To_Bytes (C_Tag));

      Reply := CB.amqp_get_rpc_reply (State);

      if Reply.reply_type /= CB.AMQP_RESPONSE_NORMAL then
         raise Exceptions.Channel_Error with "Failed to cancel consumer";
      end if;
   end Cancel_Consumer;

end RabbitMQ.Consuming;
