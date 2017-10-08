import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Button
} from 'react-native';

import ApiAi from "react-native-api-ai"

export default class AI extends Component {
  constructor(props) {
    super(props);

    this.state = {
        result: {"result": {"resolvedQuery":"ABC","action":"ABC","fulfillment":{"speech":"DEF"}}},
        listeningState: "not started",
        audioLevel: 0,
        ask:{},
        answer:"",
    };

    console.log(ApiAi);

    ApiAi.setConfiguration(
        "27729321705749a0b6c8e92cb4812a97", ApiAi.LANG_ENGLISH_US
    ); 
  }
  render() {
    return (
        <View style={styles.container}>

            <View style={{flex: 4}}>
                <Text>{"Listening State: " + this.state.listeningState}</Text>
                <Text>{"Audio Level: " + this.state.audioLevel}</Text>
                <Text>{"Ask: " + this.state.result.result.resolvedQuery}</Text>
                <Text>{"Result: " + this.state.result.result.fulfillment.speech}</Text>
                <Text>{"Action: " + this.state.result.result.action}</Text>
            </View>
            <View style={{flex: 1, padding: 10}}>
                <Button title="Start Listening" onPress={() => {


                    ApiAi.onListeningStarted(() => {
                        this.setState({listeningState: "started"});
                    });

                    ApiAi.onListeningCanceled(() => {
                        this.setState({listeningState: "canceled"});
                    });

                    ApiAi.onListeningFinished(() => {
                        this.setState({listeningState: "finished"});
                    });

                    ApiAi.onAudioLevel(level => {
                        this.setState({audioLevel: level});
                    });

                    ApiAi.startListening(result => {
                        console.log(result);
                        
                        this.setState({result: JSON.parse(result)});
                        this.setState({ask: result});
                        this.setState({answer: result.aiResponse});
                    }, error => {
                        this.setState({result: error});
                    });

                }}/>
            </View>
        </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
      flex: 1,
      backgroundColor: '#F5FCFF',
  },

});