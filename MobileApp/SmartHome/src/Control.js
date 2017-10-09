import React, { Component } from 'react';
import {StyleSheet,Text,View,TouchableOpacity,Switch, TouchableHighlight, Image} from 'react-native';
import { Header, Icon } from 'react-native-elements';
import {connect} from 'react-redux';
import Modal from 'react-native-modal';
import DatePicker from 'react-native-datepicker';
import ApiAi from "react-native-api-ai"
import Tts from 'react-native-tts';

class Control extends Component {
  constructor(props){
    super(props);
    this.state = {
      result: {"result": {"resolvedQuery":"ABC","action":"ABC","parameters":{"number":"0"},"fulfillment":{"speech":"DEF"}}},
      listeningState: "not started",
      audioLevel: 0,
      isLoading: true,
      modalVisible: null,
      device1State: "off",
      device1Switch: false,
      device1TimeOn : "00:00",
      device1TimeOff: "00:00",
      device2State: "off",
      device2Switch: false,
      device2TimeOn : "00:00",
      device2TimeOff: "00:00",
      device3State: "off",
      device3Switch: false,
      device3TimeOn : "00:00",
      device3TimeOff: "00:00",
    };

    ApiAi.setConfiguration(
      "27729321705749a0b6c8e92cb4812a97", ApiAi.LANG_ENGLISH_US
    ); 
  }

  Speak(){
    Tts.speak(this.state.result.result.fulfillment.speech);
  };

  setModalVisible(visible) {
    this.setState({modalVisible: visible});
  }

  fetchData(){
    var url = 'http://'+ this.props.webserverURL + '/state'; 
    fetch(url)
    .then((response) => response.json())
    .then((responseData) => {
        this.setState({device1State:responseData.device1})
        this.setState({device2State:responseData.device2})
        this.setState({device3State:responseData.device3})
        this.updateDataFromSystem();    
    })
    .catch((error) => {
        console.error(error);
     })
    .done();
  }

