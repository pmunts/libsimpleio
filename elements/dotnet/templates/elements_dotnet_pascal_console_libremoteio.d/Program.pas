namespace $safeprojectname$;

  procedure Main(args: array of String);

  begin
    writeLn;
    writeLn('Remote I/O Protocol Client');
    writeLn;

    var remdev := new IO.Objects.RemoteIO.Device();

    writeLn(remdev.Version);
    writeLn(remdev.Capabilities);
  end;

end.
