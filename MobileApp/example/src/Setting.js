import React, { Component } from 'react';
import {StyleSheet, Text, TextInput, View, TouchableOpacity,TouchableHighlight} from 'react-native';
import { Header, Icon } from 'react-native-elements';
import {connect} from 'react-redux';
import {insertServerURL} from './Action';

class Setting extends Component {
  constructor(props){
    super(props)
    this.state = {
        text: '',
        url : "192.168.100.20",
    };
  }
  render() {
    return (
      <View style={{ flex: 1, backgroundColor: "aliceblue"}}>
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
                centerComponent={{ text: 'Setting', style: { color: 'white',fontSize:23, left:-7 } }} 
            />
        </View> 
        <View style = {{marginTop:80}}></View>
        
        <View style = {{alignItems: 'center',}}>
            <View style = {{backgroundColor:"white",width:340,height:200}}>
                <Text style = {styles.textLabel}>Webserver Config</Text>
                <TextInput
                style={styles.textInput}
                placeholder="Type Webserver 's URL"
                onChangeText={(url) => this.setState({url})}
                />
                <TouchableHighlight onPress={() => {
                this.props.dispatch(insertServerURL(this.state.url));
                }}>
                <Text style = {styles.textButton}>SAVE</Text>
                </TouchableHighlight>
            </View>
        </View>

      </View>
    );
  }
}

function mapStateToProps(state){
    return {myValue: state.serverURL}
}
export default connect(mapStateToProps)(Setting);

const styles = StyleSheet.create({
    textLabel:{
        fontSize: 20,
        marginLeft: 10,
    },
    textInput:{
        height: 40, 
        width: 250,
        marginLeft: 10,
        marginTop: 10,
        backgroundColor: "white",
        borderColor: 'gray', 
        borderWidth: 1,
    },
    textButton:{
        fontSize: 20,
        color: "red",
        marginTop:30,
        marginLeft:150,

    }
})