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
        Image,
        WebView,
        Alert,
        TextInput,
        Button,
        KeyboardAvoidingView,
        } from 'react-native';
import {connect} from 'react-redux';
import {insertServerURL} from './Action';

class Login extends Component {
  constructor(props){
    super(props)
    this.state = {
        text: '',
        url : "192.168.100.20",
        username: '',
        password: '',
        flag: false,
    };
  }

  processButton(){
    if(this.state.username == "giang" && this.state.password == "admin"){
      this.props.dispatch(insertServerURL(this.state.url));
      this.props.navigation.navigate('Manhinh_Home');
    }
  }
  render() {
    return (
      <KeyboardAvoidingView behavior = "padding" style = {styles.container}>
        
        <Image
            style={{width: 300, height: 230, marginTop:30}}
            source={require('./pic/smarthome.png')}
        />
        <Text style = {styles.textSmartHome}> Smarthome</Text>

        <View style = {{alignItems: 'center', marginTop:30}}>
            <View style = {{backgroundColor:"white",width:280,height:40}}>
                <TextInput
                  style={styles.textInput}
                  placeholder="Username"
                  onChangeText={(username) => this.setState({username})}
                />    
            </View>
        </View>

        <View style = {{alignItems: 'center', marginTop:10}}>
            <View style = {{backgroundColor:"white",width:280,height:40}}>
                <TextInput
                  style={styles.textInput}
                  placeholder="Password"
                  onChangeText={(password) => this.setState({password})}
                />    
            </View>
        </View>

        <View style = {{alignItems: 'center', marginTop:10}}>
            <View style = {{backgroundColor:"white",width:280,height:40}}>
                <TextInput
                  style={styles.textInput}
                  placeholder="Type Webserver 's URL"
                  onChangeText={(url) => this.setState({url})}
                />    
            </View>
        </View>

        <View style = {{alignItems: 'center', marginTop:10}}>
          <Button 
              onPress={() => {this.processButton();}}
              title="Log in"
              color="#841584"
          />
        </View>

      </KeyboardAvoidingView>
    );
  }
}

function mapStateToProps(state){
  return {myValue: state.serverURL}
}
export default connect(mapStateToProps)(Login);

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    backgroundColor: "aliceblue",
  },
  textSmartHome:{
    fontSize: 40,
    color: "black",
    marginTop:30,
  },
})