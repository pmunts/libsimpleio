System.Console.WriteLine("\nRemote I/O Protocol Client\n");

// Create Remote I/O Protocol server object instance

var remdev = new IO.Objects.RemoteIO.Device();

// Query the Remote I/O Protocol server

System.Console.WriteLine(remdev.Version);
System.Console.WriteLine(remdev.Capabilities);
