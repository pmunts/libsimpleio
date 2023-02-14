// Linux syslog Test

// Copyright (C)2021-23, Philip Munts.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

using static System.Diagnostics.Trace;

System.Console.WriteLine("\nLinux syslog Test\n");

// Create a Logger instance

var log = new IO.Objects.libsimpleio.syslog.Logger();

// Replace the default trace listener

Listeners.RemoveAt(0);
Listeners.Add(log);

// Test Logger methods

log.Note("This is a test NOTIFICATION message");
log.Warning("This is a test WARNING message");
log.Error("This is a test ERROR message");
log.Error("This is a test ERROR message", errno.EINVAL);
log.Error("This is a test ERROR message", 999);

// Test Trace... methods

TraceInformation("This is TraceInformation()");
TraceWarning("This is TraceWarning()");
TraceError("This is TraceError()");

// Test Write()

Write("This is Write()");
Write(123456789);
Write("This is Write()", "ALERT");
Write(123456789, "INFO");

// Test WriteIf()

WriteIf(true, "This is WriteIf()");
WriteIf(true, 123456789);
WriteIf(true, "This is WriteIf()", "ALERT");
WriteIf(true, 123456789, "INFO");
