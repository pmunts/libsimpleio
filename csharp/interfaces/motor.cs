// Abstract interface for variable speed motor outputs

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

namespace IO.Interfaces.Motor
{
    /// <summary>
    /// Motor velocity contants.
    /// </summary>
    public static class Velocities
    {
        /// <summary>
        /// Minimum velocity (full speed reverse).
        /// </summary>
        public const double Minimum = -1.0;

        /// <summary>
        /// Zero velocity (motor stopped).
        /// </summary>
        public const double Stop = 0.0;

        /// <summary>
        /// Maximum velocity (full speed forward).
        /// </summary>
        public const double Maximum = 1.0;
    }

    /// <summary>
    ///  Abstract interface for variable speed motor outputs.
    /// </summary>
    public interface Output
    {
        /// <summary>
        /// Write-only motor velocity property.
        /// </summary>
        double velocity
        {
            set;
        }
    }
}
