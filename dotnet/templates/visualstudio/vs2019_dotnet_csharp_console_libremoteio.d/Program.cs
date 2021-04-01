using System;

namespace $safeprojectname$
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nConsole Application using the Remote I/O Protocol\n");

            IO.Remote.Device remdev = new IO.Remote.Device();

            // Display some device information

            Console.WriteLine(remdev.Version);
            Console.WriteLine(remdev.Capabilities);
        }
    }
}
