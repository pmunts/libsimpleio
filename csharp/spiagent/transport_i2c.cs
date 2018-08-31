namespace SPIAgent
{
  public class Transport_I2C : ITransport
  {
    private const byte LPC1114_I2C_ADDRESS = 0x44;
    private readonly IO.Interfaces.I2C.Device dev;
    private byte[] cmd_bytes;
    private byte[] resp_bytes;

    public Transport_I2C(IO.Interfaces.I2C.Bus bus)
    {
      this.dev = dev = new IO.Interfaces.I2C.Device(bus, LPC1114_I2C_ADDRESS);
      this.cmd_bytes = new byte[12];
      this.resp_bytes = new byte[16];
    }

    private static byte Split32(int n, int b)
    {
      return System.Convert.ToByte((n >> (b*8)) & 0xFF);
    }

    private static int Build32(byte b0, byte b1, byte b2, byte b3)
    {
      return (b3 << 24) | (b2 << 16) | (b1 << 8) | b0;
    }

    public void Command(SPIAGENT_COMMAND_MSG_t cmd,
      ref SPIAGENT_RESPONSE_MSG_t resp)
    {
      cmd_bytes[0]  = Split32(cmd.command, 0);
      cmd_bytes[1]  = Split32(cmd.command, 1);
      cmd_bytes[2]  = Split32(cmd.command, 2);
      cmd_bytes[3]  = Split32(cmd.command, 3);

      cmd_bytes[4]  = Split32(cmd.pin, 0);
      cmd_bytes[5]  = Split32(cmd.pin, 1);
      cmd_bytes[6]  = Split32(cmd.pin, 2);
      cmd_bytes[7]  = Split32(cmd.pin, 3);

      cmd_bytes[8]  = Split32(cmd.data, 0);
      cmd_bytes[9]  = Split32(cmd.data, 1);
      cmd_bytes[10] = Split32(cmd.data, 2);
      cmd_bytes[11] = Split32(cmd.data, 3);

      dev.Write(cmd_bytes, cmd_bytes.Length);

      if (cmd.command == (int)Commands.SPIAGENT_CMD_PUT_LEGORC)
        System.Threading.Thread.Sleep(20);
      else
        System.Threading.Thread.Sleep(1);

      dev.Read(resp_bytes, resp_bytes.Length);

      resp.command = Build32(resp_bytes[0],  resp_bytes[1],  resp_bytes[2],  resp_bytes[3]);
      resp.pin     = Build32(resp_bytes[4],  resp_bytes[5],  resp_bytes[6],  resp_bytes[7]);
      resp.data    = Build32(resp_bytes[8],  resp_bytes[9],  resp_bytes[10], resp_bytes[11]);
      resp.error   = Build32(resp_bytes[12], resp_bytes[13], resp_bytes[14], resp_bytes[15]);
    }
  }
}
