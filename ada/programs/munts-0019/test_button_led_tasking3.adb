-- MUNTS-0018 Tutorial I/O Board Button and LED Test using tasking

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

WITH Ada.Containers.Synchronized_Queue_Interfaces;
WITH Ada.Containers.Bounded_Synchronized_Queues;

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH GPIO;
WITH MUNTS_0018.LED;
WITH MUNTS_0018.Button_Interrupt;

PROCEDURE test_button_led_tasking3 IS

  -- Define a message queue for ButtonHandler to notify the environment task
  -- about state transitions

  PACKAGE State_Queue_Interface IS NEW Ada.Containers.Synchronized_Queue_Interfaces(Boolean);
  PACKAGE State_Queue_Package   IS NEW Ada.Containers.Bounded_Synchronized_Queues(State_Queue_Interface, 10);

  mqueue : State_Queue_Package.Queue;

  TASK ButtonHandler;

  TASK Body ButtonHandler IS

    Button : GPIO.Pin RENAMES MUNTS_0018.Button_Interrupt.Input;
    LED    : GPIO.Pin RENAMES MUNTS_0018.LED.Output;

  BEGIN
    LOOP
      LED.Put(Button.Get); -- Blocks until press or release!
      mqueue.Enqueue(LED.Get);
    END LOOP;
  END ButtonHandler;

  state : Boolean;

BEGIN
  New_Line;
  Put_Line("MUNTS-0018 Tutorial I/O Board Button and LED Test");
  New_Line;

  LOOP
    SELECT
      mqueue.Dequeue(state);
      Put_Line(IF state THEN "PRESSED" ELSE "RELEASED");
    OR
      DELAY 1.0;
      Put_Line("Tick...");
    END SELECT;
  END LOOP;
END test_button_led_tasking3;
