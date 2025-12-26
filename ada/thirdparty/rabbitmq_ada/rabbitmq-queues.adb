--  RabbitMQ Ada bindings - Queue management implementation

with Interfaces.C;
with RabbitMQ.C_Binding;
with RabbitMQ.Exceptions;

package body RabbitMQ.Queues is

   package CB renames C_Binding;

   use type Interfaces.C.size_t;
   use type CB.amqp_response_type_enum;

   --  Helper to create amqp_bytes_t from a char_array
   --  The char_array must remain valid for the duration of use
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

   --  Helper to convert amqp_bytes_t to Ada String
   function From_Bytes (B : CB.amqp_bytes_t) return String is
   begin
      if B.len = 0 then
         return "";
      end if;
      declare
         Len : constant Natural := Natural (B.len);
         subtype Bounded_String is String (1 .. Len);
         Result : Bounded_String
           with Import, Address => B.bytes;
      begin
         return Result;
      end;
   end From_Bytes;

   --  Helper to check RPC reply and raise exception on error
   procedure Check_RPC_Reply
     (State   : CB.amqp_connection_state_t;
      Context : String)
   is
      Reply : constant CB.amqp_rpc_reply_t := CB.amqp_get_rpc_reply (State);
   begin
      case Reply.reply_type is
         when CB.AMQP_RESPONSE_NORMAL =>
            null;  --  Success

         when CB.AMQP_RESPONSE_NONE =>
            raise Exceptions.Protocol_Error
              with Context & ": missing RPC reply";

         when CB.AMQP_RESPONSE_LIBRARY_EXCEPTION =>
            raise Exceptions.RabbitMQ_Error
              with Context & ": library error";

         when CB.AMQP_RESPONSE_SERVER_EXCEPTION =>
            raise Exceptions.Protocol_Error
              with Context & ": server exception";
      end case;
   end Check_RPC_Reply;

   --  Helper to convert Boolean to amqp_boolean_t
   function To_Bool (B : Boolean) return CB.amqp_boolean_t is
   begin
      if B then
         return 1;
      else
         return 0;
      end if;
   end To_Bool;

   -------------------
   -- Declare_Queue --
   -------------------

   function Declare_Queue
     (Ch          : RabbitMQ.Channels.Channel'Class;
      Name        : String := "";
      Passive     : Boolean := False;
      Durable     : Boolean := False;
      Exclusive   : Boolean := False;
      Auto_Delete : Boolean := False) return Queue_Info
   is
      State  : constant CB.amqp_connection_state_t :=
        Channels.Get_Connection_State (Ch);
      Chan   : constant CB.amqp_channel_t := Channels.Get_C_Channel (Ch);
      Result : access CB.amqp_queue_declare_ok_t;
      Info   : Queue_Info := (Name           => (others => ' '),
                              Name_Length    => 0,
                              Message_Count  => 0,
                              Consumer_Count => 0);

      --  Stack-allocated C string - remains valid for this scope
      C_Name : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Name);
   begin
      Result := CB.amqp_queue_declare
        (state       => State,
         channel     => Chan,
         queue       => To_Bytes (C_Name),
         passive     => To_Bool (Passive),
         durable     => To_Bool (Durable),
         exclusive   => To_Bool (Exclusive),
         auto_delete => To_Bool (Auto_Delete),
         arguments   => CB.amqp_empty_table);

      Check_RPC_Reply (State, "Failed to declare queue");

      if Result /= null then
         declare
            Queue_Name : constant String := From_Bytes (Result.queue);
         begin
            Info.Name_Length := Natural'Min (Queue_Name'Length, 256);
            Info.Name (1 .. Info.Name_Length) :=
              Queue_Name (Queue_Name'First ..
                          Queue_Name'First + Info.Name_Length - 1);
         end;
         Info.Message_Count := Natural (Result.message_count);
         Info.Consumer_Count := Natural (Result.consumer_count);
      end if;

      return Info;
   end Declare_Queue;

   ----------
   -- Bind --
   ----------

   procedure Bind
     (Ch          : RabbitMQ.Channels.Channel'Class;
      Queue       : String;
      Exchange    : String;
      Routing_Key : String := "")
   is
      State  : constant CB.amqp_connection_state_t :=
        Channels.Get_Connection_State (Ch);
      Chan   : constant CB.amqp_channel_t := Channels.Get_C_Channel (Ch);
      Result : access CB.amqp_queue_bind_ok_t;
      pragma Unreferenced (Result);

      --  Stack-allocated C strings
      C_Queue       : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Queue);
      C_Exchange    : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Exchange);
      C_Routing_Key : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Routing_Key);
   begin
      Result := CB.amqp_queue_bind
        (state       => State,
         channel     => Chan,
         queue       => To_Bytes (C_Queue),
         exchange    => To_Bytes (C_Exchange),
         routing_key => To_Bytes (C_Routing_Key),
         arguments   => CB.amqp_empty_table);

      Check_RPC_Reply (State, "Failed to bind queue");
   end Bind;

   ------------
   -- Unbind --
   ------------

   procedure Unbind
     (Ch          : RabbitMQ.Channels.Channel'Class;
      Queue       : String;
      Exchange    : String;
      Routing_Key : String := "")
   is
      State  : constant CB.amqp_connection_state_t :=
        Channels.Get_Connection_State (Ch);
      Chan   : constant CB.amqp_channel_t := Channels.Get_C_Channel (Ch);
      Result : access CB.amqp_queue_unbind_ok_t;
      pragma Unreferenced (Result);

      --  Stack-allocated C strings
      C_Queue       : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Queue);
      C_Exchange    : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Exchange);
      C_Routing_Key : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Routing_Key);
   begin
      Result := CB.amqp_queue_unbind
        (state       => State,
         channel     => Chan,
         queue       => To_Bytes (C_Queue),
         exchange    => To_Bytes (C_Exchange),
         routing_key => To_Bytes (C_Routing_Key),
         arguments   => CB.amqp_empty_table);

      Check_RPC_Reply (State, "Failed to unbind queue");
   end Unbind;

   -----------
   -- Purge --
   -----------

   function Purge
     (Ch    : RabbitMQ.Channels.Channel'Class;
      Queue : String) return Natural
   is
      State  : constant CB.amqp_connection_state_t :=
        Channels.Get_Connection_State (Ch);
      Chan   : constant CB.amqp_channel_t := Channels.Get_C_Channel (Ch);
      Result : access CB.amqp_queue_purge_ok_t;

      --  Stack-allocated C string
      C_Queue : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Queue);
   begin
      Result := CB.amqp_queue_purge
        (state   => State,
         channel => Chan,
         queue   => To_Bytes (C_Queue));

      Check_RPC_Reply (State, "Failed to purge queue");

      if Result /= null then
         return Natural (Result.message_count);
      else
         return 0;
      end if;
   end Purge;

   ------------
   -- Delete --
   ------------

   function Delete
     (Ch        : RabbitMQ.Channels.Channel'Class;
      Queue     : String;
      If_Unused : Boolean := False;
      If_Empty  : Boolean := False) return Natural
   is
      State  : constant CB.amqp_connection_state_t :=
        Channels.Get_Connection_State (Ch);
      Chan   : constant CB.amqp_channel_t := Channels.Get_C_Channel (Ch);
      Result : access CB.amqp_queue_delete_ok_t;

      --  Stack-allocated C string
      C_Queue : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Queue);
   begin
      Result := CB.amqp_queue_delete
        (state     => State,
         channel   => Chan,
         queue     => To_Bytes (C_Queue),
         if_unused => To_Bool (If_Unused),
         if_empty  => To_Bool (If_Empty));

      Check_RPC_Reply (State, "Failed to delete queue");

      if Result /= null then
         return Natural (Result.message_count);
      else
         return 0;
      end if;
   end Delete;

   procedure Delete
     (Ch        : RabbitMQ.Channels.Channel'Class;
      Queue     : String;
      If_Unused : Boolean := False;
      If_Empty  : Boolean := False)
   is
      Ignored : Natural;
      pragma Unreferenced (Ignored);
   begin
      Ignored := Delete (Ch, Queue, If_Unused, If_Empty);
   end Delete;

end RabbitMQ.Queues;
