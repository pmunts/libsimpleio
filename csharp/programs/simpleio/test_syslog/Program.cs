// Linux syslog Test

// Copyright (C)2021-2023, Philip Munts dba Munts Technologies.
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

using static System.Console;

WriteLine("\nLinux syslog Test\n");

// Create a Logger instance

var log = new IO.Objects.SimpleIO.syslog.Logger();

// Test Logger methods

log.Note("This is a test NOTIFICATION message");
log.Warning("This is a test WARNING message");
log.Error("This is a test ERROR message");
log.Error("This is a test ERROR message", errno.EINVAL);
log.Error("This is a test ERROR message", 999);

// Register trace listener

System.Diagnostics.Trace.Listeners.Clear();
System.Diagnostics.Trace.Listeners.Add(log);

// Test Trace methods

System.Diagnostics.Trace.TraceInformation("This is TraceInformation()");
System.Diagnostics.Trace.TraceWarning("This is TraceWarning()");
System.Diagnostics.Trace.TraceError("This is TraceError()");

// Test Write()

System.Diagnostics.Trace.Write("This is Write()");
System.Diagnostics.Trace.Write(123456789);
System.Diagnostics.Trace.Write("This is Write()", "ALERT");
System.Diagnostics.Trace.Write(123456789, "INFO");

// Test WriteIf()

System.Diagnostics.Trace.WriteIf(true, "This is WriteIf()");
System.Diagnostics.Trace.WriteIf(true, 123456789);
System.Diagnostics.Trace.WriteIf(true, "This is WriteIf()", "ALERT");
System.Diagnostics.Trace.WriteIf(true, 123456789, "INFO");
