-- MySQL database system services using libmysqlclient

-- Copyright (C)2018, Philip Munts, President, Munts AM Corp.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.

WITH Ada.Environment_Variables; USE Ada.Environment_Variables;
WITH libLinux;
WITH libmysqlclient;

USE TYPE libmysqlclient.Pointer;

PACKAGE BODY MySQL.libmysqlclient IS

  -- Connect to a MySQL server, as specified by parameters

  PROCEDURE Connect
   (self   : IN OUT Server;
    dbhost : String;
    dbuser : String;
    dbpass : String;
    dbname : String  := "";
    dbport : Integer := 3306) IS

    error : Integer;

  BEGIN
    self.Disconnect;
    self.handle := Standard.libmysqlclient.Init;

    IF Standard.libmysqlclient.Connect(self.handle, dbhost, dbuser, dbpass,
      dbname, dbport) = Standard.libmysqlclient.NullPointer THEN
      error := Standard.libmysqlclient.errno(self.handle);

      self.Disconnect;

      RAISE MySQL.Error WITH "Connect() failed, error" &
        Integer'Image(error);
    END IF;
  END Connect;

  -- Connect to a server, as specified by DBHOST, DBUSER, DBPASS, DBNAME,
  -- and DBPORT environment variables

  PROCEDURE Connect(self : IN OUT Server) IS

    error : Integer;

  BEGIN
    self.Disconnect;
    self.handle := Standard.libmysqlclient.Init;

    IF Standard.libmysqlclient.Connect(self.handle,
      Value("DBHOST") & ASCII.NUL,
      Value("DBUSER") & ASCII.NUL,
      Value("DBPASS") & ASCII.NUL,
      (IF Exists("DBNAME") THEN Value("DBNAME") ELSE "") & ASCII.NUL,
      (IF Exists("DBPORT") THEN Integer'Value(Value("DBPORT")) ELSE 3306)) =
        Standard.libmysqlclient.NullPointer THEN
      error := Standard.libmysqlclient.errno(self.handle);

      self.Disconnect;

      RAISE MySQL.Error WITH "Connect() failed, error" &
        Integer'Image(error);
    END IF;
  END Connect;

  -- Disconnect from a MySQL server

  PROCEDURE Disconnect
   (self   : IN OUT Server) IS

  BEGIN
    IF self.handle /= Standard.libmysqlclient.NullPointer THEN
      Standard.libmysqlclient.Disconnect(self.handle);
      self.handle := Standard.libmysqlclient.NullPointer;
    END IF;
  END Disconnect;

  -- Issue a query command to the database server

  PROCEDURE Command(self : Server; cmd : String) IS

  BEGIN
    IF Standard.libmysqlclient.Query(self.handle, cmd & ASCII.NUL) /= 0 THEN
      RAISE MySQL.Error WITH "Query() failed, error" &
        Integer'Image(self.error);
    END IF;
  END Command;

  -- Call a stored procedure

  PROCEDURE Call(self : Server; proc : String; parms : String := "") IS

  BEGIN
    self.Command("CALL " & proc & "(" & parms & ")");
  END Call;

  -- Retrieve MySQL error code

  FUNCTION error(self : Server) RETURN Integer IS

  BEGIN
    RETURN Standard.libmysqlclient.errno(self.handle);
  END error;

  -- Initialize a server connection object

  PROCEDURE Initialize(self : IN OUT Server) IS

  BEGIN
    self.handle := Standard.libmysqlclient.NullPointer;
  END Initialize;

  -- Destroy a server connection object

  PROCEDURE Finalize(self : IN OUT Server) IS

  BEGIN
    self.Disconnect;
  END Finalize;

END MySQL.libmysqlclient;
