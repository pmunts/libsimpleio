// Exception Wrappers

// Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.
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

#include <cstdio>
#include <cstring>
#include <cstdlib>

#include <exception-raisers.h>

// Exception locality information only

void _Throw(const char *func, const char *file, int line)
{
  char buf[4096];

  snprintf(buf, sizeof(buf), "\nEXCEPTION:\n\n"
    "Function:    %s\n"
    "File:        %s\n"
    "Line number: %d\n", func, file, line);

  if (getenv("DEBUGLEVEL"))
    if (atoi(getenv("DEBUGLEVEL")) > 0) fprintf(stderr, "%s\n", buf);

  throw new std::runtime_error(buf);
}

// Exception locality information + errno message

void _Throw_Error(const char *func, const char *file, int line, int error)
{
  char buf[4096];

  snprintf(buf, sizeof(buf), "\nEXCEPTION:\n\n"
    "Function:    %s\n"
    "File:        %s\n"
    "Line number: %d\n"
    "Error:       %s\n", func, file, line, strerror(error));

  if (getenv("DEBUGLEVEL"))
    if (atoi(getenv("DEBUGLEVEL")) > 0) fprintf(stderr, "%s\n", buf);

  throw new std::runtime_error(buf);
}

// Exception locality information + string

void _Throw_Message(const char *func, const char *file, int line, const char *msg)
{
  char buf[4096];

  snprintf(buf, sizeof(buf), "\nEXCEPTION:\n\n"
    "Function:    %s\n"
    "File:        %s\n"
    "Line number: %d\n"
    "Message:     %s\n", func, file, line, msg);

  if (getenv("DEBUGLEVEL"))
    if (atoi(getenv("DEBUGLEVEL")) > 0) fprintf(stderr, "%s\n", buf);

  throw new std::runtime_error(buf);
}

// Exception locality information + string + errno message

void _Throw_Message_Error(const char *func, const char *file, int line, const char *msg, int error)
{
  char buf[4096];

  snprintf(buf, sizeof(buf), "\nEXCEPTION:\n\n"
    "Function:    %s\n"
    "File:        %s\n"
    "Line number: %d\n"
    "Message    : %s\n"
    "Error:       %s\n", func, file, line, msg, strerror(error));

  if (getenv("DEBUGLEVEL"))
    if (atoi(getenv("DEBUGLEVEL")) > 0) fprintf(stderr, "%s\n", buf);

  throw new std::runtime_error(buf);
}
