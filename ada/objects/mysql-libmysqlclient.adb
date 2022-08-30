-- MySQL database system services using libmysqlclient

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

WITH libmysqlclient; USE libmysqlclient;

PACKAGE BODY MySQL.libmysqlclient IS

  -- Create a MySQL server object

  FUNCTION Create
   (dbhost  : String; -- Domain name or Internet address
    dbuser  : String;
    dbpass  : String;
    dbname  : String   := "";
    dbport  : Positive := 3306;
    dbflags : Natural  := 0) RETURN Server IS

    s : ServerClass;

  BEGIN
    s.Connect(dbhost, dbuser, dbpass, dbname, dbport, dbflags);
    RETURN NEW ServerClass'(s);
  END Create;

  -- Connect to the specified MySQL server

  PROCEDURE Connect
   (Self    : IN OUT ServerClass;
    dbhost  : String; -- Domain name or Internet address
    dbuser  : String;
    dbpass  : String;
    dbname  : String   := "";
    dbport  : Positive := 3306;
    dbflags : Natural  := 0) IS

  BEGIN
    IF Self.handle /= NullMYSQL THEN
      RAISE MySQL.Error WITH ERROR_ALREADY_CONNECTED;
    END IF;

    Self := DestroyedServer;
    Self.handle := MySQL_Init;

    IF MySQL_Connect
     (Self.handle,
      dbhost & ASCII.NUL,
      dbuser & ASCII.NUL,
      dbpass & ASCII.NUL,
      dbname & ASCII.NUL,
      dbport, dbflags => dbflags) = NullMYSQL THEN
      RAISE MySQL.Error WITH ToString(MySQL_ErrorMessage(Self.handle));
    END IF;
  END Connect;

  -- Disconnect from a MySQL server

  PROCEDURE Disconnect
   (Self : IN OUT ServerClass) IS

  BEGIN
    IF Self.handle = NullMYSQL THEN
      RAISE MySQL.Error WITH ERROR_NO_CONNECTION;
    END IF;

    MySQL_Disconnect(Self.handle);
    Self := DestroyedServer;
  END Disconnect;

  -- Dispatch SQL to the server for execution

  PROCEDURE Dispatch(Self : ServerClass; cmd : String) IS

  BEGIN
    IF Self.handle = NullMYSQL THEN
      RAISE MySQL.Error WITH ERROR_NO_CONNECTION;
    END IF;

    IF Self.results /= NullMYSQL_RES THEN
      RAISE MySQL.Error WITH ERROR_MUST_FREE_RESULTS;
    END IF;

    IF MySQL_Query(Self.handle, cmd & ASCII.NUL) /= 0 THEN
      RAISE MySQL.Error WITH ToString(MySQL_ErrorMessage(Self.handle));
    END IF;
  END Dispatch;

  -- Fetch result set

  PROCEDURE FetchResults(Self : IN OUT ServerClass) IS

  BEGIN
    IF Self.handle = NullMYSQL THEN
      RAISE MySQL.Error WITH ERROR_NO_CONNECTION;
    END IF;

    IF Self.results /= NullMYSQL_RES THEN
      RAISE MySQL.Error WITH ERROR_MUST_FREE_RESULTS;
    END IF;

    Self.results := MySQL_FetchResults(Self.handle);

    IF Self.results = NullMYSQL_RES THEN
      Self.nrows   := 0;
      Self.ncols   := 0;
      Self.thisrow := NullMYSQL_ROW;

      IF MySQL_errno(Self.handle) /= 0 THEN
        RAISE MySQL.Error WITH ToString(MySQL_ErrorMessage(Self.handle));
      END IF;
    ELSE
      Self.nrows   := MySQL_NumRows(Self.results);
      Self.ncols   := MySQL_NumColumns(Self.results);
      Self.thisrow := NullMYSQL_ROW;
    END IF;
  END FetchResults;

  -- Try to fetch another result set

  PROCEDURE NextResults(Self : IN OUT ServerClass) IS

  BEGIN
    IF Self.handle = NullMYSQL THEN
      RAISE MySQL.Error WITH ERROR_NO_CONNECTION;
    END IF;

    IF Self.results = NullMYSQL_RES THEN
      RAISE MySQL.Error WITH ERROR_NO_RESULTS;
    END IF;

    Self.FreeResults;

    IF MySQL_NextResults(Self.handle) = 0 THEN
      Self.FetchResults;
    END IF;
  END NextResults;

  -- Discard result set

  PROCEDURE FreeResults(Self : IN OUT ServerClass) IS

  BEGIN
    IF Self.handle = NullMYSQL THEN
      RAISE MySQL.Error WITH ERROR_NO_CONNECTION;
    END IF;

    IF Self.results = NullMYSQL_RES THEN
      RAISE MySQL.Error WITH ERROR_NO_RESULTS;
    END IF;

    MySQL_FreeResults(Self.Results);

    Self.results := NullMySQL_RES;
    Self.thisrow := NullMYSQL_ROW;
    Self.nrows   := 0;
    Self.ncols   := 0;
  END FreeResults;

  FUNCTION Rows(Self : ServerClass) RETURN Natural IS

  BEGIN
    IF Self.handle = NullMYSQL THEN
      RAISE MySQL.Error WITH ERROR_NO_CONNECTION;
    END IF;

    RETURN Self.nrows;
  END Rows;

  -- Return number of columns in the result set

  FUNCTION Columns(Self : ServerClass) RETURN Natural IS

  BEGIN
    IF Self.handle = NullMYSQL THEN
      RAISE MySQL.Error WITH ERROR_NO_CONNECTION;
    END IF;

    RETURN Self.ncols;
  END Columns;

  -- Fetch the next row from the result set

  PROCEDURE FetchRow(Self : IN OUT ServerClass) IS

  BEGIN
    IF Self.handle = NullMYSQL THEN
      RAISE MySQL.Error WITH ERROR_NO_CONNECTION;
    END IF;

    IF Self.results = NullMYSQL_RES THEN
      RAISE MySQL.Error WITH ERROR_NO_RESULTS;
    END IF;

    Self.thisrow := MySQL_FetchRow(Self.results);

    IF Self.thisrow = NullMYSQL_ROW THEN
      RAISE MySQL.Error WITH ERROR_NO_ROWS;
    END IF;
  END FetchRow;

  -- Fetch a column from the current row

  FUNCTION FetchColumn(Self : ServerClass; index : Positive) RETURN String IS

  BEGIN
    IF Self.handle = NullMYSQL THEN
      RAISE MySQL.Error WITH ERROR_NO_CONNECTION;
    END IF;

    IF Self.results = NullMYSQL_RES THEN
      RAISE MySQL.Error WITH ERROR_NO_RESULTS;
    END IF;

    IF Self.thisrow = NullMYSQL_ROW THEN
      RAISE MySQL.Error WITH ERROR_NO_ROWS;
    END IF;

    RETURN ToString(MySQL_FetchColumn(Self.thisrow, index - 1));
  END FetchColumn;

END MySQL.libmysqlclient;
