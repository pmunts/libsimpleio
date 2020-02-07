using System;

namespace test_libremoteio
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nConsole Application using the Remote I/O Protocol\n");

            IO.Objects.USB.HID.Messenger m = new IO.Objects.USB.HID.Messenger();
            IO.Remote.Device dev = new IO.Remote.Device(m);

            // Display some device information

            Console.WriteLine(m.Info);
            Console.WriteLine(dev.Version);
            Console.WriteLine(dev.Capabilities);
        }
    }
}
