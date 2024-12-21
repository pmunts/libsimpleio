// Services for retrieving information about a MuntsOS Embedded Linux target

// Copyright (C)2024, Philip Munts.
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

using System.Data;
using System.Runtime.InteropServices;

namespace IO.Objects.SimpleIO.Platforms
{
    /// <summary>
    /// This static class provides some methods for obtaining information
    /// about a Linux microcomputer running
    /// <a href="https://github.com/pmunts/muntsos">MuntsOS Embedded Linux</a>.
    /// </summary>
    public static class MuntsOS
    {
        /// <summary>
        /// Retrieves the value of a property defined in
        /// <c>/etc/platform</c> on the computer the calling program is
        /// running on.
        /// </summary>
        /// <param name="name">Name of a property defined in
        /// <c>/etc/platform</c>.</param>
        /// <returns>Value of the requested property.</returns>
        public static string GetProperty(string name)
        {
            string prop = System.Environment.GetEnvironmentVariable(name);
            if (prop != null) return prop; else return "Unknown";
        }

        [DllImport("simpleio")]
        private static extern System.IntPtr LINUX_model_name();

        /// <summary>
        /// Retrieves the Device Tree model name of the computer the calling
        /// program is running on.
        /// </summary>
        /// <returns>Device Tree model name</returns>
        public static string GetModelName()
        {
            return Marshal.PtrToStringAnsi(LINUX_model_name());
        }

        /// <summary>
        /// An enumeration of CPU types that may be found on Linux
        /// microcomputer boards support by MuntsOS Embedded Linux.
        /// </summary>
        public enum CPUKinds
        {
            /// <summary>
            /// The CPU is not recognized.
            /// </summary>
            UNKNOWN,
            /// <summary>
            /// CPU used on all Raspberry Pi 1 boards.
            /// </summary>
            BCM2708,
            /// <summary>
            /// CPU used on all Raspberry Pi 2 boards.
            /// </summary>
            BCM2709,
            /// <summary>
            /// CPU used on all Raspberry Pi 3 boards, including the Raspberry
            /// Pi Zero 2.
            /// </summary>
            BCM2710,
            /// <summary>
            /// CPU used on all Raspberry Pi 4 boards.
            /// </summary>
            BCM2711,
            /// <summary>
            /// CPU used on all Raspberry Pi 5 boards.
            /// </summary>
            BCM2712
        }

        // Current (more or less) 64-bit models

        private const string RaspberryPi2_2710 = "Raspberry Pi 2 Model B Rev 1.2";
        private const string RaspberryPi3 = "Raspberry Pi 3";
        private const string RaspberryPiCM3 = "Raspberry Pi Compute Module 3";
        private const string RaspberryPiZero2 = "Raspberry Pi Zero 2";
        private const string RaspberryPi4 = "Raspberry Pi 4";
        private const string RaspberryPiCM4 = "Raspberry Pi Compute Module 4";
        private const string RaspberryPi5 = "Raspberry Pi 5";
        private const string RaspberryPiCM5 = "Raspberry Pi Compute Module 5";

        // Obsolete 32-bit models

        private const string RaspberryPi1 = "Raspberry Pi Model";
        private const string RaspberryPiCM1 = "Raspberry Pi Compute Module Rev";
        private const string RaspberryPiZero = "Raspberry Pi Zero Rev";
        private const string RaspberryPiZeroW = "Raspberry Pi Zero W Rev";
        private const string RaspberryPi2 = "Raspberry Pi 2 Model B";

        /// <summary>
        /// Retrives the kind of CPU the calling program is running on.
        /// </summary>
        /// <returns>A kind of CPU</returns>
        public static CPUKinds GetCPUKind()
        {
            string ModelName = GetModelName();

            // Raspberry Pi 3

            if (ModelName.StartsWith(RaspberryPi2_2710) ||
                ModelName.StartsWith(RaspberryPi3)      ||
                ModelName.StartsWith(RaspberryPiCM3)    ||
                ModelName.StartsWith(RaspberryPiZero2))
                return CPUKinds.BCM2710;

            // Raspberry Pi 4

            if (ModelName.StartsWith(RaspberryPi4)      ||
                ModelName.StartsWith(RaspberryPiCM4))
                return CPUKinds.BCM2711;

            // Raspberry Pi 5

            if (ModelName.StartsWith(RaspberryPi5)      ||
                ModelName.StartsWith(RaspberryPiCM5))
                return CPUKinds.BCM2712;

            // Obsolete 32-bit ARMv6 Raspberry Pi 1

            if (ModelName.StartsWith(RaspberryPi1)      ||
                ModelName.StartsWith(RaspberryPiCM1)    ||
                ModelName.StartsWith(RaspberryPiZero)   ||
                ModelName.StartsWith(RaspberryPiZeroW))
                return CPUKinds.BCM2708;

            // Obsolete 32-bit ARMv7 Raspberry Pi 2

            if (ModelName.StartsWith(RaspberryPi2))
                return CPUKinds.BCM2709;

            return CPUKinds.UNKNOWN;
        }
    }
}
