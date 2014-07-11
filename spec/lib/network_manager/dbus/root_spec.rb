require 'spec_helper'

describe "NetworkManager::DBus::Root" do
  before :each do
    @devices = fixture('devices.yml')
  end
  
  it "should list devices" do
    network_manager_dbus_mock
    list = NetworkManager::DBus::Root.devices
    list.size.should > 0
    list.first.class.should == NetworkManager::DBus::Device
  end
  
  it "should return device_by_interface" do
    network_manager_dbus_mock
    dev = NetworkManager::DBus::Root.device_by_interface 'eth0'
    dev.properties.should == @devices.first.last['properties']
  end
  
  describe "internet_connection?" do
    it 'should recognize internet_connection? if NM_STATE_CONNECTED_GLOBAL' do
      network_manager_dbus_mock
      stub(NetworkManager::DBus::Root.instance).call('state') {
        [NetworkManager::DBus::Root::NM_STATE_CONNECTED_GLOBAL]
      }
      NetworkManager::DBus::Root.internet_connection?.should eq(true)
    end
    
    it 'should not recognize internet_connection? if not NM_STATE_CONNECTED_GLOBAL' do
      network_manager_dbus_mock
      stub(NetworkManager::DBus::Root.instance).call('state') {
        [Time.now.to_i]
      }
      NetworkManager::DBus::Root.internet_connection?.should eq(false)
    end
  end
end
