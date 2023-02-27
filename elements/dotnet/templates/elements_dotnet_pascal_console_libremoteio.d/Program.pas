namespace $safeprojectname$;

  procedure Main(args: array of String);

  begin
    writeLn;
    writeLn('Remote I/O Protocol Client');
    writeLn;

    var dev : IO.Objects.RemoteIO.Device :=
      new IO.Objects.RemoteIO.Device(new IO.Objects.USB.HID.Messenger);

    writeLn(dev.Version);
    writeLn(dev.Capabilities);
  end;

end.
