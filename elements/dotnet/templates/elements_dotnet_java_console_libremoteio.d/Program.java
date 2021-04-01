package $safeprojectname$;

public class Program
{
  public static int Main(String []args)
  {
    Console.WriteLine("\nRemote I/O Protocol Client\n");

    IO.Remote.Device dev =
      new IO.Remote.Device(new IO.Objects.USB.HID.Messenger());

    Console.WriteLine(dev.Version);
    Console.WriteLine(dev.Capabilities);

    return 0;
  }
}
