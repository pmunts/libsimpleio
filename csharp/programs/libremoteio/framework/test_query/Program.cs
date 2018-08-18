using System;

namespace test_query
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nUSB HID Remote I/O Device Information Query Test\n");

            IO.Objects.USB.HID.Messenger m = new IO.Objects.USB.HID.Messenger();
            IO.Remote.Device dev = new IO.Remote.Device(m);

            // Display some device information

            Console.WriteLine(m.Info);
            Console.WriteLine(dev.Version);
            Console.WriteLine(dev.Capabilities);
            Console.WriteLine();

            // Display the available ADC inputs

            Console.Write("ADC inputs: ");

            foreach (int input in dev.ADC_Available())
                Console.Write(input.ToString() + " ");

            Console.WriteLine();

            // Display the available GPIO pins

            Console.Write("GPIO Pins:  ");

            foreach (int pin in dev.GPIO_Available())
              Console.Write(pin.ToString() + " ");

            Console.WriteLine();

            // Display the available I2C buses

            Console.Write("I2C buses:  ");

            foreach (int bus in dev.I2C_Available())
                Console.Write(bus.ToString() + " ");

            Console.WriteLine();
        }
    }
}
