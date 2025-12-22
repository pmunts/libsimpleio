--  RabbitMQ Ada bindings - Message types implementation

package body RabbitMQ.Messages is

   ------------------
   -- Text_Message --
   ------------------

   function Text_Message (Data : String) return Message is
   begin
      return Create (Data, "text/plain");
   end Text_Message;

   ------------
   -- Create --
   ------------

   function Create
     (Data         : String;
      Content_Type : String := "application/octet-stream") return Message
   is
   begin
      return (Content    => SU.To_Unbounded_String (Data),
              Properties =>
                (Content_Type => SU.To_Unbounded_String (Content_Type),
                 others       => <>));
   end Create;

   ------------------------
   -- Persistent_Message --
   ------------------------

   function Persistent_Message
     (Data         : String;
      Content_Type : String := "application/octet-stream") return Message
   is
   begin
      return (Content    => SU.To_Unbounded_String (Data),
              Properties =>
                (Content_Type  => SU.To_Unbounded_String (Content_Type),
                 Delivery_Mode => Persistent,
                 others        => <>));
   end Persistent_Message;

   -----------------
   -- Get_Content --
   -----------------

   function Get_Content (Msg : Message) return String is
   begin
      return SU.To_String (Msg.Content);
   end Get_Content;

   -----------------
   -- Set_Content --
   -----------------

   procedure Set_Content (Msg : in out Message; Data : String) is
   begin
      Msg.Content := SU.To_Unbounded_String (Data);
   end Set_Content;

end RabbitMQ.Messages;
