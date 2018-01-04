import React, { Component } from 'react';
import {AppRegistry,StyleSheet,Text,View} from 'react-native';
import {UserStart} from './src/Router'
import {createStore} from 'redux';
import {Provider} from 'react-redux';

export default class App extends Component {
  render() {
    return (
      <Provider store = {store}>
        <UserStart/>
      </Provider>
    );
  }
}

//defaultState
const defaultState={
  serverURL: "192.168.100.13:9000",
  device: [
    {id:0, name: "device0", label: "device0", state: "off", switch: false, timeOn: "00:00", timeOff: "00:00"},
    {id:1, name: "device1", label: "device1", state: "off", switch: false, timeOn: "00:00", timeOff: "00:00"},
    {id:2, name: "device2", label: "device2", state: "off", switch: false, timeOn: "00:00", timeOff: "00:00"},
    {id:3, name: "device3", label: "device3", state: "off", switch: false, timeOn: "00:00", timeOff: "00:00"},
    {id:4, name: "device4", label: "device4", state: "off", switch: false, timeOn: "00:00", timeOff: "00:00"},
  ],
  temperature:20,
  humid:20,
  gas:"YES",
};

//reducer -> tien doan action
const reducer = (state = defaultState,action) => {
  switch (action.type) {
    case 'InsertURL':
        return {...state, serverURL: action.url};
    case 'StateChanged': return {
        ...state,
        device: state.device.map(e => {
          if(e.name !== action.name) 
            return e;
          else{
            if(action.state === "on")
              return {...e, state: action.state, switch:true};
            else
              return {...e, state: action.state, switch:false};  
          }
        })
    };
    case 'TimeOnChanged': return {
        ...state,
        device: state.device.map(e => {
          if(e.name !== action.name) 
            return e;
          else
            return {...e, timeOn: action.time};
        })
    };
    case 'TimeOffChanged': return {
      ...state,
      device: state.device.map(e => {
        if(e.name !== action.name) 
          return e;
        else
          return {...e, timeOff: action.time};
      })
    };
    case 'TempChanged': return {
      ...state,
      temperature: action.temp,
    };

    case 'HumidChanged': return {
      ...state,
      humid: action.humid,
    };
    
    case 'GasChanged': return {
      ...state,
      gas: action.gas,
    };

    default:
        return state;
  }
};

//Tao ra Store
const store = createStore(reducer);