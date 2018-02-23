import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    NativeModules
} from 'react-native';

var Native = NativeModules.RNBridge;

export default class RN2Scene extends Component {
    handleOnPress() {
        Native.pushToVC('CCOneController',{labelText:'From RN2'})
    }

    render() {
        return (
            <View style={styles.container}>
                <Text style={styles.instructions} onPress={this.handleOnPress}>To Native2</Text> 
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
    },
    instructions: {
        textAlign: 'center',
        color: '#333333',
        marginBottom: 5,
    },
});