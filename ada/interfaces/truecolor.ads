-- Define a general purpose pixel type, for 24 bit RGB format pixels.
-- Define an interface for a display comprising a rectangular matrix
-- of pixels.  This will be most useful for small embedded system displays
-- such as the LED matrix on the Raspberry Pi Sense Hat.  It is probably
-- too inefficient for full size computer displays.

-- Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

PACKAGE TrueColor IS

  -- Primary color brightness

  TYPE Brightness IS NEW Natural RANGE 0 .. 255;

  -- A single True Color (24-bit) pixel

  TYPE Pixel is RECORD
    red   : Brightness;
    green : Brightness;
    blue  : Brightness;
  END RECORD;

  -- A True Color screen buffer template

  TYPE Screen IS ARRAY (Natural RANGE <>, Natural RANGE <>) OF Pixel;

  -- A True Color display device (abstract interface)

  TYPE DisplayInterface IS INTERFACE;

  TYPE Display IS ACCESS ALL DisplayInterface'Class;

  -- Write a single pixel

  PROCEDURE Put
   (Self  : DisplayInterface;
    row   : Natural;
    col   : Natural;
    value : Pixel) IS ABSTRACT;

  -- Write a pixel buffer

  PROCEDURE Put
   (Self  : DisplayInterface;
    buf   : Screen) IS ABSTRACT;

  -- Clear the display

  PROCEDURE Clear
   (Self  : DisplayInterface) IS ABSTRACT;

  -- HTML color names (from http://www.w3schools.com/colors/colors_names.asp)

  AliceBlue            : CONSTANT Pixel := Pixel'(16#F0#, 16#F8#, 16#FF#);
  AntiqueWhite         : CONSTANT Pixel := Pixel'(16#FA#, 16#EB#, 16#D7#);
  Aqua                 : CONSTANT Pixel := Pixel'(16#00#, 16#FF#, 16#FF#);
  Aquamarine           : CONSTANT Pixel := Pixel'(16#7F#, 16#FF#, 16#D4#);
  Azure                : CONSTANT Pixel := Pixel'(16#F0#, 16#FF#, 16#FF#);
  Beige                : CONSTANT Pixel := Pixel'(16#F5#, 16#F5#, 16#DC#);
  Bisque               : CONSTANT Pixel := Pixel'(16#FF#, 16#E4#, 16#C4#);
  Black                : CONSTANT Pixel := Pixel'(16#00#, 16#00#, 16#00#);
  BlanchedAlmond       : CONSTANT Pixel := Pixel'(16#FF#, 16#EB#, 16#CD#);
  Blue                 : CONSTANT Pixel := Pixel'(16#00#, 16#00#, 16#FF#);
  BlueViolet           : CONSTANT Pixel := Pixel'(16#8A#, 16#2B#, 16#E2#);
  Brown                : CONSTANT Pixel := Pixel'(16#A5#, 16#2A#, 16#2A#);
  BurlyWood            : CONSTANT Pixel := Pixel'(16#DE#, 16#B8#, 16#87#);
  CadetBlue            : CONSTANT Pixel := Pixel'(16#5F#, 16#9E#, 16#A0#);
  Chartreuse           : CONSTANT Pixel := Pixel'(16#7F#, 16#FF#, 16#00#);
  Chocolate            : CONSTANT Pixel := Pixel'(16#D2#, 16#69#, 16#1E#);
  Coral                : CONSTANT Pixel := Pixel'(16#FF#, 16#7F#, 16#50#);
  CornflowerBlue       : CONSTANT Pixel := Pixel'(16#64#, 16#95#, 16#ED#);
  Cornsilk             : CONSTANT Pixel := Pixel'(16#FF#, 16#F8#, 16#DC#);
  Crimson              : CONSTANT Pixel := Pixel'(16#DC#, 16#14#, 16#3C#);
  Cyan                 : CONSTANT Pixel := Pixel'(16#00#, 16#FF#, 16#FF#);
  DarkBlue             : CONSTANT Pixel := Pixel'(16#00#, 16#00#, 16#8B#);
  DarkCyan             : CONSTANT Pixel := Pixel'(16#00#, 16#8B#, 16#8B#);
  DarkGoldenRod        : CONSTANT Pixel := Pixel'(16#B8#, 16#86#, 16#0B#);
  DarkGray             : CONSTANT Pixel := Pixel'(16#A9#, 16#A9#, 16#A9#);
  DarkGrey             : CONSTANT Pixel := Pixel'(16#A9#, 16#A9#, 16#A9#);
  DarkGreen            : CONSTANT Pixel := Pixel'(16#00#, 16#64#, 16#00#);
  DarkKhaki            : CONSTANT Pixel := Pixel'(16#BD#, 16#B7#, 16#6B#);
  DarkMagenta          : CONSTANT Pixel := Pixel'(16#8B#, 16#00#, 16#8B#);
  DarkOliveGreen       : CONSTANT Pixel := Pixel'(16#55#, 16#6B#, 16#2F#);
  DarkOrange           : CONSTANT Pixel := Pixel'(16#FF#, 16#8C#, 16#00#);
  DarkOrchid           : CONSTANT Pixel := Pixel'(16#99#, 16#32#, 16#CC#);
  DarkRed              : CONSTANT Pixel := Pixel'(16#8B#, 16#00#, 16#00#);
  DarkSalmon           : CONSTANT Pixel := Pixel'(16#E9#, 16#96#, 16#7A#);
  DarkSeaGreen         : CONSTANT Pixel := Pixel'(16#8F#, 16#BC#, 16#8F#);
  DarkSlateBlue        : CONSTANT Pixel := Pixel'(16#48#, 16#3D#, 16#8B#);
  DarkSlateGray        : CONSTANT Pixel := Pixel'(16#2F#, 16#4F#, 16#4F#);
  DarkSlateGrey        : CONSTANT Pixel := Pixel'(16#2F#, 16#4F#, 16#4F#);
  DarkTurquoise        : CONSTANT Pixel := Pixel'(16#00#, 16#CE#, 16#D1#);
  DarkViolet           : CONSTANT Pixel := Pixel'(16#94#, 16#00#, 16#D3#);
  DeepPink             : CONSTANT Pixel := Pixel'(16#FF#, 16#14#, 16#93#);
  DeepSkyBlue          : CONSTANT Pixel := Pixel'(16#00#, 16#BF#, 16#FF#);
  DimGray              : CONSTANT Pixel := Pixel'(16#69#, 16#69#, 16#69#);
  DimGrey              : CONSTANT Pixel := Pixel'(16#69#, 16#69#, 16#69#);
  DodgerBlue           : CONSTANT Pixel := Pixel'(16#1E#, 16#90#, 16#FF#);
  FireBrick            : CONSTANT Pixel := Pixel'(16#B2#, 16#22#, 16#22#);
  FloralWhite          : CONSTANT Pixel := Pixel'(16#FF#, 16#FA#, 16#F0#);
  ForestGreen          : CONSTANT Pixel := Pixel'(16#22#, 16#8B#, 16#22#);
  Fuchsia              : CONSTANT Pixel := Pixel'(16#FF#, 16#00#, 16#FF#);
  Gainsboro            : CONSTANT Pixel := Pixel'(16#DC#, 16#DC#, 16#DC#);
  GhostWhite           : CONSTANT Pixel := Pixel'(16#F8#, 16#F8#, 16#FF#);
  Gold                 : CONSTANT Pixel := Pixel'(16#FF#, 16#D7#, 16#00#);
  GoldenRod            : CONSTANT Pixel := Pixel'(16#DA#, 16#A5#, 16#20#);
  Gray                 : CONSTANT Pixel := Pixel'(16#80#, 16#80#, 16#80#);
  Grey                 : CONSTANT Pixel := Pixel'(16#80#, 16#80#, 16#80#);
  Green                : CONSTANT Pixel := Pixel'(16#00#, 16#80#, 16#00#);
  GreenYellow          : CONSTANT Pixel := Pixel'(16#AD#, 16#FF#, 16#2F#);
  HoneyDew             : CONSTANT Pixel := Pixel'(16#F0#, 16#FF#, 16#F0#);
  HotPink              : CONSTANT Pixel := Pixel'(16#FF#, 16#69#, 16#B4#);
  IndianRed            : CONSTANT Pixel := Pixel'(16#CD#, 16#5C#, 16#5C#);
  Indigo               : CONSTANT Pixel := Pixel'(16#4B#, 16#00#, 16#82#);
  Ivory                : CONSTANT Pixel := Pixel'(16#FF#, 16#FF#, 16#F0#);
  Khaki                : CONSTANT Pixel := Pixel'(16#F0#, 16#E6#, 16#8C#);
  Lavender             : CONSTANT Pixel := Pixel'(16#E6#, 16#E6#, 16#FA#);
  LavenderBlush        : CONSTANT Pixel := Pixel'(16#FF#, 16#F0#, 16#F5#);
  LawnGreen            : CONSTANT Pixel := Pixel'(16#7C#, 16#FC#, 16#00#);
  LemonChiffon         : CONSTANT Pixel := Pixel'(16#FF#, 16#FA#, 16#CD#);
  LightBlue            : CONSTANT Pixel := Pixel'(16#AD#, 16#D8#, 16#E6#);
  LightCoral           : CONSTANT Pixel := Pixel'(16#F0#, 16#80#, 16#80#);
  LightCyan            : CONSTANT Pixel := Pixel'(16#E0#, 16#FF#, 16#FF#);
  LightGoldenRodYellow : CONSTANT Pixel := Pixel'(16#FA#, 16#FA#, 16#D2#);
  LightGray            : CONSTANT Pixel := Pixel'(16#D3#, 16#D3#, 16#D3#);
  LightGrey            : CONSTANT Pixel := Pixel'(16#D3#, 16#D3#, 16#D3#);
  LightGreen           : CONSTANT Pixel := Pixel'(16#90#, 16#EE#, 16#90#);
  LightPink            : CONSTANT Pixel := Pixel'(16#FF#, 16#B6#, 16#C1#);
  LightSalmon          : CONSTANT Pixel := Pixel'(16#FF#, 16#A0#, 16#7A#);
  LightSeaGreen        : CONSTANT Pixel := Pixel'(16#20#, 16#B2#, 16#AA#);
  LightSkyBlue         : CONSTANT Pixel := Pixel'(16#87#, 16#CE#, 16#FA#);
  LightSlateGray       : CONSTANT Pixel := Pixel'(16#77#, 16#88#, 16#99#);
  LightSlateGrey       : CONSTANT Pixel := Pixel'(16#77#, 16#88#, 16#99#);
  LightSteelBlue       : CONSTANT Pixel := Pixel'(16#B0#, 16#C4#, 16#DE#);
  LightYellow          : CONSTANT Pixel := Pixel'(16#FF#, 16#FF#, 16#E0#);
  Lime                 : CONSTANT Pixel := Pixel'(16#00#, 16#FF#, 16#00#);
  LimeGreen            : CONSTANT Pixel := Pixel'(16#32#, 16#CD#, 16#32#);
  Linen                : CONSTANT Pixel := Pixel'(16#FA#, 16#F0#, 16#E6#);
  Magenta              : CONSTANT Pixel := Pixel'(16#FF#, 16#00#, 16#FF#);
  Maroon               : CONSTANT Pixel := Pixel'(16#80#, 16#00#, 16#00#);
  MediumAquaMarine     : CONSTANT Pixel := Pixel'(16#66#, 16#CD#, 16#AA#);
  MediumBlue           : CONSTANT Pixel := Pixel'(16#00#, 16#00#, 16#CD#);
  MediumOrchid         : CONSTANT Pixel := Pixel'(16#BA#, 16#55#, 16#D3#);
  MediumPurple         : CONSTANT Pixel := Pixel'(16#93#, 16#70#, 16#DB#);
  MediumSeaGreen       : CONSTANT Pixel := Pixel'(16#3C#, 16#B3#, 16#71#);
  MediumSlateBlue      : CONSTANT Pixel := Pixel'(16#7B#, 16#68#, 16#EE#);
  MediumSpringGreen    : CONSTANT Pixel := Pixel'(16#00#, 16#FA#, 16#9A#);
  MediumTurquoise      : CONSTANT Pixel := Pixel'(16#48#, 16#D1#, 16#CC#);
  MediumVioletRed      : CONSTANT Pixel := Pixel'(16#C7#, 16#15#, 16#85#);
  MidnightBlue         : CONSTANT Pixel := Pixel'(16#19#, 16#19#, 16#70#);
  MintCream            : CONSTANT Pixel := Pixel'(16#F5#, 16#FF#, 16#FA#);
  MistyRose            : CONSTANT Pixel := Pixel'(16#FF#, 16#E4#, 16#E1#);
  Moccasin             : CONSTANT Pixel := Pixel'(16#FF#, 16#E4#, 16#B5#);
  NavajoWhite          : CONSTANT Pixel := Pixel'(16#FF#, 16#DE#, 16#AD#);
  Navy                 : CONSTANT Pixel := Pixel'(16#00#, 16#00#, 16#80#);
  OldLace              : CONSTANT Pixel := Pixel'(16#FD#, 16#F5#, 16#E6#);
  Olive                : CONSTANT Pixel := Pixel'(16#80#, 16#80#, 16#00#);
  OliveDrab            : CONSTANT Pixel := Pixel'(16#6B#, 16#8E#, 16#23#);
  Orange               : CONSTANT Pixel := Pixel'(16#FF#, 16#A5#, 16#00#);
  OrangeRed            : CONSTANT Pixel := Pixel'(16#FF#, 16#45#, 16#00#);
  Orchid               : CONSTANT Pixel := Pixel'(16#DA#, 16#70#, 16#D6#);
  PaleGoldenRod        : CONSTANT Pixel := Pixel'(16#EE#, 16#E8#, 16#AA#);
  PaleGreen            : CONSTANT Pixel := Pixel'(16#98#, 16#FB#, 16#98#);
  PaleTurquoise        : CONSTANT Pixel := Pixel'(16#AF#, 16#EE#, 16#EE#);
  PaleVioletRed        : CONSTANT Pixel := Pixel'(16#DB#, 16#70#, 16#93#);
  PapayaWhip           : CONSTANT Pixel := Pixel'(16#FF#, 16#EF#, 16#D5#);
  PeachPuff            : CONSTANT Pixel := Pixel'(16#FF#, 16#DA#, 16#B9#);
  Peru                 : CONSTANT Pixel := Pixel'(16#CD#, 16#85#, 16#3F#);
  Pink                 : CONSTANT Pixel := Pixel'(16#FF#, 16#C0#, 16#CB#);
  Plum                 : CONSTANT Pixel := Pixel'(16#DD#, 16#A0#, 16#DD#);
  PowderBlue           : CONSTANT Pixel := Pixel'(16#B0#, 16#E0#, 16#E6#);
  Purple               : CONSTANT Pixel := Pixel'(16#80#, 16#00#, 16#80#);
  RebeccaPurple        : CONSTANT Pixel := Pixel'(16#66#, 16#33#, 16#99#);
  Red                  : CONSTANT Pixel := Pixel'(16#FF#, 16#00#, 16#00#);
  RosyBrown            : CONSTANT Pixel := Pixel'(16#BC#, 16#8F#, 16#8F#);
  RoyalBlue            : CONSTANT Pixel := Pixel'(16#41#, 16#69#, 16#E1#);
  SaddleBrown          : CONSTANT Pixel := Pixel'(16#8B#, 16#45#, 16#13#);
  Salmon               : CONSTANT Pixel := Pixel'(16#FA#, 16#80#, 16#72#);
  SandyBrown           : CONSTANT Pixel := Pixel'(16#F4#, 16#A4#, 16#60#);
  SeaGreen             : CONSTANT Pixel := Pixel'(16#2E#, 16#8B#, 16#57#);
  SeaShell             : CONSTANT Pixel := Pixel'(16#FF#, 16#F5#, 16#EE#);
  Sienna               : CONSTANT Pixel := Pixel'(16#A0#, 16#52#, 16#2D#);
  Silver               : CONSTANT Pixel := Pixel'(16#C0#, 16#C0#, 16#C0#);
  SkyBlue              : CONSTANT Pixel := Pixel'(16#87#, 16#CE#, 16#EB#);
  SlateBlue            : CONSTANT Pixel := Pixel'(16#6A#, 16#5A#, 16#CD#);
  SlateGray            : CONSTANT Pixel := Pixel'(16#70#, 16#80#, 16#90#);
  SlateGrey            : CONSTANT Pixel := Pixel'(16#70#, 16#80#, 16#90#);
  Snow                 : CONSTANT Pixel := Pixel'(16#FF#, 16#FA#, 16#FA#);
  SpringGreen          : CONSTANT Pixel := Pixel'(16#00#, 16#FF#, 16#7F#);
  SteelBlue            : CONSTANT Pixel := Pixel'(16#46#, 16#82#, 16#B4#);
  Tan                  : CONSTANT Pixel := Pixel'(16#D2#, 16#B4#, 16#8C#);
  Teal                 : CONSTANT Pixel := Pixel'(16#00#, 16#80#, 16#80#);
  Thistle              : CONSTANT Pixel := Pixel'(16#D8#, 16#BF#, 16#D8#);
  Tomato               : CONSTANT Pixel := Pixel'(16#FF#, 16#63#, 16#47#);
  Turquoise            : CONSTANT Pixel := Pixel'(16#40#, 16#E0#, 16#D0#);
  Violet               : CONSTANT Pixel := Pixel'(16#EE#, 16#82#, 16#EE#);
  Wheat                : CONSTANT Pixel := Pixel'(16#F5#, 16#DE#, 16#B3#);
  White                : CONSTANT Pixel := Pixel'(16#FF#, 16#FF#, 16#FF#);
  WhiteSmoke           : CONSTANT Pixel := Pixel'(16#F5#, 16#F5#, 16#F5#);
  Yellow               : CONSTANT Pixel := Pixel'(16#FF#, 16#FF#, 16#00#);
  YellowGreen          : CONSTANT Pixel := Pixel'(16#9A#, 16#CD#, 16#32#);

END TrueColor;
