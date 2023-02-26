namespace $safeprojectname$;

  procedure Main(args: array of String);

  begin
    var log := new IO.Objects.SimpleIO.syslog.Logger();
    log.Note('Hello, World!');
  end;

end.
