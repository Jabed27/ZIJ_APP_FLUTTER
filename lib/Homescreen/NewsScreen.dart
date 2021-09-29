import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
        backgroundColor: Colors.brown[400],
      ),
      body: DataFromApi(),
    );
  }
}

class DataFromApi extends StatefulWidget {
  @override
  _DataFromApiState createState() => _DataFromApiState();
}

class _DataFromApiState extends State<DataFromApi> {
  // Future getnewsData() async {
  //   print("getnewsData invoked!!!!!!!!!!!");
  //   var response = await http.get(Uri.https('api.m3o.com', 'News'));
  //   //var response = await http.get("https://newsapi.ai/api/v1/event/getEvents");
  //   var jsondata = jsonDecode(response.body);
  //   List<News> newses = [];
  //   for (var n in jsondata) {
  //     News news = News(n["title"], n["description"], n["url"], n["source"]);
  //     newses.add(news);
  //   }
  //   print("i dont nknow${newses.length}");
  //   return newses;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Card(
        child: FutureBuilder(
          future: getnewsData(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text("Loading"),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data[index].title),
                    );
                  });
            }
          },
        ),
      ),
    ));
  }
}

class News {
  final String title, description, url, source;
  News(this.title, this.description, this.url, this.source);
}
