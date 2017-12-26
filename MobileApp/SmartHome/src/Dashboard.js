import React, { Component } from 'react';
import {StyleSheet,Text,View,TouchableOpacity} from 'react-native';
import { Header, Icon } from 'react-native-elements';
import {connect} from 'react-redux';
import {changeTemp, changeHumid, changeGas} from './Action';

class Dashboard extends Component {  
  fetchTemp(){
    var url = 'http://'+ this.props.webserverURL + '/temp'; 
    fetch(url)
    .then((response) => response.json())
    .then((responseData) => {
        this.props.dispatch(changeTemp(responseData));
    })
    .catch((error) => {
        console.error(error);
     })
    .done();
  }

  fetchHumid(){
    var url = 'http://'+ this.props.webserverURL + '/humid'; 
    fetch(url)
    .then((response) => response.json())
    .then((responseData) => {
        this.props.dispatch(changeHumid(responseData));
    })
    .catch((error) => {
        console.error(error);
     })
    .done();
  }

  fetchGas(){
    var url = 'http://'+ this.props.webserverURL + '/gas'; 
    fetch(url)
    .then((response) => response.json())
    .then((responseData) => {
        this.props.dispatch(changeGas(responseData));
    })
    .catch((error) => {
        console.error(error);
     })
    .done();
  }

  componentDidMount(){
    this.fetchTemp();
    this.fetchHumid();
    this.fetchGas();
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
                centerComponent={{ text: 'Dashboard', style: { color: 'white',fontSize:23, left:-7 } }} 
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
          </View> 
          <View style = {{marginTop:75}}></View> 
          <View style={{flexDirection: 'row',justifyContent:'center'}}>
            <View style = {styles.box}>
              <Text style = {styles.labelOfBox}>Temperature</Text>
              <Text style = {styles.valueOfBox}>{this.props.temperature}&#8451;</Text>
            </View>
            <View style = {styles.box}>
              <Text style = {styles.labelOfBox}>Humidity</Text>
              <Text style = {styles.valueOfBox}>{this.props.humid}%</Text>
            </View>
          </View>

          <View style={{flexDirection: 'row',justifyContent:'center'}}>
            <View style = {styles.box}>
              <Text style = {styles.labelOfBox}>Gas Detection</Text>
              <Text style = {styles.valueOfBox}>{this.props.gas}</Text>
            </View>
            <View style = {styles.box}>
              <Text style = {styles.labelOfBox}>Security</Text>
              <Text style = {styles.valueOfBox}>Unarmed</Text>
            </View>
          </View>

        </View>
    );
  }
}


function mapStateToProps(state){
  return {webserverURL: state.serverURL,      
          temperature: state.temperature,
          humid: state.humid,
          gas: state.gas,
  }
}
export default connect(mapStateToProps)(Dashboard);

const styles = StyleSheet.create({
  box:{
    alignItems:'center',
    backgroundColor: 'white', 
    width: 150, 
    height: 150,
    margin: 10
  },
  labelOfBox:{
    fontSize: 20,
  },
  valueOfBox:{
    fontSize: 30,
    marginTop:20
  }
})