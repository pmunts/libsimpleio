-- Super-thin binding to MySQL Connector/C client library

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

-- String actual parameters *MUST* be NUL terminated, e.g. "FOO" & ASCII.NUL

WITH Interfaces.C.Strings;

PACKAGE libmysqlclient IS
  PRAGMA Link_With("-lmysqlclient");
  PRAGMA Link_With("-lsimpleio");

  -- libmysqlclient has a myriad of pointer types

  TYPE MYSQL     IS NEW Interfaces.C.Strings.chars_ptr;
  TYPE MYSQL_RES IS NEW Interfaces.C.Strings.chars_ptr;
  TYPE MYSQL_ROW IS NEW Interfaces.C.Strings.chars_ptr;
  TYPE MYSQL_COL IS NEW Interfaces.C.Strings.chars_ptr;
  TYPE MYSQL_MSG IS NEW Interfaces.C.Strings.chars_ptr;

  -- Declare a NULL constant for each pointer type

  NullMYSQL     : CONSTANT MYSQL     := MYSQL(Interfaces.C.Strings.Null_Ptr);
  NullMYSQL_RES : CONSTANT MYSQL_RES := MYSQL_RES(Interfaces.C.Strings.Null_Ptr);
  NullMYSQL_ROW : CONSTANT MYSQL_ROW := MYSQL_ROW(Interfaces.C.Strings.Null_Ptr);
  NullMYSQL_COL : CONSTANT MYSQL_COL := MYSQL_COL(Interfaces.C.Strings.Null_Ptr);
  NullMYSQL_MSG : CONSTANT MYSQL_MSG := MYSQL_MSG(Interfaces.C.Strings.Null_Ptr);

  -- Initialize a database connection handle

  FUNCTION Init(dummy : MYSQL := NullMYSQL) RETURN MYSQL;
    PRAGMA Import(C, Init, "mysql_init");

  -- Connect to a database server

  FUNCTION Connect
   (dbhandle : MYSQL;
    dbhost   : String;
    dbuser   : String;
    dbpass   : String;
    dbname   : String  := "" & ASCII.NUL;
    dbport   : Integer := 3306;
    dbsock   : MYSQL := NullMYSQL;
    dbflags  : Integer := 0) RETURN MYSQL;
    PRAGMA Import(C, Connect, "mysql_real_connect");

  -- Disconnect from the database server

  PROCEDURE Disconnect(dbhandle : MYSQL);
    PRAGMA Import(C, Disconnect, "mysql_close");

  -- Change the default database

  FUNCTION SelectDatabase(dbhandle : MYSQL; dbname : String) RETURN Integer;
    PRAGMA Import(C, SelectDatabase, "mysql_select_db");

  -- Issue a query

  FUNCTION Query(dbhandle : MYSQL; dbquery : String) RETURN Integer;
    PRAGMA Import(C, Query, "mysql_query");

  -- Fetch the result set

  FUNCTION FetchResults(dbhandle : MYSQL) RETURN MYSQL_RES;
    PRAGMA Import(C, FetchResults, "mysql_use_result");

  -- Free the result set

  PROCEDURE FreeResults(results : MYSQL_RES);
    PRAGMA Import(C, FreeResults, "mysql_free_result");

  -- Fetch the next row

  FUNCTION FetchRow(results : MYSQL_RES) RETURN MYSQL_ROW;
    PRAGMA Import(C, FetchRow, "mysql_fetch_row");

  -- Fetch a column from the current row

  FUNCTION FetchColumn(row : MYSQL_ROW; index : Natural) RETURN MYSQL_COL;
    PRAGMA Import(C, FetchColumn, "LINUX_indexpp");

  -- Fetch number of rows in the result set

  FUNCTION NumRows(results : MYSQL_RES) RETURN Integer;
    PRAGMA Import(C, NumRows, "mysql_num_rows");

  -- Fetch number of columns in the result set

  FUNCTION NumColumns(results : MYSQL_RES) RETURN Integer;
    PRAGMA Import(C, NumColumns, "mysql_num_fields");

  -- Retrieve last error number

  FUNCTION errno(dbhandle : MYSQL) RETURN Integer;
    PRAGMA Import(C, errno, "mysql_errno");

  -- Retrieve last error message

  FUNCTION Error(dbhandle : MYSQL) RETURN MYSQL_MSG;
    PRAGMA Import(C, error, "mysql_error");

  -- Convert column to String

  FUNCTION ToString(col : MYSQL_COL) RETURN String IS
   (Interfaces.C.Strings.Value(Interfaces.C.Strings.chars_ptr(col)));

  -- Convert error message to String

  FUNCTION ToString(msg : MYSQL_MSG) RETURN String IS
   (Interfaces.C.Strings.Value(Interfaces.C.Strings.chars_ptr(msg)));

END libmysqlclient;
