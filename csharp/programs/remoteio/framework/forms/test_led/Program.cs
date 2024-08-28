using System;
using System.Windows.Forms;

namespace test_led
{
    internal static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            IO.Objects.RemoteIO.Device remdev;
            IO.Interfaces.GPIO.Pin LED;

            // Open Remote I/O Protocol server device

            try
            {
                remdev = new IO.Objects.RemoteIO.Device();
            }
            catch
            {
                MessageBox.Show("Fatal Error: Cannot open Remote I/O Protocol server device!",
                "Remote I/O Protocol LED Test");
                return;
            }

            // Configure the LED

            try
            {
                LED = remdev.GPIO_Create(0, IO.Interfaces.GPIO.Direction.Output, false);
            }
            catch
            {
                MessageBox.Show("Fatal Error: Cannot configure LED!",
                "Remote I/O Protocol LED Test");
                return;
            }

            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MainWindow(LED));
        }
    }
}
