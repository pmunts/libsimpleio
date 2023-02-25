print("Remote I/O Protocol Client")

var dev : IO.Objects.RemoteIO.Device =
    IO.Objects.RemoteIO.Device(IO.Objects.USB.HID.Messenger())

print(dev.Version);
print(dev.Capabilities);
