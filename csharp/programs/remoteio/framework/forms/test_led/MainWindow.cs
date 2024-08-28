using System;
using System.Windows.Forms;

namespace test_led
{
    public partial class MainWindow : Form
    {
        private readonly IO.Interfaces.GPIO.Pin LED;

        // Button click event handler

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

        public MainWindow(IO.Interfaces.GPIO.Pin pin)
        {
            InitializeComponent();
            this.button1.Text = "Turn LED ON";
            this.button1.Click += SetLED;
            this.LED = pin;
        }
    }
}
