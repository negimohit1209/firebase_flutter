import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'modal/modal.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Community Board',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Board> boardMessages = List();
  Board board;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();
    board = Board("", "");
    databaseReference = database.reference().child("community_board");
    databaseReference.onChildAdded.listen(_onEntryAdded);
  } //int _counter = 0;

//  void _incrementCounter() {
//    database.reference().child('message').set({
//      "firstname" : "Mohit",
//      "lastName": "Negi",
//      "age": 22,
//    });
//    setState(() {
//      database.reference().child('message').once().then((DataSnapshot snapshot) {
//        Map<dynamic, dynamic> list = snapshot.value;
//        print("values from db: ${list.values}");
//      });
//
//      _counter++;
//    });
//  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Board"),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 0,
            child: Form(
              key: formKey,
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.subject),
                    title: TextFormField(
                      initialValue: "",
                      onSaved: (val) => board.subject = val,
                      validator: (val) => val == "" ? val : null
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.message),
                    title: TextFormField(
                      initialValue: "",
                      onSaved: (val) => board.body = val,
                      validator: (val) => val == "" ? val : null
                    ),
                  ),
                  FlatButton(
                    child: Text("Post"),
                    color: Colors.redAccent,
                    onPressed: (){
                      handleSubmit();
                    }
                  )
                ],
              )
            ),

          )
        ],
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _onEntryAdded(Event event) {
    setState(() {
      boardMessages.add(Board.fromSnapshot(event.snapshot));
    });
  }

  void handleSubmit() {
    final FormState form = formKey.currentState;
    if(form.validate()){
      form.save();
      form.reset();
      // save form data to the database
      databaseReference.push().set(board.toJson());
    }
  }
}