  controlDevice(device){
    var url = 'http://'+ this.props.webserverURL +'/'+ device;
    fetch(url,{
      method: 'POST',
      headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
      },
    })
  };

  sendSetTimetoServer(id,TimeOn,TimeOff){
    //http://192.168.100.20:9000/submitTheTimeDevice1?setTimeOn=01%3A02&setTimeOff=14%3A03
    //var url = 'http://192.168.100.20:9000/submitTheTimeDevice1?setTimeOn=05:06&setTimeOff=17:08'
    var url = 'http://'+ this.props.webserverURL + '/submitTheTimeDevice' + id + '?setTimeOn=' + TimeOn + '&setTimeOff=' + TimeOff;
    fetch(url)
    .catch((error) => {
      console.error(error);
    })
    .done();
  };

  renderModalContent = (a,b,c,d,e) => (
    <View style = {styles.modalView}>
      <Text style = {styles.textSetTime}>SET TIME FOR DEVICE</Text>
      <Text style = {styles.textSetTimeOnOff}>Set time when turn device on</Text>
      <DatePicker
        style={{width: 200}}
        date={b}
        mode="time"
        format="HH:mm"
        confirmBtnText="Confirm"
        cancelBtnText="Cancel"
        customStyles={{
          dateInput: {
            marginLeft: 36
          }
        }}
        onDateChange={c}
      />
      <Text style = {styles.textSetTimeOnOff}>Set time when turn device off</Text>
      <DatePicker
        style={{width: 200}}
        date={d}
        mode="time"
        format="HH:mm"
        confirmBtnText="Confirm"
        cancelBtnText="Cancel"
        customStyles={{
          dateInput: {
            marginLeft: 36
          }
        }}
        onDateChange={e}
      />
      <View style = {{flexDirection: 'row', marginTop:20}}>
        <TouchableHighlight onPress={() => {
          this.setModalVisible(null)
          this.sendSetTimetoServer(a,b,d);
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

  HandlerVoice(){
    if(this.state.result.result.action === "turnOnDevice"){
      if(this.state.result.result.parameters.number === "1" && this.state.device1Switch === false){
        this.setState({device1Switch: true});
        this.controlDevice('device1');
      }
      if(this.state.result.result.parameters.number === "2" && this.state.device2Switch === false){
        this.setState({device2Switch: true});
        this.controlDevice('device2');
      }
      if(this.state.result.result.parameters.number === "3" && this.state.device3Switch === false){
        this.setState({device3Switch: true});
        this.controlDevice('device3');
      }
    }

    if(this.state.result.result.action === "turnOffDevice"){
      if(this.state.result.result.parameters.number === "1" && this.state.device1Switch === true){
        this.setState({device1Switch: false});
        this.controlDevice('device1');
      }
      if(this.state.result.result.parameters.number === "2" && this.state.device2Switch === true){
        this.setState({device2Switch: false});
        this.controlDevice('device2');
      }
      if(this.state.result.result.parameters.number === "3" && this.state.device3Switch === true){
        this.setState({device3Switch: false});
        this.controlDevice('device3');
      }
    }

  };
  updateDataFromSystem(){
    if(this.state.device1State === "on"){
      this.setState({device1Switch: true})
    }
    if(this.state.device1State === "off"){
      this.setState({device1Switch: false})
    }

    if(this.state.device2State === "on"){
      this.setState({device2Switch: true})
    }
    if(this.state.device2State === "off"){
      this.setState({device2Switch: false})
    }

    if(this.state.device3State === "on"){
      this.setState({device3Switch: true})
    }
    if(this.state.device3State === "off"){
      this.setState({device3Switch: false})
    }
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
                      onPress ={()=>{this.fetchData()}}
                      name = "sync"
                      color = "white"
                      size = {35}
                      underlayColor = "#273779"
                  />
              }
              
          />
        </View> 
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
            
        <View style={{alignItems:'center',marginTop:15}}>
          <View style={styles.Box}>
            <Text style ={styles.labelOfDevice}>Device 3</Text>
            <Switch
              onValueChange={(value) => {this.setState({device3Switch: value});this.controlDevice('device3')}}
              value={this.state.device3Switch}
              style = {{marginLeft: 110}}
            />
            <Text style = {styles.textOnOff}>{this.state.device3Switch ? 'ON' : 'OFF'}</Text>
            <Icon
              onPress ={()=>{this.setModalVisible(3)}}
              name = "alarm"
              color = "black"
              size = {35}
              underlayColor = "#273779"
              style = {{marginLeft: 15}}
            />
          </View>
        </View>
        
        <Text>{"Listening State: " + this.state.listeningState}</Text>
        <Text>{"Audio Level: " + this.state.audioLevel}</Text>
        <Text>{"Ask: " + this.state.result.result.resolvedQuery}</Text>
        <Text>{"Result: " + this.state.result.result.fulfillment.speech}</Text>
        <Text>{"Action: " + this.state.result.result.action + this.state.result.result.parameters.number }</Text>

        <View style = {{marginLeft:300, marginTop:200}}>
          <TouchableOpacity onPress={() => {
                    ApiAi.onListeningStarted(() => {
                        this.setState({listeningState: "started"});
                    });

                    ApiAi.onListeningCanceled(() => {
                        this.setState({listeningState: "canceled"});
                    });

                    ApiAi.onListeningFinished(() => {
                        this.setState({listeningState: "finished"});
                    });

                    ApiAi.onAudioLevel(level => {
                        this.setState({audioLevel: level});
                    });

                    ApiAi.startListening(result => {
                        console.log(result);                        
                        this.setState({result: JSON.parse(result)});
                        this.Speak();
                        this.HandlerVoice();
                    }, error => {
                        this.setState({result: error});
                    });
                }}>
            <Image
              style={styles.voiceButton}
              source={require('./pic/voiceButton.png')}
            />          
          </TouchableOpacity>
        </View>

        <Modal isVisible={this.state.modalVisible === 1}>
          {this.renderModalContent('1',this.state.device1TimeOn,
                                  (date) => {this.setState({device1TimeOn: date})},
                                  this.state.device1TimeOff,
                                  (date) => {this.setState({device1TimeOff:date})}
                                  )}
        </Modal>
        
        <Modal isVisible={this.state.modalVisible === 2}>
          {this.renderModalContent('2',this.state.device2TimeOn,
                                  (date) => {this.setState({device2TimeOn: date})},
                                  this.state.device2TimeOff,
                                  (date) => {this.setState({device2TimeOff:date})}
                                  )}
        </Modal>

        <Modal isVisible={this.state.modalVisible === 3}>
          {this.renderModalContent('3',this.state.device3TimeOn,
                                  (date) => {this.setState({device3TimeOn: date})},
                                  this.state.device3TimeOff,
                                  (date) => {this.setState({device3TimeOff:date})}
                                  )}
        </Modal>
      </View>
    );
  }
}


function mapStateToProps(state){
  return {webserverURL: state.serverURL}
}
export default connect(mapStateToProps)(Control);

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
  },
  voiceButton:{
    width: 40,
    height: 40
  }
})