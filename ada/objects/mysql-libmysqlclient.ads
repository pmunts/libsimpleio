-- MySQL database system services

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

WITH Ada.Finalization;

PRIVATE WITH libmysqlclient;

PACKAGE MySQL.libmysqlclient IS

  TYPE Server IS NEW Ada.Finalization.Controlled WITH PRIVATE;

  -- Connect to a MySQL server, as specified by parameters

  PROCEDURE Connect
   (self   : IN OUT Server;
    dbhost : String;
    dbuser : String;
    dbpass : String;
    dbname : String  := "";
    dbport : Integer := 3306);

  -- Connect to a server, as specified by DBHOST, DBUSER, DBPASS, DBNAME,
  -- and DBPORT environment variables

  PROCEDURE Connect(self : IN OUT Server);

  -- Disconnect from a MySQL server

  PROCEDURE Disconnect(self : IN OUT Server);

  -- Issue a query command to the database server

  PROCEDURE Command(self : Server; cmd : String);

  -- Call a stored procedure

  PROCEDURE Call(self : Server; proc : String; parms : String := "");

  -- Retrieve MySQL error code

  FUNCTION error(self : Server) RETURN Integer;

  -- Initialize a server connection object

  PROCEDURE Initialize(self : IN OUT Server);

  -- Destroy a server connection object

  PROCEDURE Finalize(self : IN OUT Server);

PRIVATE

  TYPE Server IS NEW Ada.Finalization.Controlled WITH RECORD
    handle : Standard.libmysqlclient.Pointer;
  END RECORD;

END MySQL.libmysqlclient;
