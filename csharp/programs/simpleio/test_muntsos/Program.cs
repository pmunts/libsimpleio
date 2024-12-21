// Copyright (C)2024, Philip Munts dba Munts Technologies.
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
using static IO.Objects.SimpleIO.Platforms.MuntsOS;

// Dump contents of /etc/platform

WriteLine("OSNAME            is " + GetProperty("OSNAME"));
WriteLine("OSREVISION        is " + GetProperty("OSREVISION"));
WriteLine("BOARDBASE         is " + GetProperty("BOARDBASE"));
WriteLine("BOARDNAME         is " + GetProperty("BOARDNAME"));
WriteLine("BOARDARCH         is " + GetProperty("BOARDARCH"));
WriteLine("KERNELREPO        is " + GetProperty("KERNELREPO"));
WriteLine("KERNELBRANCH      is " + GetProperty("KERNELBRANCH"));
WriteLine("KERNELCOMMIT      is " + GetProperty("KERNELCOMMIT"));
WriteLine("OPTIONS           is " + GetProperty("OPTIONS"));
WriteLine("SERIALNUMBER      is " + GetProperty("SERIALNUMBER"));
WriteLine("TOOLCHAINBUILDER  is " + GetProperty("TOOLCHAINBUILDER"));
WriteLine("TOOLCHAINREVISION is " + GetProperty("TOOLCHAINREVISION"));

// Display some hardware information

WriteLine("Model Name        is " + GetModelName());
WriteLine("CPU               is " + GetCPUKind().ToString());
