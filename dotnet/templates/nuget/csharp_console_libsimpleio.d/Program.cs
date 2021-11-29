using static System.Console;

WriteLine("\nHello, World!\n");

IO.Interfaces.Log.Logger syslog =
    new IO.Objects.libsimpleio.syslog.Logger("test_syslog",
        IO.Objects.libsimpleio.syslog.Logger.LOG_LOCAL0);

syslog.Note("Hello, World!");
