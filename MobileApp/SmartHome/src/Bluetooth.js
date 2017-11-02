import React, { Component } from 'react';
import {StyleSheet,
        Platform,
        Text,
        View, 
        TouchableOpacity,
        TouchableHighlight,
        Switch,
        ToastAndroid, 
        ActivityIndicator,
        ScrollView,
        Image 
        } from 'react-native';
import BluetoothSerial from 'react-native-bluetooth-serial';
import Modal from 'react-native-modal';


const Button = ({ title, onPress, style, textStyle }) =>
<TouchableOpacity style={[ styles.button, style ]} onPress={onPress}>
  <Text style={[ styles.buttonText, textStyle ]}>{title.toUpperCase()}</Text>
</TouchableOpacity>

const DeviceList = ({ devices, connectedId, showConnectedIcon, onDevicePress }) =>
<ScrollView style={styles.container}>
  <View style={styles.listContainer}>
    {devices.map((device, i) => {
      return (
        <TouchableHighlight
          underlayColor='#DDDDDD'
          key={`${device.id}_${i}`}
          style={styles.listItem} onPress={() => onDevicePress(device)}>
          <View style={{ flexDirection: 'row' }}>
            {showConnectedIcon
            ? (
              <View style={{ width: 48, height: 48, opacity: 0.4 }}>
                {connectedId === device.id
                ? (
                  <Image style={{ resizeMode: 'contain', width: 24, height: 24, flex: 1 }} source={require('./pic/ic_done_black_24dp.png')} />
                ) : null}
              </View>
            ) : null}
            <View style={{ justifyContent: 'space-between', flexDirection: 'row', alignItems: 'center' }}>
              <Text style={{ fontWeight: 'bold' }}>{device.name}</Text>
              <Text>{`<${device.id}>`}</Text>
            </View>
          </View>
        </TouchableHighlight>
      )
    })}
  </View>
</ScrollView>

export default class Bluetooth extends Component {
    constructor (props) {
      super(props)
      this.state = {
        isEnabled: false,
        isEnabled1: false,
        discovering: false,
        devices: [],
        unpairedDevices: [],
        connected: false,
        section: 0,
        modalVisible: null,
      }
    }
  
    componentWillMount () {
      Promise.all([
        BluetoothSerial.isEnabled(),
        BluetoothSerial.list()
      ])
      .then((values) => {
        const [ isEnabled, devices ] = values
        this.setState({ isEnabled, devices })
      })
  
      BluetoothSerial.on('bluetoothEnabled', () => ToastAndroid.show('Bluetooth enabled', ToastAndroid.SHORT))
      BluetoothSerial.on('bluetoothDisabled', () => ToastAndroid.show('Bluetooth disabled', ToastAndroid.SHORT))
      BluetoothSerial.on('error', (err) => console.log(`Error: ${err.message}`))
      BluetoothSerial.on('connectionLost', () => {
        if (this.state.device) {
          ToastAndroid.show(`Connection to device has been lost`,ToastAndroid.SHORT)
        }
        this.setState({ connected: false })
      })
    }
  
    requestEnable() {
      BluetoothSerial.requestEnable()
      .then((res) => this.setState({ isEnabled: true }))
      .catch((err) => ToastAndroid.show(err.message,ToastAndroid.SHORT))
    }
  
    //Enable bluetooth
    enable() {
      BluetoothSerial.enable()
      .then((res) => this.setState({ isEnabled: true }))
      .catch((err) => ToastAndroid.show(err.message,ToastAndroid.SHORT))
    }
    //Disable Bluetooth
    disable() {
      BluetoothSerial.disable()
      .then((res) => this.setState({ isEnabled: false }))
      .catch((err) => ToastAndroid.show(err.message,ToastAndroid.SHORT))
    }
    //Toggle Bluetooth On Off
    toggleBluetooth(value) {
      if (value === true) {
        this.enable();
        //this.setModalVisible(1);
      } else {
        this.disable()
      }
    }
  
    discoverUnpaired () {
      if (this.state.discovering) {
        return false
      } else {
        this.setState({ discovering: true })
        BluetoothSerial.discoverUnpairedDevices()
        .then((unpairedDevices) => {
          this.setState({ unpairedDevices, discovering: false })
        })
        .catch((err) => ToastAndroid.show(err.message,ToastAndroid.SHORT))
      }
    }
  
