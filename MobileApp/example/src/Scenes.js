import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Button
} from 'react-native';

import ApiAi from "react-native-api-ai"
import Tts from 'react-native-tts';

export default class Sences extends Component {
    Speak(){
        Tts.speak('Hello, world!');
    };

  render() {
    return (
        <View style={styles.container}>

            <View style={{flex: 1, padding: 10}}>
                <Button title="Start Listening" onPress={() => {
                    this.Speak();
                }}/>
            </View>
        </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
      flex: 1,
      backgroundColor: '#F5FCFF',
  },

});