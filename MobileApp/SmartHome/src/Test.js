import React, { Component } from 'react';
import {StyleSheet,Text,View, TouchableOpacity} from 'react-native';
import DatePicker from 'react-native-datepicker';

export default class Test extends Component {
  constructor(props){
    super(props)
    this.state = {time:"00:00"}
  }
  render() {
    return (
      <View style = {{flex:1}}>
          <Text> Test something new</Text>
      </View>
    );
  }
}