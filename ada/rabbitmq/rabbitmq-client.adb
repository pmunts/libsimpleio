--  RabbitMQ.Client - High-level AMQP client implementation

with RabbitMQ.Client.URLs;
with RabbitMQ.Publishing;
with RabbitMQ.Queues;

package body RabbitMQ.Client is

   use type SU.Unbounded_String;

   ---------------------------------------------------------------------------
   --  Connection Management
   ---------------------------------------------------------------------------

   procedure Connect
     (C   : out Connection;
      URL : String;
      TLS : TLS_Config := No_TLS)
   is
      Params : constant URLs.Connection_Params := URLs.Parse (URL);
   begin
      if Params.Use_TLS then
         --  TLS connection
         declare
            TLS_Opts : RabbitMQ.Connections.TLS_Options;
         begin
            TLS_Opts.CA_Cert_Path := TLS.CA_Cert;
            TLS_Opts.Client_Cert := TLS.Client_Cert;
            TLS_Opts.Client_Key := TLS.Client_Key;
            TLS_Opts.Verify_Peer := TLS.Verify_Peer;
            TLS_Opts.Verify_Hostname := TLS.Verify_Hostname;

            RabbitMQ.Connections.Connect_TLS
              (Conn         => C.Conn,
               Host         => SU.To_String (Params.Host),
               Port         => Params.Port,
               User         => SU.To_String (Params.User),
               Password     => SU.To_String (Params.Password),
               Virtual_Host => SU.To_String (Params.Virtual_Host),
               TLS          => TLS_Opts);
         end;
      else
         --  Plain TCP connection
         RabbitMQ.Connections.Connect
           (Conn         => C.Conn,
            Host         => SU.To_String (Params.Host),
            Port         => Params.Port,
            User         => SU.To_String (Params.User),
            Password     => SU.To_String (Params.Password),
            Virtual_Host => SU.To_String (Params.Virtual_Host));
      end if;

      --  Open default channel
      RabbitMQ.Channels.Open (C.Channel, C.Conn, Number => 1);
   end Connect;

   function Is_Connected (C : Connection) return Boolean is
   begin
      return RabbitMQ.Connections.Is_Open (C.Conn)
        and then RabbitMQ.Channels.Is_Open (C.Channel);
   end Is_Connected;

   procedure Close (C : in out Connection) is
   begin
      --  Cancel any active subscription first
      if C.Subscribed then
         C.Subscribed := False;
      end if;

      --  Close channel before connection
      if RabbitMQ.Channels.Is_Open (C.Channel) then
         RabbitMQ.Channels.Close (C.Channel);
      end if;

      if RabbitMQ.Connections.Is_Open (C.Conn) then
         RabbitMQ.Connections.Close (C.Conn);
      end if;
   end Close;

   overriding procedure Finalize (C : in out Connection) is
   begin
      Close (C);
   end Finalize;

   ---------------------------------------------------------------------------
   --  Queue/Exchange Declaration
   ---------------------------------------------------------------------------

   procedure Declare_Queue
     (C           : Connection;
      Queue       : String;
      Durable     : Boolean := False;
      Exclusive   : Boolean := False;
      Auto_Delete : Boolean := False)
   is
      Info : RabbitMQ.Queues.Queue_Info;
      pragma Unreferenced (Info);
   begin
      Info := RabbitMQ.Queues.Declare_Queue
        (Ch          => C.Channel,
         Name        => Queue,
         Durable     => Durable,
         Exclusive   => Exclusive,
         Auto_Delete => Auto_Delete);
   end Declare_Queue;

   function Declare_Queue
     (C           : Connection;
      Durable     : Boolean := False;
      Exclusive   : Boolean := True;
      Auto_Delete : Boolean := True) return String
   is
      Info : constant RabbitMQ.Queues.Queue_Info :=
        RabbitMQ.Queues.Declare_Queue
          (Ch          => C.Channel,
           Name        => "",
           Durable     => Durable,
           Exclusive   => Exclusive,
           Auto_Delete => Auto_Delete);
   begin
      return Info.Name (1 .. Info.Name_Length);
   end Declare_Queue;

   procedure Declare_Exchange
     (C           : Connection;
      Exchange    : String;
      Kind        : String := RabbitMQ.Exchanges.Direct;
      Durable     : Boolean := False;
      Auto_Delete : Boolean := False)
   is
   begin
      RabbitMQ.Exchanges.Declare_Exchange
        (Ch          => C.Channel,
         Name        => Exchange,
         Kind        => Kind,
         Durable     => Durable,
         Auto_Delete => Auto_Delete);
   end Declare_Exchange;

   procedure Bind_Queue
     (C           : Connection;
      Queue       : String;
      Exchange    : String;
      Routing_Key : String := "")
   is
   begin
      RabbitMQ.Queues.Bind
        (Ch          => C.Channel,
         Queue       => Queue,
         Exchange    => Exchange,
         Routing_Key => Routing_Key);
   end Bind_Queue;

   ---------------------------------------------------------------------------
   --  Publishing
   ---------------------------------------------------------------------------

   procedure Publish
     (C       : Connection;
      Queue   : String;
      Message : String)
   is
   begin
      RabbitMQ.Publishing.Publish_To_Queue
        (Ch    => C.Channel,
         Queue => Queue,
         Data  => Message);
   end Publish;

   procedure Publish
     (C       : Connection;
      Queue   : String;
      Message : RabbitMQ.Messages.Message)
   is
   begin
      RabbitMQ.Publishing.Publish_To_Queue
        (Ch      => C.Channel,
         Queue   => Queue,
         Message => Message);
   end Publish;

   procedure Publish
     (C           : Connection;
      Exchange    : String;
      Routing_Key : String;
      Message     : String)
   is
   begin
      RabbitMQ.Publishing.Publish
        (Ch          => C.Channel,
         Exchange    => Exchange,
         Routing_Key => Routing_Key,
         Data        => Message);
   end Publish;

   procedure Publish
     (C           : Connection;
      Exchange    : String;
      Routing_Key : String;
      Message     : RabbitMQ.Messages.Message)
   is
   begin
      RabbitMQ.Publishing.Publish
        (Ch          => C.Channel,
         Exchange    => Exchange,
         Routing_Key => Routing_Key,
         Message     => Message);
   end Publish;

   ---------------------------------------------------------------------------
   --  Subscription
   ---------------------------------------------------------------------------

   procedure Subscribe
     (C       : in out Connection;
      Queue   : String;
      Handler : Message_Handler)
   is
      Tag      : constant String :=
        RabbitMQ.Consuming.Start_Consumer
          (Ch     => C.Channel,
           Queue  => Queue,
           No_Ack => True);
      Delivery : RabbitMQ.Consuming.Delivery;
      Got_Msg  : Boolean;
   begin
      C.Consumer_Tag := SU.To_Unbounded_String (Tag);
      C.Subscribed := True;

      --  Blocking consume loop
      while C.Subscribed loop
         Got_Msg := RabbitMQ.Consuming.Consume_Message
           (Ch         => C.Channel,
            Msg        => Delivery,
            Timeout_Ms => 1000);  --  Check Subscribed flag every second

         if Got_Msg then
            Handler (Delivery.Message);
         end if;
      end loop;

      --  Clean up consumer
      if SU.Length (C.Consumer_Tag) > 0 then
         RabbitMQ.Consuming.Cancel_Consumer
           (Ch           => C.Channel,
            Consumer_Tag => SU.To_String (C.Consumer_Tag));
         C.Consumer_Tag := SU.Null_Unbounded_String;
      end if;
   end Subscribe;

   procedure Subscribe
     (C       : in out Connection;
      Queue   : String;
      Handler : Ack_Message_Handler)
   is
      Tag      : constant String :=
        RabbitMQ.Consuming.Start_Consumer
          (Ch     => C.Channel,
           Queue  => Queue,
           No_Ack => False);
      Delivery     : RabbitMQ.Consuming.Delivery;
      Got_Msg      : Boolean;
      Current_Tag  : Natural := 0;

      procedure Do_Ack is
      begin
         RabbitMQ.Consuming.Ack
           (Ch           => C.Channel,
            Delivery_Tag => Current_Tag);
      end Do_Ack;

      procedure Do_Reject is
      begin
         RabbitMQ.Consuming.Reject
           (Ch             => C.Channel,
            Delivery_Tag   => Current_Tag,
            Should_Requeue => True);
      end Do_Reject;

   begin
      C.Consumer_Tag := SU.To_Unbounded_String (Tag);
      C.Subscribed := True;

      --  Blocking consume loop
      while C.Subscribed loop
         Got_Msg := RabbitMQ.Consuming.Consume_Message
           (Ch         => C.Channel,
            Msg        => Delivery,
            Timeout_Ms => 1000);

         if Got_Msg then
            Current_Tag := Delivery.Delivery_Tag;
            Handler (Delivery, Do_Ack'Access, Do_Reject'Access);
         end if;
      end loop;

      --  Clean up consumer
      if SU.Length (C.Consumer_Tag) > 0 then
         RabbitMQ.Consuming.Cancel_Consumer
           (Ch           => C.Channel,
            Consumer_Tag => SU.To_String (C.Consumer_Tag));
         C.Consumer_Tag := SU.Null_Unbounded_String;
      end if;
   end Subscribe;

   procedure Unsubscribe (C : in out Connection) is
   begin
      C.Subscribed := False;
   end Unsubscribe;

end RabbitMQ.Client;
