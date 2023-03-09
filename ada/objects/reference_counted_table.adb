-- Copyright (C)2023, Philip Munts.
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

WITH errno;

PACKAGE BODY Reference_Counted_Table IS

  TYPE Item IS RECORD
    key     : Standard.Reference_Counted_Table.Key;
    payload : Element;
    count   : Natural;
  END RECORD;

  Null_Item : CONSTANT Item := Item'(Null_Key, Null_Element, 0);

  TYPE ItemArray IS ARRAY (1 .. Max_Elements) OF Item;

  PROTECTED ProtectedItems IS

    PROCEDURE Create(k : Key; e : OUT Element; error : OUT Integer);

    PROCEDURE Destroy(e : Element; error : OUT Integer);

  PRIVATE

    Items : ItemArray := (OTHERS => Null_Item);

  END ProtectedItems;

  PROTECTED BODY ProtectedItems IS

    PROCEDURE Create(k : Key; e : OUT Element; error : OUT Integer) IS

    BEGIN

      -- Resuse existing element if possible

      FOR x OF Items LOOP
        IF x.key = k THEN
          x.count := x.count + 1;
          e       := x.payload;
          error   := 0;
          RETURN;
        END IF;
      END LOOP;

      -- Otherwise, create a new element and save it for future reuse

      FOR x OF Items LOOP
        IF x.count = 0 THEN
          Create_Element(k, e, error);

          IF error = 0 THEN
            x.key     := k;
            x.payload := e;
            x.count   := 1;
          END IF;

          RETURN;
        END IF;

      END LOOP;

      e     := Null_Element;
      error := errno.EMFILE;
    END Create;

    PROCEDURE Destroy(e : Element; error : OUT Integer) IS

    BEGIN
      FOR x OF Items LOOP
        IF x.payload = e THEN
          x.count := x.count - 1;

          IF x.count = 0 THEN
            Destroy_Element(e, error);
            x := Null_Item;
            RETURN;
          END IF;

          error := 0;
          RETURN;
        END IF;
      END LOOP;

      error := errno.EBADF;
    END Destroy;
  END ProtectedItems;

  -- Wrapper subprograms that can be called from any thread

  PROCEDURE Create(k : Key; e : OUT Element; error : OUT Integer) IS

  BEGIN
    ProtectedItems.Create(k, e, error);
  END Create;

  PROCEDURE Destroy(e : Element; error : OUT Integer) IS

  BEGIN
    ProtectedItems.Destroy(e, error);
  END Destroy;

END Reference_Counted_Table;
