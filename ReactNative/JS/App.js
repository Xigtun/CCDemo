import {
    StackNavigator,
    NavigationActions,
} from 'react-navigation';
import  RN1Scene from './RN1Scene';
import  RN2Scene from './RN2Scene'

const RNNav = StackNavigator({
    RN1Scene:{
        screen:RN1Scene,
        navigationOptions: {
            headerTitle: 'RN1Scene',
            headerStyle: {
                backgroundColor: '#FF6411'
            },
        }
    },
    RN2Scene:{
        screen:RN2Scene,
        navigationOptions:{
            headerTitle: 'RN2Scene',
        },
    },
},{
    headerMode:'screen'
});

export  default RNNav;