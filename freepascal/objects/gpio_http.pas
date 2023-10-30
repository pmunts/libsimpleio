{ Free Pascal binding for MuntsOS GPIO HTTP Server                            }

{ Copyright (C)2016-2023, Philip Munts dba Munts Technologies.                }
{                                                                             }
{ Redistribution and use in source and binary forms, with or without          }
{ modification, are permitted provided that the following conditions are met: }
{                                                                             }
{ * Redistributions of source code must retain the above copyright notice,    }
{   this list of conditions and the following disclaimer.                     }
{                                                                             }
{ THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" }
{ AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE   }
{ IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE  }
{ ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE   }
{ LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR         }
{ CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF        }
{ SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS    }
{ INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN     }
{ CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)     }
{ ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE  }
{ POSSIBILITY OF SUCH DAMAGE.                                                 }

UNIT GPIO_HTTP;

INTERFACE

  USES
    GPIO;

  TYPE
    PinSubclass = CLASS(TInterfacedObject, Pin)
      CONSTRUCTOR Create
       (servername   : String;
        number       : Cardinal;
        direction    : GPIO.Direction;
        initialstate : Boolean = False);

      FUNCTION Read : Boolean;

      PROCEDURE Write(state : Boolean);

      PROPERTY state : Boolean READ Read WRITE Write;
    PRIVATE
      number : Cardinal;
      server : String;
    END;

IMPLEMENTATION

  USES
    fphttpclient,
    regexpr,
    resolve,
    strings,
    SysUtils;

  CONST
    PortNumber = 8083;

  VAR
    client : TFPHTTPClient;

  CONSTRUCTOR PinSubclass.Create
   (servername   : String;
    number       : Cardinal;
    direction    : GPIO.Direction;
    initialstate : Boolean = False);

  VAR
    request  : String;
    response : String;

  BEGIN
    Self.number := number;

    { Resolve host name to IP address }

    WITH THostResolver.Create(NIL) DO
      BEGIN
        IF NOT NameLookup(servername) THEN
          RAISE GPIO.Error.Create('Cannot resolve ' + servername);

        Self.server := AddressAsString;
        Free;
      END;

    { Configure GPIO pin direction }

    request := Format('http://%s:%d/GPIO/DDR/%d,%d',
      [Self.server, PortNumber, Self.number, Ord(direction)]);

    TRY
      response := client.Get(request);
    EXCEPT
      RAISE GPIO.Error.Create('HTTP GET for GPIO DDR operation failed: ' +
        response);
    END;

    { Validate response }

    IF response <> Format('DDR%d=%d'+#13+#10,
      [Self.number, Ord(direction)]) THEN
      RAISE GPIO.Error.Create('Invalid response to GPIO DDR operation: ' +
        response);

    { Set output pin initial state }

    IF direction = GPIO.Output THEN
      BEGIN
        request := Format('http://%s:%d/GPIO/PUT/%d,%d',
          [Self.server, PortNumber, Self.number, Ord(initialstate)]);

        TRY
          response := client.Get(request);
        EXCEPT
          RAISE GPIO.Error.Create('HTTP GET for GPIO WRITE operation failed: '
            + response);
        END;

        { Validate response }

        IF response <> Format('GPIO%d=%d'+#13+#10,
          [Self.number, Ord(initialstate)]) THEN
          RAISE GPIO.Error.Create('Invalid response to GPIO WRITE operation: '
            + response);
      END;
  END;

  FUNCTION PinSubclass.Read : Boolean;

  VAR
    request  : String;
    response : String;
    respexp  : TRegExpr;
    count    : Integer;
    pinnum   : Integer;
    pinlevel : Integer;

  BEGIN

    { Build HTTP request }

    request := Format('http://%s:%d/GPIO/GET/%d',
      [Self.server, PortNumber, Self.number]);

    { Issue HTTP request }

    TRY
      response := client.Get(request);
    EXCEPT
      RAISE GPIO.Error.Create('HTTP GET for GPIO READ operation failed: ' +
        response);
    END;

    { Validate HTTP response }

    respexp := TRegExpr.Create;
    respexp.Expression := 'GPIO[0-9]{1,3}=[0-1]\r\n';

    IF NOT respexp.Exec(response) THEN
      RAISE GPIO.Error.Create('Invalid response to GPIO READ operation: ' +
        response);

    { Decode HTTP response }

    TRY
      count := SScanf(response, 'GPIO%d=%d', [@pinnum, @pinlevel]);
    EXCEPT
      RAISE GPIO.Error.Create('Invalid response to GPIO READ operation: ' +
        response);
    END;

    { Check some more error conditions }

    IF count <> 2 THEN
      RAISE GPIO.Error.Create('Invalid response to GPIO READ operation: ' +
        response);

    IF pinnum <> Self.number THEN
      RAISE GPIO.Error.Create('Invalid response to GPIO READ operation: ' +
        response);

    { Return the state as a Boolean }

    Read := Boolean(pinlevel);
  END;

  { Write GPIO state }

  PROCEDURE PinSubclass.Write(state : Boolean);

  VAR
    request  : String;
    response : String;

  BEGIN

    { Build HTTP request }

    request := Format('http://%s:%d/GPIO/PUT/%d,%d',
      [Self.server, PortNumber, Self.number, Ord(state)]);

    { Issue HTTP request }

    TRY
      response := client.Get(request);
    EXCEPT
      RAISE GPIO.Error.Create('HTTP GET for GPIO WRITE operation failed: ' +
        response);
    END;

    { Validate response }

    IF response <> Format('GPIO%d=%d'+#13+#10,
      [Self.number, Ord(state)]) THEN
      RAISE GPIO.Error.Create('Invalid response to GPIO WRITE operation: ' +
        response);
  END;

BEGIN
    { Create the persistent HTTP client object }

    client := TFPHTTPClient.Create(nil);
END.
