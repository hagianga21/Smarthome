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
        TextInput
        } from 'react-native';

export default class Test extends Component {
  render() {
    return (
      <View style = {{flex:1}}>
        <Text> Test something new</Text>

      </View>
    );
  }
}


const styles = StyleSheet.create({
  container: {
    flex: 0.9,
    backgroundColor: '#F5FCFF'
  },
})