using System;
using System.Windows.Forms;

namespace test_led
{
    public partial class MainWindow : Form
    {
        private readonly IO.Interfaces.GPIO.Pin LED;

        // Button click event handler

        private void ChangeLED(object sender, EventArgs e)
        {
            Button b = (Button) sender;

            if (b.Text == "Turn LED ON")
            {
                this.LED.state = true;
                b.Text = "Turn LED OFF";
            }
            else
            {
                this.LED.state = false;
                b.Text = "Turn LED ON";
            }
        }

        public MainWindow(IO.Interfaces.GPIO.Pin pin)
        {
            InitializeComponent();
            this.button1.Text = "Turn LED ON";
            this.button1.Click += ChangeLED;
            this.LED = pin;
        }
    }
}
