-- Super-thin binding to MySQL Connector/C client library

-- Copyright (C)2018-2021, Philip Munts, President, Munts AM Corp.
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

-- NOTE: This is incomplete, but there is enough here to insert rows into
-- a MySQL database table.

WITH Interfaces.C.Strings;

PACKAGE libmysqlclient IS
  PRAGMA Link_With("-lmysqlclient");

  SUBTYPE Pointer IS Interfaces.C.Strings.chars_ptr;

  NullPointer : CONSTANT Pointer := Interfaces.C.Strings.Null_Ptr;

  -- Initialize a database connection handle

  FUNCTION Init(dummy : Pointer := NullPointer) RETURN Pointer;
    PRAGMA Import(C, Init, "mysql_init");

  -- Connect to a database server

  FUNCTION Connect
   (dbhandle : Pointer;
    dbhost   : String;
    dbuser   : String;
    dbpass   : String;
    dbname   : String  := "" & ASCII.NUL;
    dbport   : Integer := 3306;
    dbsock   : Pointer := NullPointer;
    dbflags  : Integer := 0) RETURN Pointer;
    PRAGMA Import(C, Connect, "mysql_real_connect");

  -- Change the default database

  FUNCTION SelectDatabase(dbhandle : Pointer; dbname : String) RETURN Integer;
    PRAGMA Import(C, SelectDatabase, "mysql_select_db");

  -- Issue a query to the database server

  FUNCTION Query(dbhandle : Pointer; dbquery : String) RETURN Integer;
    PRAGMA Import(C, Query, "mysql_query");

  -- Disconnect from the database server

  PROCEDURE Disconnect(dbhandle : Pointer);
    PRAGMA Import(C, Disconnect, "mysql_close");

  -- Retrieve last error number

  FUNCTION errno(dbhandle : Pointer) RETURN Integer;
    PRAGMA Import(C, errno, "mysql_errno");

END libmysqlclient;
