WITH Device;
WITH mikroBUS.template;

PACKAGE mikroBUS.libsimpleio IS NEW mikroBUS.template(Device.Designator,
  Device.Designator, String, Device.Designator, String, String);
