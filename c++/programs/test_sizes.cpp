// Primitive Type Size Test

// Copyright (C)2019, Philip Munts, President, Munts AM Corp.
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

#include <stdio.h>

int main(void)
{
  printf("char:               %ld\n", sizeof(char));
  printf("signed char:        %ld\n", sizeof(signed char));
  printf("unsigned char:      %ld\n", sizeof(unsigned char));
  printf("short int:          %ld\n", sizeof(short int));
  printf("signed short int:   %ld\n", sizeof(signed short int));
  printf("unsigned short int: %ld\n", sizeof(unsigned short int));
  printf("int:                %ld\n", sizeof(int));
  printf("signed int:         %ld\n", sizeof(signed int));
  printf("unsigned int:       %ld\n", sizeof(unsigned int));
  printf("long int:           %ld\n", sizeof(long int));
  printf("signed long int:    %ld\n", sizeof(signed long int));
  printf("unsigned long int:  %ld\n", sizeof(unsigned long int));
  printf("void *:             %ld\n", sizeof(void *));
}
