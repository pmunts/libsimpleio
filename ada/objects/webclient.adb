-- Simple web client package, including proxy support

-- Copyright (C)2013-2018, Philip Munts, President, Munts AM Corp.
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
WITH Ada.Strings.Fixed;         USE Ada.Strings.Fixed;
WITH aws.Client;
WITH aws.Response;

PACKAGE BODY WebClient IS

  FUNCTION GetProxy(URL : String) RETURN String IS

  BEGIN

    -- Check the no_proxy list

    IF Exists("no_proxy") THEN
      IF Index(Value("no_proxy"), Delete(URL, 1, 7)) /= 0 THEN
        RETURN "";
      END IF;
    END IF;

    -- Return the value of the http_proxy environment variable

    IF Exists("http_proxy") THEN
      RETURN Value("http_proxy");
    ELSE
      RETURN "";
    END IF;
  END GetProxy;

  FUNCTION Get(URL : String) RETURN String IS

    resp : aws.Response.Data;

  BEGIN

    -- Issue the request

    resp := aws.Client.Get(URL, Proxy => GetProxy(URL));

    -- Return the response

    RETURN aws.Response.Message_Body(resp);
  END Get;

END WebClient;
