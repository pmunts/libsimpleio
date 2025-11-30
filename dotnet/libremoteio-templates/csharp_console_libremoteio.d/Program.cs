System.Console.WriteLine("\nRemote I/O Protocol Client\n");

// Create Remote I/O Protocol server object instance

var msg    = new IO.Objects.Message64.ZeroMQ.Messenger();
var remdev = new IO.Objects.RemoteIO.Device(msg);

// Query the Remote I/O Protocol server

System.Console.WriteLine(remdev.Version);
System.Console.WriteLine(remdev.Capabilities);
