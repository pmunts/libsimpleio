package $safeprojectname$;

public class Program
{
  public static int Main(String []args)
  {
    Console.WriteLine("\nRemote I/O Protocol Client\n");

    IO.Objects.RemoteIO.Device remdev =
      new IO.Objects.RemoteIO.Device(new IO.Objects.USB.HID.Messenger());

    Console.WriteLine(remdev.Version);
    Console.WriteLine(remdev.Capabilities);

    return 0;
  }
}
