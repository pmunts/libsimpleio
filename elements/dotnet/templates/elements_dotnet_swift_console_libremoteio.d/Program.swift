print("Remote I/O Protocol Client")

var dev : IO.Remote.Device =
    IO.Remote.Device(IO.Objects.USB.HID.Messenger())

print(dev.Version);
print(dev.Capabilities);
