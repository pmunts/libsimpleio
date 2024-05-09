-- GNU Plot Test

-- Copyright (C)2023, Philip Munts dba Munts Technologies.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH External_Command.Pipeline;

PROCEDURE test_gnuplot IS

  plotter : External_Command.Pipeline.Pipe;

BEGIN
  New_Line;
  Put_Line("GNUPlot Test");
  New_line;

  -- Open pipeline to gnuplot

  plotter.OpenOutput("gnuplot");

  -- Set up the plot

  plotter.Put_Line("set terminal postscript color");
  plotter.Put_Line("set output 'test_gnuplot.ps'");
  plotter.Put_Line("set title 'This is a test'");
  plotter.Put_Line("set border 3");
  plotter.Put_Line("set xlabel 'Time (sec)'");
  plotter.Put_Line("set xtics nomirror");
  plotter.Put_Line("set ylabel 'Voltage'");
  plotter.Put_Line("set ytics nomirror");
  plotter.Put_Line("plot '-' with lines notitle");

  -- Send data

  FOR i IN Natural RANGE 0 .. 99 LOOP
    plotter.Put_Line(i'Image & i'Image);
  END LOOP;

  -- Close pipeline

  plotter.Close;
END test_gnuplot;
