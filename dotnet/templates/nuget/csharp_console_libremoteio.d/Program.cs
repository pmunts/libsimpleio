using static System.Console;

WriteLine("\nConsole Application using the Remote I/O Protocol\n");

IO.Objects.RemoteIO.Device remdev = new();

// Display some device information

WriteLine(remdev.Version);
WriteLine(remdev.Capabilities);
