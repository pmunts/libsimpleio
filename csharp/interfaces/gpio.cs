// Abstract interface for a GPIO pin

// Copyright (C)2017-2023, Philip Munts dba Munts Technologies.
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

namespace IO.Interfaces.GPIO
{
    /// <summary>
    /// Abstract interface for GPIO pins.
    /// </summary>
    public interface Pin
    {
        /// <summary>
        /// Read/Write GPIO state property.
        /// </summary>
        bool state
        {
            get;
            set;
        }
    }

    /// <summary>
    /// GPIO data direction settings.
    /// </summary>
    public enum Direction
    {
        /// <summary>
        /// Input pin (read only)
        /// </summary>
        Input,
        /// <summary>
        /// Output pin (read or write)
        /// </summary>
        Output
    };

    /// <summary>
    /// GPIO polarity settings.
    /// </summary>
    public enum Polarity
    {
        /// <summary>
        /// Configure GPIO pin as active low (inverted logic).
        /// </summary>
        ActiveLow,

        /// <summary>
        /// Configure GPIO pin as active high (normal logic).
        /// </summary>
        ActiveHigh
    };

    /// <summary>
    /// GPIO output drive settings.
    /// </summary>
    public enum Drive
    {
        /// <summary>
        /// Push Pull (current source/sink) output drive.
        /// </summary>
        PushPull,

        /// <summary>
        /// Open Drain (current sink) output drive.
        /// </summary>
        OpenDrain,

        /// <summary>
        /// Open Source (current source) output drive.
        /// </summary>
        OpenSource
    };

    /// <summary>
    /// GPIO input interrupt edge settings.
    /// </summary>
    public enum Edge
    {
        /// <summary>
        /// Configure GPIO input pin with interrupt disabled.
        /// </summary>
        None,

        /// <summary>
        /// Configure GPIO input pin to interrupt on rising edge.
        /// </summary>
        Rising,

        /// <summary>
        /// Configure GPIO pin to interrupt on falling edge.
        /// </summary>
        Falling,

        /// <summary>
        /// Configure GPIO pin to interrupt on both edges.
        /// </summary>
        Both
    };
}
