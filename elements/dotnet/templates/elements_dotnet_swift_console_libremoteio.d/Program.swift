print("Remote I/O Protocol Client")

var remdev = IO.Objects.RemoteIO.Device(IO.Objects.USB.HID.Messenger())

print(remdev.Version)
print(remdev.Capabilities)
