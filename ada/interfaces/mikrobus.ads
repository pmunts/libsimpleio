PACKAGE mikroBUS IS

  SocketError : EXCEPTION;

  -- These are the twelve GPIO pins present in each mikroBUS socket

  TYPE Pins IS (AN, RST, CS, SCK, MISO, MOSI, SDA, SCL, RX, TX, INT, PWM);

END mikroBUS;
