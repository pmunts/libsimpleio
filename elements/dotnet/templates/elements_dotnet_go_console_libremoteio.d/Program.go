package elements_dotnet_go_console_libremoteio1

import "fmt"

func main() {
  fmt.Println("\nRemote I/O Protocol Client\n")

  // Create Remote I/O Protocol server object instance

  var remdev = IO.Objects.RemoteIO.Device {}

  // Query the Remote I/O Protocol server

  fmt.Println(remdev.Version)
  fmt.Println(remdev.Capabilities)
}
