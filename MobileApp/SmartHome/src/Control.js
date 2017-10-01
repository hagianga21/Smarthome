import React, { Component } from 'react';
import {StyleSheet,Text,View,TouchableOpacity,Switch, TouchableHighlight} from 'react-native';
import { Header, Icon } from 'react-native-elements';
import Modal from 'react-native-modal';
import DatePicker from 'react-native-datepicker';

export default class Control extends Component {
  constructor(props){
    super(props);
    this.state = {
      isLoading: true,
      modalVisible: null,
      device1State: "off",
      device1Switch: false,
      device1TimeOn : "00:00",
      device1TimeOff: "00:00",
      device2State: "off",
      device2Switch: false,
    };
  }

  setModalVisible(visible) {
    this.setState({modalVisible: visible});
  }

  fetchData(){
    var url = 'http://192.168.100.20:9000/' + 'state'
    fetch(url)
    .then((response) => response.json())
    .then((responseData) => {
        this.setState({device1State:responseData.device1})
        this.updateDataFromSystem();    
    })
    .catch((error) => {
        console.error(error);
     })
    .done();
  }

  controlDevice(device){
    var url = 'http://192.168.100.20:9000/'+ device;
    fetch(url,{
      method: 'POST',
      headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
      },
    })
  };

  renderModalContent = () => (
    <View style = {styles.modalView}>
      <Text style = {styles.textSetTime}>SET TIME FOR DEVICE</Text>
      <Text style = {styles.textSetTimeOnOff}>Set time when turn device on</Text>
      <DatePicker
        style={{width: 200}}
        date={this.state.device1TimeOn}
        mode="time"
        format="HH:mm"
        confirmBtnText="Confirm"
        cancelBtnText="Cancel"
        customStyles={{
          dateInput: {
            marginLeft: 36
          }
        }}
        onDateChange={(date) => {this.setState({device1TimeOn: date})}}
      />
      <Text style = {styles.textSetTimeOnOff}>Set time when turn device off</Text>
      <DatePicker
        style={{width: 200}}
        date={this.state.device1TimeOff}
        mode="time"
        format="HH:mm"
        confirmBtnText="Confirm"
        cancelBtnText="Cancel"
        customStyles={{
          dateInput: {
            marginLeft: 36
          }
        }}
        onDateChange={(date) => {this.setState({time: device1TimeOff})}}
      />
      <View style = {{flexDirection: 'row', marginTop:20}}>
        <TouchableHighlight onPress={() => {
          this.setModalVisible(null)
        }}>
          <Text style = {styles.textSubmit}>Submit</Text>
        </TouchableHighlight>

        <TouchableHighlight onPress={() => {
          this.setModalVisible(null)
        }}>
          <Text style = {styles.textBack}>Back</Text>
        </TouchableHighlight>
      </View>
    </View>
  );

  updateDataFromSystem(){
    if(this.state.device1State === "on"){
      this.setState({device1Switch: true})
    }
    if(this.state.device1State === "off"){
      this.setState({device1Switch: false})
    }
    console.log(this.state.device1State);
  };

  componentDidMount(){
    this.fetchData();
  }
  render() {
    return (
      <View style={{flex:1, backgroundColor: "aliceblue"}}>
        <View>
          <Header
              backgroundColor = "darkgreen"//"#273779"
              leftComponent={
                  <Icon
                      onPress ={()=>{this.props.navigation.navigate('DrawerOpen') }}
                      name = "menu"
                      color = "white"
                      size = {35}
                      underlayColor = "#273779"
                  />
              }
              centerComponent={{ text: 'Control', style: { color: 'white',fontSize:23, left:-7 } }} 
              rightComponent={
                  <Icon
                      onPress ={()=>{this.props.navigation.navigate('DrawerOpen') }}
                      name = "home"
                      color = "white"
                      size = {35}
                      underlayColor = "#273779"
                  />
              }
              
          />
        </View > 
        <View style = {{marginTop:85}}></View>
        
        <View style={{alignItems:'center'}}>
          <View style={styles.Box}>
            <Text style ={styles.labelOfDevice}>Device 1</Text>
            <Switch
              onValueChange={(value) => {this.setState({device1Switch: value});this.controlDevice('device1')}}
              value={this.state.device1Switch}
              style = {{marginLeft: 110}}
            />
            <Text style = {styles.textOnOff}>{this.state.device1Switch ? 'ON' : 'OFF'}</Text>
            <Icon
              onPress ={()=>{this.setModalVisible(1)}}
              name = "alarm"
              color = "black"
              size = {35}
              underlayColor = "#273779"
              style = {{marginLeft: 15}}
            />
          </View>
        </View>
        
        <View style={{alignItems:'center',marginTop:15}}>
          <View style={styles.Box}>
            <Text style ={styles.labelOfDevice}>Device 2</Text>
            <Switch
              onValueChange={(value) => {this.setState({device2Switch: value});this.controlDevice('device2')}}
              value={this.state.device2Switch}
              style = {{marginLeft: 110}}
            />
            <Text style = {styles.textOnOff}>{this.state.device2Switch ? 'ON' : 'OFF'}</Text>
            <Icon
              onPress ={()=>{this.setModalVisible(2)}}
              name = "alarm"
              color = "black"
              size = {35}
              underlayColor = "#273779"
              style = {{marginLeft: 15}}
            />
          </View>
        </View>      

        <Modal isVisible={this.state.modalVisible !== null}>
          {this.renderModalContent()}
        </Modal>
        
      </View>
    );
  }
}

const styles = StyleSheet.create({
  Box:{
    flexDirection: 'row',
    backgroundColor: 'white',
    alignItems: 'center',
    width:340,
    height:45,
  },
  labelOfDevice:{
    fontSize: 20,
    marginLeft: 20,
  },
  textOnOff:{
    marginLeft: 5,
  },
  modalView:{
    backgroundColor: "white", 
    alignItems: 'center',
  },
  textSetTime:{
    fontSize: 26,
  },
  textSetTimeOnOff:{
    fontSize: 18,
    marginTop: 10,
    marginBottom: 10,
  },
  textSubmit:{
    fontSize: 25,
    color: "red",
    marginRight: 90
  },
  textBack:{
    fontSize: 25,
    color: "blue"
  }
})