using System;
using System.Windows;
using System.Windows.Controls;

namespace test_led
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private readonly IO.Objects.RemoteIO.Device remdev;
        private readonly IO.Interfaces.GPIO.Pin LED;

        // Button click event handler

        private void ChangeLED(object sender, EventArgs e)
        {
            Button b = (Button) sender;

            if (b.Content.ToString() == "Turn LED ON")
            {
                this.LED.state = true;
                b.Content = "Turn LED OFF";
            }
            else
            {
                this.LED.state = false;
                b.Content = "Turn LED ON";
            }
        }

        public MainWindow()
        {
            // Open Remote I/O Protocol server device

            try
            {
                remdev = new IO.Objects.RemoteIO.Device();
            }
            catch
            {
                MessageBox.Show("Fatal Error: Cannot open Remote I/O Protocol server device!",
                "Remote I/O Protocol LED Test");
                Environment.Exit(1);
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
                Environment.Exit(2);
            }

            InitializeComponent();
        }
    }
}
