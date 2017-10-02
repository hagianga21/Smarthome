import React, { Component } from 'react';
import {AppRegistry,StyleSheet,Text,View} from 'react-native';
import {SideMenu} from './src/Router'
import {createStore} from 'redux';
import {Provider} from 'react-redux';

export default class App extends Component {
  render() {
    return (
      <Provider store = {store}>
        <SideMenu/>
      </Provider>
    );
  }
}

//defaultState
const defaultState={
  serverURL: '192.168.100.20:9000',
};

//reducer -> tien doan action
const reducer = (state = defaultState,action) => {
  switch (action.type) {
    case 'InsertURL':
        return {serverURL: action.url};
    default:
        return state;
  }
};

//Tao ra Store
const store = createStore(reducer);