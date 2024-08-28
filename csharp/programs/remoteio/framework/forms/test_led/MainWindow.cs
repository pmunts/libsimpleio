using System;
using System.Windows.Forms;

namespace test_led
{
    public partial class MainWindow : Form
    {
        private IO.Objects.RemoteIO.Device remdev;
        private IO.Interfaces.GPIO.Pin LED;

        public MainWindow()
        {
            InitializeComponent();
            this.remdev = new IO.Objects.RemoteIO.Device();
            this.LED = this.remdev.GPIO_Create(0, IO.Interfaces.GPIO.Direction.Output, false);
            this.button1.Text = "Turn LED ON";
            this.button1.Click += SetLED;
        }

        private void SetLED(object sender, EventArgs e)
        {
            if (this.button1.Text == "Turn LED ON")
            {
                this.LED.state = true;
                this.button1.Text = "Turn LED OFF";
            }
            else
            {
                this.LED.state = false;
                this.button1.Text = "Turn LED ON";
            }
        }
    }
}
