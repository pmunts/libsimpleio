-- MySQL Client Test

-- Copyright (C)2022, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Ada.Calendar.Formatting;
WITH Ada.Command_Line;

WITH MySQL.libmysqlclient;

PROCEDURE test_mysql IS

  server : MySQL.libmysqlclient.Server;

BEGIN
  New_Line;
  Put_Line("MySQL Client Test");
  New_Line;

  IF Ada.Command_Line.Argument_Count /= 4 THEN
    Put_Line("Usage: <server> <username> <password> <database>");
    New_Line;
    RETURN;
  END IF;

  -- Connect to the database server
 
  server := MySQL.libmysqlclient.Create
   (Ada.Command_Line.Argument(1),
    Ada.Command_Line.Argument(2),
    Ada.Command_Line.Argument(3),
    Ada.Command_line.Argument(4));

  LOOP
    -- Issue a command

    Put("Enter SQL command: ");

    DECLARE

      cmd : String := Get_Line;

    BEGIN
      EXIT WHEN cmd = "quit";
      server.Dispatch(Get_Line);
    END;

    New_Line;

    -- Fetch results (if any)
  
    server.FetchResults;

    LOOP
      EXIT WHEN server.Rows = 0;

      Put_Line("Rows:" & Natural'Image(server.Rows));
      Put_Line("Cols:" & Natural'Image(server.Columns));
      New_Line;

      FOR i IN 1 .. server.Rows LOOP
        server.FetchRow;

        FOR j IN 1 .. server.Columns LOOP
          Put(server.FetchColumn(j));
          Put(' ');
        END LOOP;

        New_Line;
      END LOOP;

      server.NextResults;
    END LOOP;
  END LOOP;

  server.Disconnect;
END test_mysql;