    cancelDiscovery () {
      if (this.state.discovering) {
        BluetoothSerial.cancelDiscovery()
        .then(() => {
          this.setState({ discovering: false })
        })
        .catch((err) => ToastAndroid.show(err.message,ToastAndroid.SHORT))
      }
    }
  
    pairDevice (device) {
      BluetoothSerial.pairDevice(device.id)
      .then((paired) => {
        if (paired) {
          ToastAndroid.show(`Device ${device.name} paired successfully`,ToastAndroid.SHORT)
          const devices = this.state.devices
          devices.push(device)
          this.setState({ devices, unpairedDevices: this.state.unpairedDevices.filter((d) => d.id !== device.id) })
        } else {
          ToastAndroid.show(`Device ${device.name} pairing failed`,ToastAndroid.SHORT)
        }
      })
      .catch((err) => ToastAndroid.show(err.message,ToastAndroid.SHORT))
    }
    
    //connect to bluetooth device
    connect (device) {
      this.setState({ connecting: true })
      BluetoothSerial.connect(device.id)
      .then((res) => {
        ToastAndroid.show(`Connected to device ${device.name}`,ToastAndroid.SHORT)
        this.setState({ device, connected: true, connecting: false })
      })
      .catch((err) => ToastAndroid.show(err.message,ToastAndroid.SHORT))
    }
    //disconnect to bluetooth device
    disconnect() {
      BluetoothSerial.disconnect()
      .then(() => this.setState({ connected: false }))
      .catch((err) => ToastAndroid.show(err.message,ToastAndroid.SHORT))
    }
  
    toggleConnect (value) {
      if (value === true && this.state.device) {
        this.connect(this.state.device)
      } else {
        this.disconnect()
      }
    }
  
    write (message) {
      if (!this.state.connected) {
        ToastAndroid.show('You must connect to device first',ToastAndroid.SHORT)
      }
  
      BluetoothSerial.write(message)
      .then((res) => {
        ToastAndroid.show('Successfuly wrote to device',ToastAndroid.SHORT)
        this.setState({ connected: true })
      })
      .catch((err) => ToastAndroid.show(err.message,ToastAndroid.SHORT))
    }
  
    onDevicePress (device) {
      if (this.state.section === 0) {
        this.connect(device)
      } else {
        this.pairDevice(device)
      }
    }
  
    writePackets (message, packetSize = 64) {
      const toWrite = iconv.encode(message, 'cp852')
      const writePromises = []
      const packetCount = Math.ceil(toWrite.length / packetSize)
  
      for (var i = 0; i < packetCount; i++) {
        const packet = new Buffer(packetSize)
        packet.fill(' ')
        toWrite.copy(packet, 0, i * packetSize, (i + 1) * packetSize)
        writePromises.push(BluetoothSerial.write(packet))
      }
  
      Promise.all(writePromises)
      .then((result) => {
      })
    }  
    
    setModalVisible(visible) {
        this.setState({modalVisible: visible});
    }

    renderModalContent= () => (
        <View style = {styles.modalView}>
            <Text> Test something new</Text>
            <DeviceList
              showConnectedIcon={this.state.section === 0}
              connectedId={this.state.device && this.state.device.id}
              devices={this.state.section === 0 ? this.state.devices : this.state.unpairedDevices}
              onDevicePress={(device) => this.onDevicePress(device)} />
        </View>
    );


