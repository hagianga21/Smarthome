import React, { Component } from 'react';
import {StackNavigator,DrawerNavigator} from 'react-navigation';
import Dashboard from './Dashboard';
import Control from './Control';
import Scenes from './Scenes';


export const SideMenu = DrawerNavigator({
    Dashboard_Screen:{
        screen: Dashboard
    },
    Control_Screen:{
        screen: Control
    },
})