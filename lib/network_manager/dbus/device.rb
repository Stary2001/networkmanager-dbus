class NetworkManager::DBus::Device
  include DBusInterface::Object
  map_dbus :default_iface => 'org.freedesktop.NetworkManager.Device'
  
  NM_DEVICE_TYPE__PROPERTY = 'DeviceType'
  # The device type is unknown.
  NM_DEVICE_TYPE_UNKNOWN   = 0
  # The device is wired Ethernet device.
  NM_DEVICE_TYPE_ETHERNET  = 1
  # The device is an 802.11 WiFi device.
  NM_DEVICE_TYPE_WIFI      = 2
  # Unused
  NM_DEVICE_TYPE_UNUSED1   = 3
  # Unused
  NM_DEVICE_TYPE_UNUSED2   = 4
  # The device is Bluetooth device that provides PAN or DUN capabilities.
  NM_DEVICE_TYPE_BT        = 5
  # The device is an OLPC mesh networking device.
  NM_DEVICE_TYPE_OLPC_MESH = 6
  # The device is an 802.16e Mobile WiMAX device.
  NM_DEVICE_TYPE_WIMAX     = 7
  # The device is a modem
  # supporting one or more of analog telephone, CDMA/EVDO, GSM/UMTS/HSPA,
  # or LTE standards to access a cellular or wireline data network.
  NM_DEVICE_TYPE_MODEM     = 8
  
  def to_s
    "#{self.class} #{properties}"
  end
  
  def ip4_address
    @ip_addr ||= begin
      ip4_int = self['Ip4Address']
      NetworkManager::Ip4Helper.ip4_integer_to_dot_decimal ip4_int
    end
  end
  
  # @return [NetworkManager::DBus::Ip4Config] conf
  def ip4_config
    @ip4_config ||= NetworkManager::DBus::Ip4Config.new properties['Ip4Config']
  end
  
  # @return [NetworkManager::DBus::ActiveConnection] con
  def active_connection
    @active_connection ||=
      NetworkManager::DBus::ActiveConnection.new properties['ActiveConnection']
  end
  
  #
  # ETHERNET
  #
  
  def ethernet?
    properties[NM_DEVICE_TYPE__PROPERTY] == NM_DEVICE_TYPE_ETHERNET
  end
  
  # @return [NetworkManager::DBus::EthernetDevice] dev
  def ethernet
    if ethernet?
      @ethernet ||= NetworkManager::DBus::EthernetDevice.new(self.object_path)
    else
      nil
    end
  end  
end