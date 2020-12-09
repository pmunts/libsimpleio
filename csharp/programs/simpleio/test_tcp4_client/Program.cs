// TCP4 Client Test

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

using IO.Objects.libsimpleio.Exceptions;

namespace test_tcp4_client
{
    class Program
    {
        static void Main(string[] args)
        {
            System.Console.WriteLine("\nTCP4 Client Test\n");

            int addr;
            int error;
            System.Text.StringBuilder addrstr = new System.Text.StringBuilder(256);
            byte[] buf = new byte[256];
            int fd;
            int count;

            if (args.Length != 1)
            {
                System.Console.WriteLine("Usage: test_tcp4_client <server>\n");
                System.Environment.Exit(1);
            }

            IO.Bindings.libsimpleio.IPV4_resolve(args[0], out addr,
                out error);

            if (error != 0)
            {
                throw new Exception("IPV4_resolve() failed", error);
            }

            IO.Bindings.libsimpleio.IPV4_ntoa(addr, addrstr, addrstr.Length,
                out error);

            if (error != 0)
            {
                throw new Exception("IPV4_ntoa() failed", error);
            }

            System.Console.WriteLine("Connecting to server " + addrstr.ToString()
                + "\n");

            IO.Bindings.libsimpleio.TCP4_connect(addr, 12345, out fd,
                out error);

            if (error != 0)
            {
                throw new Exception("TCP4_connect() failed", error);
            }

            for (;;)
            {
                System.Console.Write("> ");
                string s = System.Console.ReadLine();

                if (s == "quit")
                {
                    break;
                }

                buf = System.Text.Encoding.ASCII.GetBytes(s + "\r\n");

                IO.Bindings.libsimpleio.TCP4_send(fd, buf, buf.Length,
                    out count, out error);

                if (error != 0)
                {
                    throw new Exception("TCP4_send() failed", error);
                }

                buf = new byte[256];

                IO.Bindings.libsimpleio.TCP4_receive(fd, buf, buf.Length,
                    out count, out error);

                if (error != 0)
                {
                    throw new Exception("TCP4_receive() failed", error);
                }

                if (count > 0)
                {
                    s = System.Text.Encoding.ASCII.GetString(buf, 0, count);
                    System.Console.WriteLine("Received: " + s);

                }
            }

            IO.Bindings.libsimpleio.TCP4_close(fd, out error);

            if (error != 0)
            {
                throw new Exception("TCP4_close() failed", error);
            }
        }
    }
}
