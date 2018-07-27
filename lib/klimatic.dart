import 'package:flutter/material.dart';
import 'utils.dart' as util;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {

  void showStuff() async{
    Map data = await getWeather(util.apiID,util.defaultCity);
    print(data.toString());
  }

 String _cityEntered;
  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context).push(
      new MaterialPageRoute<Map>(builder:(BuildContext context){
      return new ChangeCity();
      })
    );
    if(results != null && results.containsKey("enter")){
      _cityEntered = results['enter'];
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Klimatic',style: new TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.menu),
              onPressed:() {_goToNextScreen(context);},
          ),
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/umbrella.png',width: 490.0,height: 1000.0,
            fit: BoxFit.fill,),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text('${_cityEntered == null ?util.defaultCity:_cityEntered}',
            style: cityStyle() ,
            ),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset('images/light_rain.png'),
          ),
          //Weather data
          new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 330.0, 0.0, 0.0),
            child: updateTempWidget(_cityEntered),
          ),

        ],
      ),
    );
  }
  Future<Map> getWeather(String appId, String city) async{
     String apiUrl = "http://api.openweathermap.org/data/2.5/weather?q=$city&&appid=${util.apiID}&units=metric";
     http.Response response = await http.get(apiUrl);
     return json.decode(response.body);

  }

  Widget updateTempWidget(String city){
    return new FutureBuilder(
      future: getWeather(util.apiID,city == null ? util.defaultCity:city ),
        builder: (BuildContext context,AsyncSnapshot<Map> snapshot ){
            if(snapshot.hasData){
              Map content = snapshot.data;
              return new Container(
                child: new Column(
                  children: <Widget>[
                    new ListTile(
                      title: new Text(content['main']['temp'].toString()+"°C",style:weather() ,),
                    ),
                  ],
                ),
              );
            } else {
              return new Container();
            }
    });
  }
}



class ChangeCity extends StatelessWidget {

  var _cityFieldController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text('Change City'),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/white_snow.png',
            width: 490.0,
            height: 1000.0,
              fit: BoxFit.fill,
            ),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title:  new TextField(
                  decoration: new InputDecoration(
                    hintText: "Enter City",
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              new ListTile(
                title: new FlatButton(
                    onPressed: (){
                      Navigator.pop(context,{
                        "enter":_cityFieldController.text
                      });
                    },
                    textColor: Colors.white70,
                    color:  Colors.redAccent,
                    child: new Text('Get Weather')),
              )
            ],
          )
        ],
      ),
    );
  }
}






TextStyle cityStyle(){
  return new TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic
  );
}

TextStyle weather(){
  return new TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9,
  );
}