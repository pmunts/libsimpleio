--  RabbitMQ Ada bindings - Exception definitions
--  Maps librabbitmq error codes to Ada exceptions

package RabbitMQ.Exceptions is

   --  Base exception for all RabbitMQ errors
   RabbitMQ_Error : exception;

   --  Connection-related exceptions
   Connection_Error : exception;
   Connection_Closed : exception;
   Hostname_Resolution_Failed : exception;
   Incompatible_Protocol_Version : exception;
   Authentication_Error : exception;

   --  Channel-related exceptions
   Channel_Error : exception;

   --  Socket/network exceptions
   Socket_Error : exception;
   Socket_Closed : exception;
   Timeout_Error : exception;
   Heartbeat_Timeout : exception;

   --  Protocol exceptions
   Protocol_Error : exception;
   Frame_Error : exception;
   Unexpected_State : exception;

   --  Resource exceptions
   No_Memory : exception;
   Table_Too_Big : exception;
   Invalid_Parameter : exception;

   --  SSL exceptions
   SSL_Error : exception;

   --  Broker-side exceptions (from server responses)
   Access_Refused : exception;
   Not_Found : exception;
   Resource_Locked : exception;
   Precondition_Failed : exception;

   --  URL parsing exceptions
   Invalid_URL : exception;

end RabbitMQ.Exceptions;
