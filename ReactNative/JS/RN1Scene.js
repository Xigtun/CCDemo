import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    NativeModules
} from 'react-native';

var Native = NativeModules.RNBridge;

export default class RN1Scene extends Component {

    constructor(props) {
        super(props);
        const {
            navigation,
        } = this.props;
    }

    popViewController() {
        // console.log('sdgdfhgfd')
        Native.popViewController(true)
    }

    render() {
        const { navigate } = this.props.navigation;
        return (
            <View style={styles.container}>
                <Text style={styles.instructions} onPress={()=>navigate('RN2Scene')}>To RN2Scene</Text> 

                <Text style={styles.instructions} onPress={this.popViewController}>Pop VC</Text> 
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