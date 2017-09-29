import React, { Component } from 'react';
import {StackNavigator,DrawerNavigator} from 'react-navigation';
import MaterialIcons from 'react-native-vector-icons/MaterialIcons';
import Dashboard from './Dashboard';
import Control from './Control';
import Scenes from './Scenes';


export const SideMenu = DrawerNavigator({
    Dashboard_Screen:{
        screen: Dashboard,
        navigationOptions:{
            drawerIcon: ({ tintColor }) => (
                <MaterialIcons name="drafts" size={24} style={{ color: tintColor }} />
            ),
        }
    },
    Control_Screen:{
        screen: Control
    },
})