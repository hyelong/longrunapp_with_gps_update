/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableHighlight,
  NativeModules
} from 'react-native';

//setInterval(function(){ console.log("Hello"); }, 3000*4);
var locationService =  NativeModules.LocationService;

class socketiotest extends Component {
  startTrackLocation() {
    locationService.startLocationService("", "","");
  }

  endTrackLocation() {
    locationService.stopLocationService();
  }

  render() {
    return (
      <View style={styles.container}>
      <TouchableHighlight onPress={ this.startTrackLocation }>
        <Text>start</Text>
      </TouchableHighlight>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit index.ios.js
        </Text>
        <Text style={styles.instructions}>
          Press Cmd+R to reload,{'\n'}
          Cmd+D or shake for dev menu
        </Text>

        <TouchableHighlight onPress={ this.endTrackLocation }>
          <Text>End</Text>
        </TouchableHighlight>
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
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('socketiotest', () => socketiotest);
