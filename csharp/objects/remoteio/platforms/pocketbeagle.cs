// I/O Resources available from a PocketBeagle Remote I/O Server

// Copyright (C)2023, Philip Munts.
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

namespace IO.Objects.RemoteIO.Platforms
{
    /// <summary>
    /// I/O resources (channel numbers) available on a BeagleBone Remote I/O
    /// Protocol Server
    /// </summary>
    public static class PocketBeagle
    {
        /// <summary>
        /// Analog input channel number for the remote PocketBeagle 1.8V analog
        /// input <c>AIN0</c> at pin <c>P1.19</c>.
        /// </summary>
        public const int AIN0 = 0;

        /// <summary>
        /// Analog input channel number for the remote PocketBeagle 1.8V analog
        /// input <c>AIN1</c> at pin <c>P1.21</c>.
        /// </summary>
        public const int AIN1 = 1;

        /// <summary>
        /// Analog input channel number for the remote PocketBeagle 1.8V analog
        /// input <c>AIN2</c> at pin <c>P1.23</c>.
        /// </summary>
        public const int AIN2 = 2;

        /// <summary>
        /// Analog input channel number for the remote PocketBeagle 1.8V analog
        /// input <c>AIN3</c> at pin <c>P1.24</c>.
        /// </summary>
        public const int AIN3 = 3;

        /// <summary>
        /// Analog input channel number for the remote PocketBeagle 1.8V analog
        /// input <c>AIN4</c> at pin <c>P1.25</c>.
        /// </summary>
        public const int AIN4 = 4;

        /// <summary>
        /// Analog input channel number for the remote PocketBeagle 3.6V analog
        /// input <c>AIN5</c> at pin <c>P2.35</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>GPIO86</c>.
        /// </remarks>
        public const int AIN5 = 5;

        /// <summary>
        /// Analog input channel number for the remote PocketBeagle 3.6V analog
        /// input <c>AIN6</c> at pin <c>P1.2</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>GPIO87</c>.
        /// </remarks>
        public const int AIN6 = 6;

