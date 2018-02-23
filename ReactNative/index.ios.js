import React, { Component } from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View
} from 'react-native';
import App from './JS/App'
export default class DemoRN extends Component {
    render() {
        return (
        	<App/>
        );
    }
}


AppRegistry.registerComponent('DemoRN', () => DemoRN);