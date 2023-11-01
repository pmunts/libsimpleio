// I/O Resources available from a BeagleBone Remote I/O Server

// Copyright (C)2023, Philip Munts dba Munts Technologies.
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
    public static class BeagleBone
    {
        /// <summary>
        /// Analog input channel number for the remote BeagleBone 1.8V analog
        /// input <c>AIN0</c> at pin <c>P9.39</c>.
        /// </summary>
        public const int AIN0 = 0;

        /// <summary>
        /// Analog input channel number for the remote BeagleBone 1.8V analog
        /// input <c>AIN1</c> at pin <c>P9.40</c>.
        /// </summary>
        public const int AIN1 = 1;

        /// <summary>
        /// Analog input channel number for the remote BeagleBone 1.8V analog
        /// input <c>AIN2</c> at pin <c>P9.37</c>.
        /// </summary>
        public const int AIN2 = 2;

        /// <summary>
        /// Analog input channel number for the remote BeagleBone 1.8V analog
        /// input <c>AIN3</c> at pin <c>P9.38</c>.
        /// </summary>
        public const int AIN3 = 3;

        /// <summary>
        /// Analog input channel number for the remote BeagleBone 1.8V analog
        /// input <c>AIN4</c> at pin <c>P9.33</c>.
        /// </summary>
        public const int AIN4 = 4;

        /// <summary>
        /// Analog input channel number for the remote BeagleBone 1.8V analog
        /// input <c>AIN5</c> at pin <c>P9.36</c>.
        /// </summary>
        public const int AIN5 = 5;

        /// <summary>
        /// Analog input channel number for the remote BeagleBone 1.8V analog
        /// input <c>AIN6</c> at pin <c>P9.35</c>.
        /// </summary>
        public const int AIN6 = 6;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone user LED.
        /// </summary>
        /// <remarks>
        /// This GPIO channel cannot be configured as an input.
        /// </remarks>
        public const int USERLED = 0;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO2</c> at pin <c>P9.22</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>EHRPWM0B</c>, <c>SPI0 SCK</c> or
        /// <c>UART2 RXD</c>.
        /// </remarks>
        public const int GPIO2 = 2;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO3</c> at pin <c>P9.21</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>SPI0 MISO</c> or <c>UART2 TXD</c>.
        /// </remarks>
        public const int GPIO3 = 3;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO4</c> at pin <c>P9.18</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>SPI0 MOSI</c>.
        /// </remarks>
        public const int GPIO4 = 4;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO5</c> at pin <c>P9.17</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>SPI0 SS0</c>.
        /// </remarks>
        public const int GPIO5 = 5;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO7</c> at pin <c>P9.42</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>SPI1 SS1</c>.
        /// </remarks>
        public const int GPIO7 = 7;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO8</c> at pin <c>P8.35</c>.
        /// </summary>
        public const int GPIO8 = 8;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO9</c> at pin <c>P8.33</c>.
        /// </summary>
        public const int GPIO9 = 9;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO10</c> at pin <c>P8.31</c>.
        /// </summary>
        public const int GPIO10 = 10;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO11</c> at pin <c>P8.32</c>.
        /// </summary>
        public const int GPIO11 = 11;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO12</c> at pin <c>P9.20</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>I2C2 SDA</c>.
        /// </remarks>
        public const int GPIO12 = 12;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO13</c> at pin <c>P9.19</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>I2C2 SCL</c>.
        /// </remarks>
        public const int GPIO13 = 13;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO14</c> at pin <c>P9.26</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>UART1 RXD</c>.
        /// </remarks>
        public const int GPIO14 = 14;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO15</c> at pin <c>P9.24</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>UART1 TXD</c>.
        /// </remarks>
        public const int GPIO15 = 15;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO20</c> at pin <c>P9.41</c>.
        /// </summary>
        public const int GPIO20 = 20;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO22</c> at pin <c>P8.19</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>EHRPWM2A</c>.
        /// </remarks>
        public const int GPIO22 = 22;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO23</c> at pin <c>P8.13</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>EHRPWM2B</c>.
        /// </remarks>
        public const int GPIO23 = 23;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO26</c> at pin <c>P8.14</c>.
        /// </summary>
        public const int GPIO26 = 26;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO27</c> at pin <c>P8.17</c>.
        /// </summary>
        public const int GPIO27 = 27;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO30</c> at pin <c>P9.11</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>UART4 RXD</c>.
        /// </remarks>
        public const int GPIO30 = 30;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO31</c> at pin <c>P9.13</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>UART4 TXD</c>.
        /// </remarks>
        public const int GPIO31 = 31;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO32</c> at pin <c>P8.25</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>MMC1 DAT0</c>.
        /// </remarks>
        public const int GPIO32 = 32;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO33</c> at pin <c>P8.24</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>MMC1 DAT1</c>.
        /// </remarks>
        public const int GPIO33 = 33;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO34</c> at pin <c>P8.5</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>MMC1 DAT2</c>.
        /// </remarks>
        public const int GPIO34 = 34;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO35</c> at pin <c>P8.6</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>MMC1 DAT3</c>.
        /// </remarks>
        public const int GPIO35 = 35;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO36</c> at pin <c>P8.23</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>MMC1 DAT4</c>.
        /// </remarks>
        public const int GPIO36 = 36;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO37</c> at pin <c>P8.22</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>MMC1 DAT5</c>.
        /// </remarks>
        public const int GPIO37 = 37;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO38</c> at pin <c>P8.3</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>MMC1 DAT6</c>.
        /// </remarks>
        public const int GPIO38 = 38;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO39</c> at pin <c>P8.4</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>MMC1 DAT7</c>.
        /// </remarks>
        public const int GPIO39 = 39;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO44</c> at pin <c>P8.12</c>.
        /// </summary>
        public const int GPIO44 = 44;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO45</c> at pin <c>P8.11</c>.
        /// </summary>
        public const int GPIO45 = 45;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO46</c> at pin <c>P8.16</c>.
        /// </summary>
        public const int GPIO46 = 46;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO47</c> at pin <c>P8.15</c>.
        /// </summary>
        public const int GPIO47 = 47;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO48</c> at pin <c>P9.15</c>.
        /// </summary>
        public const int GPIO48 = 48;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO49</c> at pin <c>P9.23</c>.
        /// </summary>
        public const int GPIO49 = 49;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO50</c> at pin <c>P9.14</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>EHRPWM1A</c>.
        /// </remarks>
        public const int GPIO50 = 50;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO51</c> at pin <c>P9.16</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>EHRPWM1B</c>.
        /// </remarks>
        public const int GPIO51 = 51;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO60</c> at pin <c>P9.12</c>.
        /// </summary>
        public const int GPIO60 = 60;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO61</c> at pin <c>P8.26</c>.
        /// </summary>
        public const int GPIO61 = 61;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO62</c> at pin <c>P8.21</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>MMC1 CLK</c>.
        /// </remarks>
        public const int GPIO62 = 62;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO63</c> at pin <c>P8.20</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>MMC1 CMD</c>.
        /// </remarks>
        public const int GPIO63 = 63;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO65</c> at pin <c>P8.18</c>.
        /// </summary>
        public const int GPIO65 = 65;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO66</c> at pin <c>P8.7</c>.
        /// </summary>
        public const int GPIO66 = 66;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO67</c> at pin <c>P8.8</c>.
        /// </summary>
        public const int GPIO67 = 67;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO68</c> at pin <c>P8.10</c>.
        /// </summary>
        public const int GPIO68 = 68;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO69</c> at pin <c>P8.9</c>.
        /// </summary>
        public const int GPIO69 = 69;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO70</c> at pin <c>P8.45</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>EHRPWM2A</c>.
        /// </remarks>
        public const int GPIO70 = 70;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO71</c> at pin <c>P8.46</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>EHRPWM2B</c>.
        /// </remarks>
        public const int GPIO71 = 71;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO72</c> at pin <c>P8.43</c>.
        /// </summary>
        public const int GPIO72 = 72;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO73</c> at pin <c>P8.44</c>.
        /// </summary>
        public const int GPIO73 = 73;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO74</c> at pin <c>P8.41</c>.
        /// </summary>
        public const int GPIO74 = 74;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO75</c> at pin <c>P8.42</c>.
        /// </summary>
        public const int GPIO75 = 75;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO76</c> at pin <c>P8.39</c>.
        /// </summary>
        public const int GPIO76 = 76;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO77</c> at pin <c>P8.40</c>.
        /// </summary>
        public const int GPIO77 = 77;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO78</c> at pin <c>P8.37</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>UART5 TXD</c>.
        /// </remarks>
        public const int GPIO78 = 78;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO79</c> at pin <c>P8.38</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>UART5 RXD</c>.
        /// </remarks>
        public const int GPIO79 = 79;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO80</c> at pin <c>P8.36</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>EHRPWM1A</c>.
        /// </remarks>
        public const int GPIO80 = 80;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO81</c> at pin <c>P8.34</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>EHRPWM1B</c>.
        /// </remarks>
        public const int GPIO81 = 81;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO86</c> at pin <c>P8.27</c>.
        /// </summary>
        public const int GPIO86 = 86;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO87</c> at pin <c>P8.29</c>.
        /// </summary>
        public const int GPIO87 = 87;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO88</c> at pin <c>P8.28</c>.
        /// </summary>
        public const int GPIO88 = 88;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO89</c> at pin <c>P8.30</c>.
        /// </summary>
        public const int GPIO89 = 89;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO110</c> at pin <c>P9.31</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>EHRPWM0A</c> or <c>SPI1 SCLK</c>.
        /// </remarks>
        public const int GPIO110 = 110;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO111</c> at pin <c>P9.29</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>SPI1 MISO</c>.
        /// </remarks>
        public const int GPIO111 = 111;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO112</c> at pin <c>P9.30</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>SPI1 MOSI</c>.
        /// </remarks>
        public const int GPIO112 = 112;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO113</c> at pin <c>P9.28</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>SPI1 SS0</c>.
        /// </remarks>
        public const int GPIO113 = 113;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO115</c> at pin <c>P9.27</c>.
        /// </summary>
        public const int GPIO115 = 115;

        /// <summary>
        /// GPIO channel number for the remote BeagleBone GPIO pin
        /// <c>GPIO117</c> at pin <c>P9.25</c>.
        /// </summary>
        public const int GPIO117 = 117;

        /// <summary>
        /// I<sup>2</sup>C bus channel number for the remote BeagleBone
        /// I<sup>2</sup>C bus at pins <c>P9.19</c> and <c>P9.20</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>GPIO12</c> and <c>GPIO13</c>.
        /// </remarks>
        public const int I2C2 = 0;

        /// <summary>
        /// PWM output channel number for the remote BeagleBone PWM output
        /// <c>EHRPWM1A</c> at pins <c>P8.36</c> or <c>P9.14</c>.
        /// </summary>
        public const int EHRPWM1A = 0;

        /// <summary>
        /// PWM output channel number for the remote BeagleBone PWM output
        /// <c>EHRPWM1B</c> at pins <c>P8.34</c> or <c>P9.16</c>.
        /// </summary>
        public const int EHRPWM1B = 1;

        /// <summary>
        /// PWM output channel number for the remote BeagleBone PWM output
        /// <c>EHRPWM2A</c> at pins <c>P8.19</c> or <c>P8.45</c>.
        /// </summary>
        public const int EHRPWM2A = 2;

        /// <summary>
        /// PWM output channel number for the remote BeagleBone PWM output
        /// <c>EHRPWM2B</c> at pins <c>P8.13</c> or <c>P8.46</c>.
        /// </summary>
        public const int EHRPWM2B = 3;

        /// <summary>
        /// SPI slave channel number for the remote BeagleBone SPI slave select
        /// <c>SPI1_0</c> at pin <c>P9.28</c>
        /// </summary>
        public const int SPI1_0 = 0;

        /// <summary>
        /// SPI slave channel number for the remote BeagleBone SPI slave select
        /// <c>SPI1_1</c> at pin <c>P9.42</c>
        /// </summary>
        public const int SPI1_1 = 1;

        /// <summary>
        /// SPI slave channel number for the remote BeagleBone SPI slave select
        /// <c>SPI0_0</c> at pin <c>P9.17</c>
        /// </summary>
        public const int SPI0_0 = 2;
    }
}
