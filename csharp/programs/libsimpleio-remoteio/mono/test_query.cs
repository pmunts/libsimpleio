using System;

namespace test_query
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nUSB HID Remote I/O Device Information Query Test\n");

            IO.Interfaces.Message64.Messenger m =
                new IO.Objects.libsimpleio.HID.Messenger();

            IO.Remote.Device dev = new IO.Remote.Device(m);

            // Display some device information

            Console.WriteLine(dev.Version);
            Console.WriteLine(dev.Capabilities);
            Console.WriteLine();

            // Display the available ADC inputs

            Console.Write("ADC inputs:  ");

            foreach (int input in dev.ADC_Available())
                Console.Write(input.ToString() + " ");

            Console.WriteLine();

            // Display the available DAC outputs

            Console.Write("DAC outputs: ");

            foreach (int output in dev.DAC_Available())
                Console.Write(output.ToString() + " ");

            Console.WriteLine();

            // Display the available GPIO pins

            Console.Write("GPIO Pins:   ");

            foreach (int pin in dev.GPIO_Available())
              Console.Write(pin.ToString() + " ");

            Console.WriteLine();

            // Display the available I2C buses

            Console.Write("I2C buses:   ");

            foreach (int bus in dev.I2C_Available())
                Console.Write(bus.ToString() + " ");

            Console.WriteLine();

            // Display the available SPI devices

            Console.Write("SPI devices: ");

            foreach (int bus in dev.SPI_Available())
                Console.Write(bus.ToString() + " ");

            Console.WriteLine();
        }
    }
}
