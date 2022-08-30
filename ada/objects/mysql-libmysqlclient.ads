-- MySQL database system services

-- Copyright (C)2018-2022, Philip Munts, President, Munts AM Corp.
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

PRIVATE WITH libmysqlclient;

PACKAGE MySQL.libmysqlclient IS

  TYPE ServerClass IS TAGGED PRIVATE;

  TYPE Server IS ACCESS ALL ServerClass'Class;

  -- Create a MySQL server object

  FUNCTION Create
   (dbhost  : String; -- Domain name or Internet address
    dbuser  : String;
    dbpass  : String;
    dbname  : String   := "";
    dbport  : Positive := 3306;
    dbflags : Natural  := 0) RETURN Server;

  -- Connect to the specified MySQL server

  PROCEDURE Connect
   (Self    : IN OUT ServerClass;
    dbhost  : String; -- Domain name or Internet address
    dbuser  : String;
    dbpass  : String;
    dbname  : String   := "";
    dbport  : Positive := 3306;
    dbflags : Natural  := 0);

  -- Disconnect from a MySQL server

  PROCEDURE Disconnect(Self : IN OUT ServerClass);

  -- Dispatch SQL to the server for execution

  PROCEDURE Dispatch(Self : ServerClass; cmd : String);

  -- Fetch result set

  PROCEDURE FetchResults(Self : IN OUT ServerClass);

  -- Try to fetch another result set

  PROCEDURE NextResults(Self : IN OUT ServerClass);

  -- Discard result set

  PROCEDURE FreeResults(Self : IN OUT ServerClass);

  -- Return number of rows in the result set

  FUNCTION Rows(Self : ServerClass) RETURN Natural;

  -- Return number of columns in the result set

  FUNCTION Columns(Self : ServerClass) RETURN Natural;

  -- Fetch the next row from the result set

  PROCEDURE FetchRow(Self : IN OUT ServerClass);

  -- Fetch a column from the current row

  FUNCTION FetchColumn(Self : ServerClass; index : Positive) RETURN String;

  -- Possible exception messages

  ERROR_ALREADY_CONNECTED : CONSTANT String := "Already connected to a database server.";
  ERROR_MUST_FREE_RESULTS : CONSTANT String := "Must free previous result set.";
  ERROR_NO_CONNECTION     : CONSTANT String := "Not connected to a database server.";
  ERROR_NO_RESULTS        : CONSTANT String := "No results are available.";
  ERROR_NO_ROWS           : CONSTANT String := "No more rows are available.";

PRIVATE

  USE Standard.libmysqlclient;

  TYPE ServerClass IS TAGGED RECORD
    handle  : pMYSQL     := NullMYSQL;
    results : pMYSQL_RES := NullMYSQL_RES;
    thisrow : pMYSQL_ROW := NullMYSQL_ROW;
    nrows   : Integer    := 0;
    ncols   : Integer    := 0;
  END RECORD;

  DestroyedServer : CONSTANT ServerClass := (NullMYSQL, NullMYSQL_RES, NullMYSQL_ROW, 0, 0);

END MySQL.libmysqlclient;
