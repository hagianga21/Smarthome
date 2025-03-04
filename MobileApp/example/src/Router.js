import React, { Component } from 'react';
import {StackNavigator,DrawerNavigator} from 'react-navigation';
import MaterialIcons from 'react-native-vector-icons/MaterialIcons';
import Dashboard from './Dashboard';
import Control from './Control';
import Scenes from './Scenes';
import Setting from './Setting';
import AI from './AI';

export const SideMenu = DrawerNavigator({
    Dashboard:{
        screen: Dashboard,
        navigationOptions:{
            drawerIcon: ({ tintColor }) => (
                <MaterialIcons name="dashboard" size={24} style={{ color: tintColor }} />
            ),
        }
    },
    Control:{
        screen: Control,
        navigationOptions:{
            drawerIcon: ({ tintColor }) => (
                <MaterialIcons name="keyboard" size={24} style={{ color: tintColor }} />
            ),
        }
    },
    Scenes:{
        screen: Scenes,
        navigationOptions:{
            drawerIcon: ({ tintColor }) => (
                <MaterialIcons name="insert-photo" size={24} style={{ color: tintColor }} />
            ),
        }
    },
    AI:{
        screen: AI,
        navigationOptions:{
            drawerIcon: ({ tintColor }) => (
                <MaterialIcons name="face" size={24} style={{ color: tintColor }} />
            ),
        }
    },
    Setting:{
        screen: Setting,
        navigationOptions:{
            drawerIcon: ({ tintColor }) => (
                <MaterialIcons name="settings" size={24} style={{ color: tintColor }} />
            ),
        }
    },
})