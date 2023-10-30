// Mikroelektronika Seven Segment Click Test

// Copyright (C)2020-2023, Philip Munts dba Munts Technologies.
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

using System;
using IO.Devices.ClickBoards.SimpleIO.SevenSegment;
using static IO.Devices.ClickBoards.SimpleIO.SevenSegment.Board;

namespace test_7seg_click
{
    class Program
    {
        static void Main()
        {
            Console.WriteLine("\nMikroelektronika Seven Segment Click Test\n");

            Console.Write("Socket number? ");
            var num = int.Parse(Console.ReadLine());
            var disp = new Board(num);

            // Test decimal mode

            disp.Clear();
            disp.radix = Base.Decimal;
            disp.blanking = ZeroBlanking.Leading;

            for (int i = 0; i <= 99; i++)
            {
                disp.state = i;
                System.Threading.Thread.Sleep(100);
            }

            System.Threading.Thread.Sleep(1000);

            for (int i = 99; i >= 0; i--)
            {
                disp.state = i;
                System.Threading.Thread.Sleep(100);
            }

            System.Threading.Thread.Sleep(1000);

            // Test hexadecimal mode

            disp.Clear();
            disp.radix = Base.Hexadecimal;
            disp.blanking = ZeroBlanking.None;

            for (int i = 0; i <= 255; i++)
            {
                disp.state = i;
                System.Threading.Thread.Sleep(100);
            }

            System.Threading.Thread.Sleep(1000);

            for (int i = 255; i >= 0; i--)
            {
                disp.state = i;
                System.Threading.Thread.Sleep(100);
            }

            System.Threading.Thread.Sleep(1000);

            // Test decimal points

            disp.Clear();
            disp.rightdp = true;
            System.Threading.Thread.Sleep(1000);
            disp.rightdp = false;
            System.Threading.Thread.Sleep(1000);
            disp.leftdp = true;
            System.Threading.Thread.Sleep(1000);
            disp.leftdp = false;
        }
    }
}
