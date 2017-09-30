import React, { Component } from 'react';
import {StyleSheet,Text,View,TouchableOpacity} from 'react-native';
import { Header, Icon } from 'react-native-elements';

export default class Dashboard extends Component {
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
              <Text style = {styles.valueOfBox}>36&#8451;</Text>
            </View>
            <View style = {styles.box}>
              <Text style = {styles.labelOfBox}>Gas Detection</Text>
              <Text style = {styles.valueOfBox}>NO</Text>
            </View>
          </View>

          <View style={{flexDirection: 'row',justifyContent:'center'}}>
            <View style = {styles.box}>
              <Text style = {styles.labelOfBox}>Human</Text>
              <Text style = {styles.valueOfBox}>YES</Text>
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


const styles = StyleSheet.create({
  box:{
    alignItems:'center',
    backgroundColor: 'cornsilk', 
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