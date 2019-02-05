import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_search_bar/flutter_search_bar.dart';

void main() => runApp(WeatherForcast());

class WeatherForcast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherForcastPage(),
    );
  }
}

class WeatherForcastPage extends StatefulWidget {
  @override
  _WeatherForcastPageState createState() => _WeatherForcastPageState();
}

class _WeatherForcastPageState extends State<WeatherForcastPage> {
  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final myController = TextEditingController();

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('Weather Forcast'),
        backgroundColor: Colors.green,
        actions: [searchBar.getSearchAction(context)]);
  }

   onSubmitted(String value) {
    setState(() {
      cityName = value;
      print(cityName);  
    });
  }

  _WeatherForcastPageState() {
    searchBar = new SearchBar(
      controller: myController,
      inBar: false,
      hintText: "Enter a city name",
      buildDefaultAppBar: buildAppBar,
      setState: setState,
      onSubmitted: onSubmitted,
      closeOnSubmit: true,
      onClosed: () {
      },
    );
  }

  String cityName;
  String atmosphere,avatar,name,tempc;
  double temprature;

    Future getData() async{
      http.Response response = await http.get("https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=5a649eef9cdeb8ca655e59d4ded389c5");
      Map<String, dynamic> data = jsonDecode(response.body);
      name = data['sys']['name'];
      atmosphere = data['weather'][0]['main'];
      avatar = data['weather'][0]['icon'];
      temprature = (data['main']['temp']);
      tempc = (temprature - 273.15).toStringAsFixed(2);
      print(atmosphere);
      print(name);
      print(temprature);
      print(avatar);
      return data;
    }

  @override
  void initState() {
    super.initState();
    setState(() {
      cityName = "Delhi";
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      body: loadData(),
    );
  }

  Widget loadData() {
        return FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  children: <Widget>[
                     Padding(
                       padding: const EdgeInsets.all(15.0),
                       child: Text('$cityName', style: new TextStyle(fontSize: 25.0,color: Colors.white)),
                     ),
                     Divider(),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children:<Widget> [
                        Column(
                        children:<Widget>[ 
                       Text( atmosphere, style: new TextStyle(color: Colors.white, fontSize: 20.0)),
                       Text( tempc + " °C",  style: new TextStyle(color: Colors.white)),
                       ]),
                     Image.network("https://openweathermap.org/img/w/$avatar.png"),
                      ]),
                  ],
                )
              ],
            ),
          );
          }
        );
  }

}