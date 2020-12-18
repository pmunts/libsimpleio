WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Posix;

PROCEDURE test_posix IS

  fd     : Integer;
  error  : Integer;

BEGIN
  New_line;
  Put_Line("Posix Bindings Test");
  New_Line;

  Posix.Open_ReadWrite("/bogus", fd, error);
  Put_Line("errno value   => " & Integer'Image(error));
  Put_Line("error message => " & Posix.strerror(error));
END test_posix;
