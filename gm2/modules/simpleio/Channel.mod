(* Many Linux kernel devices are identified by a chip, channel pair of *)
(* cardinal values.                                                    *)

(* Copyright (C)2018-2024, Philip Munts dba Munts Technologies.                *)
(*                                                                             *)
(* Redistribution and use in source and binary forms, with or without          *)
(* modification, are permitted provided that the following conditions are met: *)
(*                                                                             *)
(* * Redistributions of source code must retain the above copyright notice,    *)
(*   this list of conditions and the following disclaimer.                     *)
(*                                                                             *)
(* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" *)
(* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE   *)
(* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE  *)
(* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE   *)
(* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR         *)
(* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF        *)
(* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS    *)
(* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN     *)
(* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)     *)
(* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE  *)
(* POSSIBILITY OF SUCH DAMAGE.                                                 *)

IMPLEMENTATION MODULE Channel;

  FROM STextIO  IMPORT WriteString, SkipLine;
  FROM SWholeIO IMPORT ReadCard;

  (* Get channel designator, setting chip to 0 and prompting for channel *)
  (* Appends ": " to the prompt.                                        *)

  PROCEDURE GetDesignator1(prompt : ARRAY OF CHAR) : Designator;

  VAR desg : Designator;

  BEGIN
    desg.chip := 0;

    WriteString(prompt);
    WriteString(": ");
    ReadCard(desg.channel);
    SkipLine;

    RETURN desg;
  END GetDesignator1;

  (* Get channel designator, prompting for both chip and channel *)
  (* Appends " chip:    " and " channel: " to the prompts.       *)

  PROCEDURE GetDesignator2(prompt : ARRAY OF CHAR) : Designator;

  VAR desg : Designator;

  BEGIN
    WriteString(prompt);
    WriteString(" chip:    ");
    ReadCard(desg.chip);
    SkipLine;

    WriteString(prompt);
    WriteString(" channel: ");
    ReadCard(desg.channel);
    SkipLine;

    RETURN desg;
  END GetDesignator2;

END Channel.
