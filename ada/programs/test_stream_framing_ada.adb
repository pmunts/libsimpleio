-- Stream Framing Protocol Encoding/Decoding Test

-- Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

WITH Stream_Framing_Protocol;

PROCEDURE test_stream_framing_ada IS

  PACKAGE SFP IS NEW Stream_Framing_Protocol(10);

  payload     : SFP.PayloadBuffer;
  payloadsize : SFP.PayloadSize;
  frame       : SFP.FrameBuffer;
  framesize   : SFP.FrameSize;

BEGIN
  New_Line;
  Put_Line("Stream Framing Protocol Test");
  New_Line;

  -- Empty frame

  payload := (OTHERS =>  0);
  SFP.Dump(payload);
  SFP.Encode(payload, 0, frame, framesize);
  SFP.Dump(frame);

  SFP.Decode(frame, framesize, payload, payloadsize);
  SFP.Dump(payload);
  New_Line;

  -- Frame containing "123456789"

  payload := (49, 50, 51, 52, 53, 54, 55, 56, 57, OTHERS => 0);
  SFP.Dump(payload);
  SFP.Encode(payload, 9, frame, framesize);
  SFP.Dump(frame);

  SFP.Decode(frame, framesize, payload, payloadsize);
  SFP.Dump(payload);
  New_Line;

  -- Frame containing DLE DLE ...

  payload := (OTHERS => 16);
  SFP.Dump(payload);
  SFP.Encode(payload, 10, frame, framesize);
  SFP.Dump(frame);

  SFP.Decode(frame, framesize, payload, payloadsize);
  SFP.Dump(payload);
  New_Line;

END test_stream_framing_ada;
