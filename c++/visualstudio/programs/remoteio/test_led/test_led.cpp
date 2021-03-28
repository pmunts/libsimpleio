// Remote I/O Protocol LED Test

// Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <windows.h>

#include <libremoteio.h>

int main()
{
    int handle;
    int error;
    uint8_t channels[128];
    int i;
    int state;

    puts("\nRemote I/O Protocol LED Test\n");

    // Open the raw HID Remote I/O Protocol server

    open(0x16D0, 0x0AFA, NULL, 1000, &handle, &error);

    if (error != 0)
    {
        fprintf(stderr, "ERROR: open() failed, %d\n", error);
        exit(1);
    }

    // Query available GPIO pins

    gpio_channels(handle, channels, &error);

    if (error != 0)
    {
        fprintf(stderr, "ERROR: gpio_channels() failed, %d\n", error);
        exit(1);
    }

    printf("Available GPIO channels:");

    for (i = 0; i < 128; i++)
        if (channels[i])
            printf(" %d", i);

    putchar('\n');

    // Configure an LED

    gpio_configure(handle, 0, 1, 0, &error);

    if (error != 0)
    {
        fprintf(stderr, "ERROR: gpio_configure() failed, %d\n", error);
        exit(1);
    }

    // Flash the LED

    for (;;)
    {
        gpio_read(handle, 0, &state, &error);

        if (error != 0)
        {
            fprintf(stderr, "ERROR: gpio_read() failed, %d\n", error);
            exit(1);
        }

        state ^= 1;

        gpio_write(handle, 0, state, &error);

        if (error != 0)
        {
            fprintf(stderr, "ERROR: gpio_write() failed, %d\n", error);
            exit(1);
        }

        Sleep(500);
    }
}