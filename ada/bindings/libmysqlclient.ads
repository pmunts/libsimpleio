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

  TYPE pMYSQL     IS NEW Interfaces.C.Strings.chars_ptr;
  TYPE pMYSQL_RES IS NEW Interfaces.C.Strings.chars_ptr;
  TYPE pMYSQL_ROW IS NEW Interfaces.C.Strings.chars_ptr;
  TYPE pMYSQL_COL IS NEW Interfaces.C.Strings.chars_ptr;
  TYPE pMYSQL_MSG IS NEW Interfaces.C.Strings.chars_ptr;

  -- Declare a NULL constant for each pointer type

  NullMYSQL     : CONSTANT pMYSQL     := pMYSQL(Interfaces.C.Strings.Null_Ptr);
  NullMYSQL_RES : CONSTANT pMYSQL_RES := pMYSQL_RES(Interfaces.C.Strings.Null_Ptr);
  NullMYSQL_ROW : CONSTANT pMYSQL_ROW := pMYSQL_ROW(Interfaces.C.Strings.Null_Ptr);
  NullMYSQL_COL : CONSTANT pMYSQL_COL := pMYSQL_COL(Interfaces.C.Strings.Null_Ptr);
  NullMYSQL_MSG : CONSTANT pMYSQL_MSG := pMYSQL_MSG(Interfaces.C.Strings.Null_Ptr);

  -- Initialize a database connection handle

  FUNCTION MySQL_Init(dummy : pMYSQL := NullMYSQL) RETURN pMYSQL;
    PRAGMA Import(C, MySQL_Init, "mysql_init");

  -- Connect to a database server

  FUNCTION MySQL_Connect
   (dbhandle : pMYSQL;
    dbhost   : String;
    dbuser   : String;
    dbpass   : String;
    dbname   : String;
    dbport   : Integer;
    dbsock   : Interfaces.C.Strings.chars_ptr := Interfaces.C.Strings.Null_Ptr;
    dbflags  : Integer := 0) RETURN pMYSQL;
    PRAGMA Import(C, MySQL_Connect, "mysql_real_connect");

  -- Disconnect from the database server

  PROCEDURE MySQL_Disconnect(dbhandle : pMYSQL);
    PRAGMA Import(C, MySQL_Disconnect, "mysql_close");

  -- Issue an SQL query or command

  FUNCTION MySQL_Query(dbhandle : pMYSQL; dbquery : String) RETURN Integer;
    PRAGMA Import(C, MySQL_Query, "mysql_query");

  -- Fetch a result set

  FUNCTION MySQL_FetchResults(dbhandle : pMYSQL) RETURN pMYSQL_RES;
    PRAGMA Import(C, MySQL_FetchResults, "mysql_store_result");

  -- See if another result set is available

  FUNCTION MySQL_NextResults(dbhandle : pMYSQL) RETURN Integer;
    PRAGMA Import(C, MySQL_NextResults, "mysql_next_result");

  -- Free a result set

  PROCEDURE MySQL_FreeResults(results : pMYSQL_RES);
    PRAGMA Import(C, MySQL_FreeResults, "mysql_free_result");

  -- Fetch the next row

  FUNCTION MySQL_FetchRow(results : pMYSQL_RES) RETURN pMYSQL_ROW;
    PRAGMA Import(C, MySQL_FetchRow, "mysql_fetch_row");

  -- Fetch a column from the current row

  FUNCTION MySQL_FetchColumn(row : pMYSQL_ROW; index : Natural) RETURN pMYSQL_COL;
    PRAGMA Import(C, MySQL_FetchColumn, "LINUX_indexpp");

  -- Fetch number of rows in the result set

  FUNCTION MySQL_NumRows(results : pMYSQL_RES) RETURN Integer;
    PRAGMA Import(C, MySQL_NumRows, "mysql_num_rows");

  -- Fetch number of columns in the result set

  FUNCTION MySQL_NumColumns(results : pMYSQL_RES) RETURN Integer;
    PRAGMA Import(C, MySQL_NumColumns, "mysql_num_fields");

  -- Retrieve last error number

  FUNCTION MySQL_errno(dbhandle : pMYSQL) RETURN Natural;
    PRAGMA Import(C, MySQL_errno, "mysql_errno");

  -- Retrieve last error message

  FUNCTION MySQL_ErrorMessage(dbhandle : pMYSQL) RETURN pMYSQL_MSG;
    PRAGMA Import(C, MySQL_ErrorMessage, "mysql_error");

  -- Convert column to String

  FUNCTION ToString(col : pMYSQL_COL) RETURN String IS
   (Interfaces.C.Strings.Value(Interfaces.C.Strings.chars_ptr(col)));

  -- Convert error message to String

  FUNCTION ToString(msg : pMYSQL_MSG) RETURN String IS
   (Interfaces.C.Strings.Value(Interfaces.C.Strings.chars_ptr(msg)));

END libmysqlclient;
