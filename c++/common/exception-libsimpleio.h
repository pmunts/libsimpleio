// Exception Wrappers

// Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

#ifndef _EXCEPTION_H_
#define _EXCEPTION_H_

#include <stdexcept>

// These macros allow capturing exception locality information

#define THROW()				_Throw(__FUNCTION__, __FILE__, __LINE__)
#define THROW_ERR(error)		_Throw_Error(__FUNCTION__, __FILE__, __LINE__, error)
#define THROW_MSG(msg)			_Throw_Message(__FUNCTION__, __FILE__, __LINE__, msg)
#define THROW_MSG_ERR(msg, error)	_Throw_Message_Error(__FUNCTION__, __FILE__, __LINE__, msg, error)

void _Throw(const char *func, const char *file, int line);
void _Throw_Error(const char *func, const char *file, int line, int error);
void _Throw_Message(const char *func, const char *file, int line, const char *msg);
void _Throw_Message_Error(const char *func, const char *file, int line, const char *msg, int error);

#endif
