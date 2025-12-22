--  RabbitMQ.Client.URLs - AMQP URL parser implementation

with Ada.Strings.Fixed;
with RabbitMQ.Exceptions;

package body RabbitMQ.Client.URLs is

   use Ada.Strings.Fixed;

   function Parse (URL : String) return Connection_Params is
      Result   : Connection_Params;
      Pos      : Natural;
      Rest     : Unbounded_String;
      Host_Part : Unbounded_String;

      function Find (S : Unbounded_String; C : Character) return Natural is
         Str : constant String := To_String (S);
      begin
         for I in Str'Range loop
            if Str (I) = C then
               return I - Str'First + 1;
            end if;
         end loop;
         return 0;
      end Find;

      function Slice_Before
        (S : Unbounded_String; Idx : Positive) return Unbounded_String is
      begin
         return To_Unbounded_String (Slice (S, 1, Idx - 1));
      end Slice_Before;

      function Slice_After
        (S : Unbounded_String; Idx : Positive) return Unbounded_String is
      begin
         if Idx >= Length (S) then
            return Null_Unbounded_String;
         end if;
         return To_Unbounded_String (Slice (S, Idx + 1, Length (S)));
      end Slice_After;

   begin
      --  Set defaults
      Result.User := To_Unbounded_String (Default_User);
      Result.Password := To_Unbounded_String (Default_Password);
      Result.Virtual_Host := To_Unbounded_String (Default_Vhost);
      Result.Use_TLS := False;
      Result.Port := Default_Port;

      --  Check for amqp:// or amqps:// scheme
      if URL'Length >= 7 and then URL (URL'First .. URL'First + 6) = "amqp://"
      then
         Result.Use_TLS := False;
         Result.Port := Default_Port;
         Rest := To_Unbounded_String (URL (URL'First + 7 .. URL'Last));
      elsif URL'Length >= 8
        and then URL (URL'First .. URL'First + 7) = "amqps://"
      then
         Result.Use_TLS := True;
         Result.Port := Default_TLS_Port;
         Rest := To_Unbounded_String (URL (URL'First + 8 .. URL'Last));
      else
         raise RabbitMQ.Exceptions.Invalid_URL
           with "URL must start with amqp:// or amqps://";
      end if;

      --  Empty host is invalid
      if Length (Rest) = 0 then
         raise RabbitMQ.Exceptions.Invalid_URL with "Missing host in URL";
      end if;

      --  Check for credentials (user:password@)
      Pos := Find (Rest, '@');
      if Pos > 0 then
         declare
            Creds : constant Unbounded_String := Slice_Before (Rest, Pos);
            Colon : constant Natural := Find (Creds, ':');
         begin
            if Colon > 0 then
               Result.User := Slice_Before (Creds, Colon);
               Result.Password := Slice_After (Creds, Colon);
            else
               Result.User := Creds;
               Result.Password := Null_Unbounded_String;
            end if;
         end;
         Rest := Slice_After (Rest, Pos);
      end if;

      --  Check for virtual host (/vhost)
      Pos := Find (Rest, '/');
      if Pos > 0 then
         Host_Part := Slice_Before (Rest, Pos);
         declare
            Vhost : constant Unbounded_String := Slice_After (Rest, Pos);
         begin
            if Length (Vhost) > 0 then
               Result.Virtual_Host := To_Unbounded_String ("/") & Vhost;
            else
               Result.Virtual_Host := To_Unbounded_String (Default_Vhost);
            end if;
         end;
      else
         Host_Part := Rest;
      end if;

      --  Parse host:port
      Pos := Find (Host_Part, ':');
      if Pos > 0 then
         Result.Host := Slice_Before (Host_Part, Pos);
         declare
            Port_Str : constant String :=
              To_String (Slice_After (Host_Part, Pos));
         begin
            Result.Port := Natural'Value (Port_Str);
         exception
            when Constraint_Error =>
               raise RabbitMQ.Exceptions.Invalid_URL
                 with "Invalid port number: " & Port_Str;
         end;
      else
         Result.Host := Host_Part;
      end if;

      --  Validate we have a host
      if Length (Result.Host) = 0 then
         raise RabbitMQ.Exceptions.Invalid_URL with "Missing host in URL";
      end if;

      return Result;
   end Parse;

end RabbitMQ.Client.URLs;