        /// <summary>
        /// Analog input channel number for the remote PocketBeagle 1.8V analog
        /// input <c>AIN7</c> at pin <c>P2.36</c>.
        /// </summary/c/Users/pmunts/src/libsimpleio/ada/objects/simpleio/pocketbeagle.ads>
        public const int AIN7 = 7;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle user LED.
        /// </summary>
        /// <remarks>
        /// This GPIO channel cannot be configured as an input.
        /// </remarks>
        public const int USERLED = 0;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO2</c> at pin <c>P1.8</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>SPI0 SCLK</c>.
        /// </remarks>
        public const int GPIO2 = 2;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO3</c> at pin <c>P1.10</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>SPI0 MISO</c>.
        /// </remarks>
        public const int GPIO3 = 3;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO4</c> at pin <c>P1.12</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>SPI0 MOSI</c>.
        /// </remarks>
        public const int GPIO4 = 4;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO5</c> at pin <c>P1.6</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>SPI0 CS0</c>.
        /// </remarks>
        public const int GPIO5 = 5;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO7</c> at pin <c>P2.29</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>SPI1 SCLK</c>.
        /// </remarks>
        public const int GPIO7 = 7;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO12</c> at pin <c>P1.26</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>I2C2 SDA</c>.
        /// </remarks>
        public const int GPIO12 = 12;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO13</c> at pin <c>P1.28</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>I2C2 SCL</c>.
        /// </remarks>
        public const int GPIO13 = 13;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO14</c> at pin <c>P2.11</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>I2C1 SDA</c>.
        /// </remarks>
        public const int GPIO14 = 14;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO15</c> at pin <c>P2.9</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>I2C1 SCL</c>.
        /// </remarks>
        public const int GPIO15 = 15;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO19</c> at pin <c>P2.31</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>SPI1 CS1</c>.
        /// </remarks>
        public const int GPIO19 = 19;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO20</c> at pin <c>P1.20</c>.
        /// </summary>
        public const int GPIO20 = 20;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO23</c> at pin <c>P2.3</c>.
        /// </summary>
        public const int GPIO23 = 23;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO26</c> at pin <c>P1.34</c>.
        /// </summary>
        public const int GPIO26 = 26;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO27</c> at pin <c>P2.19</c>.
        /// </summary>
        public const int GPIO27 = 27;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO30</c> at pin <c>P2.5</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>RXD4</c>.
        /// </remarks>
        public const int GPIO30 = 30;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO31</c> at pin <c>P2.7</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>TXD4</c>.
        /// </remarks>
        public const int GPIO31 = 31;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO40</c> at pin <c>P2.27</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>SPI1 MISO</c>.
        /// </remarks>
        public const int GPIO40 = 40;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO41</c> at pin <c>P2.25</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>SPI1 MOSI</c>.
        /// </remarks>
        public const int GPIO41 = 41;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO42</c> at pin <c>P1.32</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>RXD0</c>.
        /// </remarks>
        public const int GPIO42 = 42;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO43</c> at pin <c>P1.30</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>TXD0</c>.
        /// </remarks>
        public const int GPIO43 = 43;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO44</c> at pin <c>P2.24</c>.
        /// </summary>
        public const int GPIO44 = 44;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO45</c> at pin <c>P2.33</c>.
        /// </summary>
        public const int GPIO45 = 45;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO46</c> at pin <c>P2.22</c>.
        /// </summary>
        public const int GPIO46 = 46;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO47</c> at pin <c>P2.18</c>.
        /// </summary>
        public const int GPIO47 = 47;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO50</c> at pin <c>P2.1</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>PWM2:0</c>.
        /// </remarks>
        public const int GPIO50 = 50;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO52</c> at pin <c>P2.10</c>.
        /// </summary>
        public const int GPIO52 = 52;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO57</c> at pin <c>P2.6</c>.
        /// </summary>
        public const int GPIO57 = 57;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO58</c> at pin <c>P2.4</c>.
        /// </summary>
        public const int GPIO58 = 58;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO59</c> at pin <c>P2.2</c>.
        /// </summary>
        public const int GPIO59 = 59;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO60</c> at pin <c>P2.8</c>.
        /// </summary>
        public const int GPIO60 = 60;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO64</c> at pin <c>P2.20</c>.
        /// </summary>
        public const int GPIO64 = 64;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO65</c> at pin <c>P2.17</c>.
        /// </summary>
        public const int GPIO65 = 65;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO86</c> at pin <c>P2.35</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>AIN5</c>.
        /// </remarks>
        public const int GPIO86 = 86;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO87</c> at pin <c>P1.2</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>AIN6</c>.
        /// </remarks>
        public const int GPIO87 = 87;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO88</c> at pin <c>P1.35</c>.
        /// </summary>
        public const int GPIO88 = 88;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO89</c> at pin <c>P1.4</c>.
        /// </summary>
        public const int GPIO89 = 89;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO110</c> at pin <c>P1.36</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>PWM0:0</c>.
        /// </remarks>
        public const int GPIO110 = 110;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO111</c> at pin <c>P1.33</c>.
        /// </summary>
        public const int GPIO111 = 111;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO112</c> at pin <c>P2.32</c>.
        /// </summary>
        public const int GPIO112 = 112;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO113</c> at pin <c>P2.30</c>.
        /// </summary>
        public const int GPIO113 = 113;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO114</c> at pin <c>P1.31</c>.
        /// </summary>
        public const int GPIO114 = 114;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO115</c> at pin <c>P2.34</c>.
        /// </summary>
        public const int GPIO115 = 115;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO116</c> at pin <c>P2.28</c>.
        /// </summary>
        public const int GPIO116 = 116;

        /// <summary>
        /// GPIO channel number for the remote PocketBeagle GPIO pin
        /// <c>GPIO117</c> at pin <c>P1.29</c>.
        /// </summary>
        public const int GPIO117 = 117;

        /// <summary>
        /// I<sup>2</sup>C bus channel number for the remote BeagleBone
        /// I<sup>2</sup>C bus <c>I<sup>2</sup>C</c> at pins <c>P2.9</c> and
        /// <c>P2.11</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>GPIO14</c> and <c>GPIO15</c>.
        /// </remarks>
        public const int I2C1 = 1;

        /// <summary>
        /// I<sup>2</sup>C bus channel number for the remote BeagleBone
        /// I<sup>2</sup>C bus <c>I<sup>2</sup>C</c> at pins <c>P1.26</c> and
        /// <c>P1.28</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>GPIO12</c> and <c>GPIO13</c>.
        /// </remarks>
        public const int I2C2 = 2;

        /// <summary>
        /// PWM output channel number for the remote PocketBeagle PWM output
        /// <c>PWM0_0</c> at pin <c>P1.36</c>
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>GPIO110</c>.
        /// </remarks>
        public const int PWM0_0 = 0;

        /// <summary>
        /// PWM output channel number for the remote PocketBeagle PWM output
        /// <c>PWM2_0</c> at pin <c>P2.1</c>
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>GPIO50</c>.
        /// </remarks>
        public const int PWM2_0 = 1;

        /// <summary>
        /// SPI slave channel number for the remote PocketBeagle SPI slave select
        /// <c>SPI0_0</c> at pin <c>P1.6</c>
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>GPIO5</c>.
        /// </remarks>
        public const int SPI0_0 = 0;

        /// <summary>
        /// SPI slave channel number for the remote PocketBeagle SPI slave select
        /// <c>SPI1_1</c> at pin <c>P2.31</c>
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>GPIO19</c>.
        /// </remarks>
        public const int SPI1_1 = 1;
    }
}
