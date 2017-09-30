import React, { Component } from 'react';
import {StyleSheet,Text,View,TouchableOpacity,Switch} from 'react-native';
import { Header, Icon } from 'react-native-elements';

export default class Control extends Component {
  constructor(props){
    super(props);
    this.state = {
      isLoading: true,
      device1State: "off",
      device1Switch: false
    };
  }
  fetchData(){
    fetch('http://192.168.100.20:9000/state')
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

  controlDevice1(){
    fetch('http://192.168.100.20:9000/device1',{
      method: 'POST',
      headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
      },
    })
  };

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
      <View style={{flex:1}}>
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
        <View style = {{marginTop:75}}></View>
        
        <View style={{alignItems:'center'}}>
          <View style={styles.Box}>
            <Text style ={styles.labelOfDevice}>Device 1</Text>
            <Switch
              onValueChange={(value) => {this.setState({device1Switch: value});this.controlDevice1()}}
              value={this.state.device1Switch}
            />
            <Text>{this.state.device1Switch ? 'On' : 'Off'}</Text>
          </View>
        </View>
        
      </View>
    );
  }
}

const styles = StyleSheet.create({
  Box:{
    flexDirection: 'row',
    backgroundColor: 'cornsilk',
    
    alignItems: 'center',
    width:310,
    height:40,
  },
  labelOfDevice:{
    fontSize: 20,
  }
})