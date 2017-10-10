import React, { Component } from 'react';
import {StyleSheet,Text,View, TouchableOpacity} from 'react-native';
import MaterialIcons from 'react-native-vector-icons/MaterialIcons';
import { Header, Icon } from 'react-native-elements';
import {connect} from 'react-redux';
import DatePicker from 'react-native-datepicker';

class Scences extends Component {
  constructor(props){
    super(props)
    this.state = {iAmHome:"off",
                  goodmorning: "off",
                  goodnight: "off",
                  security: "off",
                  }
  }

  fetchData(){
    var url = 'http://'+ this.props.webserverURL + '/scenesjson'; 
    fetch(url)
    .then((response) => response.json())
    .then((responseData) => {
        this.setState({iAmHome:responseData.iAmHome})
        this.setState({goodmorning:responseData.goodmorning})
        this.setState({goodnight:responseData.goodnight})
        this.setState({security:responseData.security})   
    })
    .catch((error) => {
        console.error(error);
     })
    .done();
  }

  controlScenes(scenes){
    var url = 'http://'+ this.props.webserverURL +'/'+ scenes;
    fetch(url,{
      method: 'POST',
      headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
      },
    })
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
                centerComponent={{ text: 'Scences', style: { color: 'white',fontSize:23, left:-7 } }} 
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
          <View style = {{marginTop:75}}></View> 
          <View style={{flexDirection: 'row',justifyContent:'center'}}>
            <TouchableOpacity onPress={() => {this.controlScenes('iAmHome');this.fetchData()}}>
              <View style = {(this.state.iAmHome === "on")? styles.boxChoose:styles.box}>
                <MaterialIcons name="accessibility" size={24} style ={(this.state.iAmHome === "on")? styles.iconChoose:styles.icon}/>
                <Text style = {(this.state.iAmHome === "on")? styles.labelOfBoxChoose:styles.labelOfBox}>I'm Home</Text>
              </View>
            </TouchableOpacity>

            <TouchableOpacity onPress={() => {this.controlScenes('goodmorning');this.fetchData()}}>
              <View style = {(this.state.goodmorning === "on")? styles.boxChoose:styles.box}>
                <MaterialIcons name="brightness-5" size={24} style ={(this.state.goodmorning === "on")? styles.iconChoose:styles.icon}/>
                <Text style = {(this.state.goodmorning === "on")? styles.labelOfBoxChoose:styles.labelOfBox}>Good morning</Text>
              </View>
            </TouchableOpacity>
          </View>

          <View style={{flexDirection: 'row',justifyContent:'center'}}>
            <TouchableOpacity onPress={() => {this.controlScenes('goodnight');this.fetchData()}}>
              <View style = {(this.state.goodnight === "on")? styles.boxChoose:styles.box}>
                <MaterialIcons name="brightness-3" size={24} style ={(this.state.goodnight === "on")? styles.iconChoose:styles.icon}/>
                <Text style = {(this.state.goodnight === "on")? styles.labelOfBoxChoose:styles.labelOfBox}>Good night</Text>
              </View>
            </TouchableOpacity>

            <TouchableOpacity onPress={() => {this.controlScenes('security');this.fetchData()}}>
              <View style = {(this.state.security === "on")? styles.boxChoose:styles.box}>
                <MaterialIcons name="lock-outline" size={24} style ={(this.state.security === "on")? styles.iconChoose:styles.icon}/>
                <Text style = {(this.state.security === "on")? styles.labelOfBoxChoose:styles.labelOfBox}>Security</Text>
              </View>
            </TouchableOpacity>
          </View>

        </View>
    );
  }
}

function mapStateToProps(state){
  return {webserverURL: state.serverURL}
}
export default connect(mapStateToProps)(Scences);

const styles = StyleSheet.create({
  box:{
    flexDirection: 'row',
    alignItems:'center',
    backgroundColor: 'gainsboro', 
    width: 150, 
    height: 50,
    margin: 10
  },
  boxChoose:{
    flexDirection: 'row',
    alignItems:'center',
    backgroundColor: 'white', 
    width: 150, 
    height: 50,
    margin: 10
  },
  labelOfBox:{
    fontSize: 15,
  },
  labelOfBoxChoose:{
    fontSize: 15,
    color: 'green',
  },
  icon:{
    marginLeft: 10,
    marginRight: 10,
  },
  iconChoose:{
    marginLeft: 10,
    marginRight: 10,
    color: 'green',
  }
})