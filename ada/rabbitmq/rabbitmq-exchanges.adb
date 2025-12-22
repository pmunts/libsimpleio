--  RabbitMQ Ada bindings - Exchange management implementation

with Interfaces.C;
with RabbitMQ.C_Binding;
with RabbitMQ.Exceptions;

package body RabbitMQ.Exchanges is

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

   ----------------------
   -- Declare_Exchange --
   ----------------------

   procedure Declare_Exchange
     (Ch          : RabbitMQ.Channels.Channel'Class;
      Name        : String;
      Kind        : String := Direct;
      Passive     : Boolean := False;
      Durable     : Boolean := False;
      Auto_Delete : Boolean := False;
      Internal    : Boolean := False)
   is
      State  : constant CB.amqp_connection_state_t :=
        Channels.Get_Connection_State (Ch);
      Chan   : constant CB.amqp_channel_t := Channels.Get_C_Channel (Ch);
      Result : access CB.amqp_exchange_declare_ok_t;
      pragma Unreferenced (Result);

      --  Stack-allocated C strings
      C_Name : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Name);
      C_Kind : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Kind);
   begin
      Result := CB.amqp_exchange_declare
        (state       => State,
         channel     => Chan,
         exchange    => To_Bytes (C_Name),
         c_type      => To_Bytes (C_Kind),
         passive     => To_Bool (Passive),
         durable     => To_Bool (Durable),
         auto_delete => To_Bool (Auto_Delete),
         internal    => To_Bool (Internal),
         arguments   => CB.amqp_empty_table);

      Check_RPC_Reply (State, "Failed to declare exchange");
   end Declare_Exchange;

   ------------
   -- Delete --
   ------------

   procedure Delete
     (Ch        : RabbitMQ.Channels.Channel'Class;
      Name      : String;
      If_Unused : Boolean := False)
   is
      State  : constant CB.amqp_connection_state_t :=
        Channels.Get_Connection_State (Ch);
      Chan   : constant CB.amqp_channel_t := Channels.Get_C_Channel (Ch);
      Result : access CB.amqp_exchange_delete_ok_t;
      pragma Unreferenced (Result);

      --  Stack-allocated C string
      C_Name : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Name);
   begin
      Result := CB.amqp_exchange_delete
        (state     => State,
         channel   => Chan,
         exchange  => To_Bytes (C_Name),
         if_unused => To_Bool (If_Unused));

      Check_RPC_Reply (State, "Failed to delete exchange");
   end Delete;

   ----------
   -- Bind --
   ----------

   procedure Bind
     (Ch          : RabbitMQ.Channels.Channel'Class;
      Destination : String;
      Source      : String;
      Routing_Key : String := "")
   is
      State  : constant CB.amqp_connection_state_t :=
        Channels.Get_Connection_State (Ch);
      Chan   : constant CB.amqp_channel_t := Channels.Get_C_Channel (Ch);
      Result : access CB.amqp_exchange_bind_ok_t;
      pragma Unreferenced (Result);

      --  Stack-allocated C strings
      C_Destination : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Destination);
      C_Source      : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Source);
      C_Routing_Key : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Routing_Key);
   begin
      Result := CB.amqp_exchange_bind
        (state       => State,
         channel     => Chan,
         destination => To_Bytes (C_Destination),
         source      => To_Bytes (C_Source),
         routing_key => To_Bytes (C_Routing_Key),
         arguments   => CB.amqp_empty_table);

      Check_RPC_Reply (State, "Failed to bind exchange");
   end Bind;

   ------------
   -- Unbind --
   ------------

   procedure Unbind
     (Ch          : RabbitMQ.Channels.Channel'Class;
      Destination : String;
      Source      : String;
      Routing_Key : String := "")
   is
      State  : constant CB.amqp_connection_state_t :=
        Channels.Get_Connection_State (Ch);
      Chan   : constant CB.amqp_channel_t := Channels.Get_C_Channel (Ch);
      Result : access CB.amqp_exchange_unbind_ok_t;
      pragma Unreferenced (Result);

      --  Stack-allocated C strings
      C_Destination : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Destination);
      C_Source      : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Source);
      C_Routing_Key : aliased constant Interfaces.C.char_array :=
        Interfaces.C.To_C (Routing_Key);
   begin
      Result := CB.amqp_exchange_unbind
        (state       => State,
         channel     => Chan,
         destination => To_Bytes (C_Destination),
         source      => To_Bytes (C_Source),
         routing_key => To_Bytes (C_Routing_Key),
         arguments   => CB.amqp_empty_table);

      Check_RPC_Reply (State, "Failed to unbind exchange");
   end Unbind;

end RabbitMQ.Exchanges;
