import React, { Component } from 'react';
import {StyleSheet,Text,View, TouchableOpacity} from 'react-native';
import DatePicker from 'react-native-datepicker';

export default class Sences extends Component {
  constructor(props){
    super(props)
    this.state = {time:"00:00"}
  }
  render() {
    return (
      <View style={{ flex: 1 }}>
        <DatePicker
          style={{width: 200}}
          date={this.state.time}
          mode="time"
          format="HH:mm"
          confirmBtnText="Confirm"
          cancelBtnText="Cancel"
          customStyles={{
            dateInput: {
              marginLeft: 36
            }
          }}
          onDateChange={(date) => {this.setState({time: date})}}
        />
      </View>
    );
  }
}