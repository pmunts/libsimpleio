{ Watchdog timer services using libsimpleio }

{ Copyright (C)2020, Philip Munts, President, Munts AM Corp.                  }
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

namespace IO.Objects.libsimpleio.Watchdog;

interface

  const
    DefaultDevice  = '/dev/watchdog';
    DefaultTimeout = 0;

  type
    Timer = public class(Object, IO.Interfaces.Watchdog.Timer)
      public constructor
       (name        : String = DefaultDevice;
        timeoutsecs : Cardinal = 0);

      finalizer;

      public method GetTimeout : Cardinal;

      public method SetTimeout(timeoutsecs : Cardinal);

      public method Kick;

      property timeout : Cardinal read GetTimeout write SetTimeout;

      { Private internal state }

      private fd : Int32;
    end;

implementation

  { Constructor }

  constructor Timer
   (name        : String;
    timeoutsecs : Cardinal);

  begin
    var error      : Int32;
    var newtimeout : Int32;

    IO.Bindings.libsimpleio.WATCHDOG_open(name, @self.fd, @error);

    if error <> 0 then
      raise new Exception('ERROR: WATCHDOG_open() failed, ' +
        errno.strerror(error));

    if timeoutsecs <> DefaultTimeout then
      begin
        IO.Bindings.libsimpleio.WATCHDOG_set_timeout(self.fd, timeoutsecs,
          @newtimeout, @error);

        if error <> 0 then
          raise new Exception('ERROR: WATCHDOG_set_timeout() failed, ' +
            errno.strerror(error));
      end;
  end;

  { Destructor }

  finalizer Timer;

  begin
    var error : Int32;
    IO.Bindings.libsimpleio.WATCHDOG_close(self.fd, @error);
  end;

  { Get timeout method }

  method Timer.GetTimeout : Cardinal;

  begin
    var oldtimeout : Int32;
    var error      : Int32;

    IO.Bindings.libsimpleio.WATCHDOG_get_timeout(self.fd, @oldtimeout, @error);

    if error <> 0 then
      raise new Exception('ERROR: WATCHDOG_get_timeout() failed, ' +
        errno.strerror(error));

    GetTimeout := oldtimeout;
  end;

  { Set timeout method }

  method Timer.SetTimeout(timeoutsecs : Cardinal);

  begin
    var newtimeout : Int32;
    var error      : Int32;

    IO.Bindings.libsimpleio.WATCHDOG_set_timeout(self.fd, timeoutsecs,
      @newtimeout, @error);

    if error <> 0 then
      raise new Exception('ERROR: WATCHDOG_set_timeout() failed, ' +
        errno.strerror(error));
  end;

  { Kick watchdog method }

  method Timer.Kick;

  begin
    var error : Int32;

    IO.Bindings.libsimpleio.WATCHDOG_kick(self.fd, @error);

    if error <> 0 then
      raise new Exception('ERROR: WATCHDOG_kick() failed, ' +
        errno.strerror(error));
  end;

end.
