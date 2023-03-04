-- Webserver, serving pages from a hash table of request/response pairs

-- Copyright (C)2016-2023, Philip Munts.
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

WITH Ada.Containers;
WITH Ada.Containers.Hashed_Maps;
WITH Ada.Strings.Unbounded;
WITH Ada.Strings.Unbounded.Hash;

WITH AWS;
WITH AWS.Messages;
WITH AWS.MIME;
WITH AWS.Response;
WITH AWS.Server;
WITH AWS.Status;

USE ALL TYPE Ada.Strings.Unbounded.Unbounded_String;

PACKAGE BODY Webserver.HashTable IS

  -- Instantiate a hash table container package for requests and responses,
  -- both unbounded strings

  PACKAGE HashPackage IS NEW Ada.Containers.Hashed_Maps
   (Key_Type => Ada.Strings.Unbounded.Unbounded_String,
    Element_Type => Ada.Strings.Unbounded.Unbounded_String,
    Hash => Ada.Strings.Unbounded.Hash,
    Equivalent_Keys => "=");

  -- Encapsulate an instance of HashPackage.map inside a protected object

  PROTECTED WebPages IS

    PROCEDURE Store(req : String; resp : String);

    FUNCTION Fetch(req : String) RETURN String;

  PRIVATE
    PageMap : HashPackage.Map;
  END WebPages;

  PROTECTED BODY WebPages IS

    PROCEDURE Store(req : String; resp : String) IS

    BEGIN
      PageMap.Include(To_Unbounded_String(req), To_Unbounded_String(resp));
    END Store;

    FUNCTION Fetch(req : String) RETURN String IS

    BEGIN
      RETURN To_String(PageMap.Element(To_Unbounded_String(req)));
    END Fetch;

  END WebPages;

  -- Publish request/response pairings

  PROCEDURE Publish(req : String; resp : String) IS

  BEGIN
    WebPages.Store(req, resp);
  END Publish;

  -- HTTP request responder callback

  FUNCTION Responder(Request : IN AWS.Status.Data) RETURN AWS.Response.data IS

  BEGIN
    RETURN AWS.Response.Build(AWS.MIME.Text_HTML,
      WebPages.Fetch(AWS.Status.URI(Request)));

  EXCEPTION
    WHEN Constraint_Error =>
      RETURN AWS.Response.Build(AWS.MIME.Text_HTML, "ERROR: Unknown URI",
        AWS.Messages.S404);
  END Responder;

  -- Wrapper for glibc system() function

  FUNCTION system(cmd : String) RETURN Integer;
    PRAGMA Import(C, system, "system");

  server : AWS.Server.HTTP;

  -- Start the HTTP server

  PROCEDURE Start(port : Natural := 80) IS

    PRAGMA Warnings(Off, "variable ""error"" is assigned but never read");

    error : Integer;

  BEGIN
    PRAGMA Warnings(Off, "possibly useless assignment to ""error""");

    error := system("iptables -A INPUT -p tcp -m conntrack --ctstate NEW --dport " &
      Natural'Image(port) & " -j ACCEPT" & ASCII.NUL);

    AWS.Server.Start(server, "Ada Web Server", Callback => Responder'Access, Port => port);
  END Start;

END Webserver.HashTable;
