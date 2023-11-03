package $safeprojectname$;

public class Program
{
  public static int Main(String []args)
  {
    IO.Objects.SimpleIO.syslog.Logger log =
      new IO.Objects.SimpleIO.syslog.Logger();

    log.Note("Hello, World!");
    return 0;
  }
}