    render() {
      const activeTabStyle = {borderBottomWidth: 6, borderColor: '#009688'}
      return (
        <View style = {{flex:1}}>
            <Text> Test something new</Text>
            <Switch
                  onValueChange={this.toggleBluetooth.bind(this)}
                  value={this.state.isEnabled} 
            />
            <Button
                textStyle={{ color: '#FFFFFF' }}
                style={styles.buttonRaised}
                title='Send'
                onPress={() => this.write("ABC")} />
            <Modal isVisible={this.state.modalVisible === 1}>
                {this.renderModalContent()}
            </Modal>
  
            <View style={[styles.topBar, { justifyContent: 'center', paddingHorizontal: 0 }]}>
              <TouchableOpacity style={[styles.tab, this.state.section === 0 && activeTabStyle]} onPress={() => this.setState({ section: 0 })}>
                <Text style={{ fontSize: 14, color: '#FFFFFF' }}>PAIRED DEVICES</Text>
              </TouchableOpacity>
              <TouchableOpacity style={[styles.tab, this.state.section === 1 && activeTabStyle]} onPress={() => this.setState({ section: 1 })}>
                <Text style={{ fontSize: 14, color: '#FFFFFF' }}>UNPAIRED DEVICES</Text>
              </TouchableOpacity>
            </View>
  
            {this.state.discovering && this.state.section === 1
          ? (
            <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
              <ActivityIndicator
                style={{ marginBottom: 15 }}
                size={60} />
              <Button
                textStyle={{ color: '#FFFFFF' }}
                style={styles.buttonRaised}
                title='Cancel Discovery'
                onPress={() => this.cancelDiscovery()} />
            </View>
          ) : (
            <DeviceList
              showConnectedIcon={this.state.section === 0}
              connectedId={this.state.device && this.state.device.id}
              devices={this.state.section === 0 ? this.state.devices : this.state.unpairedDevices}
              onDevicePress={(device) => this.onDevicePress(device)} />
          )}
  
          <View style={{ alignSelf: 'flex-end', height: 52 }}>
            <ScrollView
              horizontal
              contentContainerStyle={styles.fixedFooter}>
              {Platform.OS === 'android' && this.state.section === 1
              ? (
                <Button
                  title={this.state.discovering ? '... Discovering' : 'Discover devices'}
                  onPress={this.discoverUnpaired.bind(this)} />
              ) : null}
              {Platform.OS === 'android' && !this.state.isEnabled
              ? (
                <Button
                  title='Request enable'
                  onPress={() => this.requestEnable()} />
              ) : null}
            </ScrollView>
          </View>
  
        </View>
      );
    }
  }
  
  const styles = StyleSheet.create({
    container: {
      flex: 0.9,
      backgroundColor: '#F5FCFF'
    },
    topBar: { 
      height: 56, 
      paddingHorizontal: 16,
      flexDirection: 'row', 
      justifyContent: 'space-between', 
      alignItems: 'center' ,
      elevation: 6,
      backgroundColor: '#7B1FA2'
    },
    heading: {
      fontWeight: 'bold',
      fontSize: 16,
      alignSelf: 'center',
      color: '#FFFFFF'
    },
    enableInfoWrapper: {
      flexDirection: 'row',
      justifyContent: 'space-between',
      alignItems: 'center'
    },
    tab: { 
      alignItems: 'center', 
      flex: 0.5, 
      height: 56, 
      justifyContent: 'center', 
      borderBottomWidth: 6, 
      borderColor: 'transparent' 
    },
    connectionInfoWrapper: {
      flexDirection: 'row',
      justifyContent: 'space-between',
      alignItems: 'center',
      paddingHorizontal: 25
    },
    connectionInfo: {
      fontWeight: 'bold',
      alignSelf: 'center',
      fontSize: 18,
      marginVertical: 10,
      color: '#238923'
    },
    listContainer: {
      borderColor: '#ccc',
      borderTopWidth: 0.5
    },
    listItem: {
      flex: 1,
      height: 48,
      paddingHorizontal: 16,
      borderColor: '#ccc',
      borderBottomWidth: 0.5,
      justifyContent: 'center'
    },
    fixedFooter: {
      flexDirection: 'row',
      justifyContent: 'center',
      alignItems: 'center',
      borderTopWidth: 1,
      borderTopColor: '#ddd'
    },
    button: {
      height: 36,
      margin: 5,
      paddingHorizontal: 16,
      alignItems: 'center',
      justifyContent: 'center'
    },
    buttonText: {
      color: '#7B1FA2',
      fontWeight: 'bold',
      fontSize: 14
    },
    buttonRaised: {
      backgroundColor: '#7B1FA2',
      borderRadius: 2,
      elevation: 2
    },
    modalView:{
        backgroundColor: "white", 
        alignItems: 'center',
    },
  })