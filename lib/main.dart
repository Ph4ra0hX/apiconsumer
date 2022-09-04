import 'dart:convert';
import 'dart:developer';

import 'package:apiconsumer/Todo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Todo>> getPosts() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Todo> posts = body
          .map(
            (dynamic item) => Todo.fromJson(item),
          )
          .toList();

      return posts;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  int _counter = 0;

  late Future<List<Todo>> Todos;

  @override
  void initState() {
    super.initState();

    Todos = getPosts();

    inspect(Todos);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getPosts(),
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          if (snapshot.hasData) {
            final List<Todo> todos = snapshot.data as List<Todo>;
            return ListView(
              children: todos
                  .map(
                    (Todo todo) => ListTile(
                      leading: ClipOval(
                        child: Image.network(
                            "https://i1.rgstatic.net/ii/profile.image/1160666710835203-1653735916928_Q128/Nauber-Gois.jpg"),
                      ),
                      title: Text(todo.title.toString()),
                      subtitle: Text("${todo.userId}"),
                      trailing: Icon(Icons.more_vert),
                    ),
                  )
                  .toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
