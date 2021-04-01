namespace $safeprojectname$;

  procedure Main(args: array of String);

  begin
    writeLn;
    writeLn('Remote I/O Protocol Client');
    writeLn;

    var dev : IO.Remote.Device :=
      new IO.Remote.Device(new IO.Objects.USB.HID.Messenger());

    writeLn(dev.Version);
    writeln(dev.Capabilities);
  end;

end.
