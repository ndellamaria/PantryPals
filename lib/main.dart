import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

final dummySnapshot = [
 {"name": "Filip", "votes": 15},
 {"name": "Abraham", "votes": 14},
 {"name": "Richard", "votes": 11},
 {"name": "Ike", "votes": 10},
 {"name": "Justin", "votes": 1},
];

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'PantryPals',
     home: MySignIn(),
   );
 }
}

// Define a custom Form widget.
class MySignIn extends StatefulWidget {
  @override
  _MySignInState createState() => _MySignInState();
}

//Define a corresponding State class, which holds
//the data related in the form
class _MySignInState extends State<MySignIn> {

  final myUsername = TextEditingController();
  final myPassword = TextEditingController();

  @override
  void dispose() {
    myUsername.dispose();
    myPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Please enter your username and password'),
      ),//appBar
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            TextField (controller: myUsername),
            TextField (controller: myPassword),
          ], //end of children list
        ), //end column
      ), //end body
              floatingActionButton: FloatingActionButton (
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(myUsername)));
              },//onPressed
            tooltip: 'Show me the value!',
            child: Icon(Icons.text_fields),
            ),//Button
    );//Scaffold
  } //end build
}//end home page



class MyHomePage extends StatefulWidget {
  final String name; 

  MyHomePage(this.name);

 @override
 _MyHomePageState createState() {
   return _MyHomePageState(name);
 }
}

class _MyHomePageState extends State<MyHomePage> {
  final String name;

  _MyHomePageState(this.name);

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('Hi ' + name)),
     body: _buildBody(context),
   );
 }

Widget _buildBody(BuildContext context) {
 return StreamBuilder<QuerySnapshot>(
   stream: Firestore.instance.collection('users').snapshots(),
   builder: (context, snapshot) {
     if (!snapshot.hasData) return LinearProgressIndicator();

     return _buildList(context, snapshot.data.documents);
   },
 );
}

 Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
   return ListView(
     padding: const EdgeInsets.only(top: 20.0),
     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
   );
 }

 Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
   final record = Record.fromSnapshot(data);

   return Padding(
     key: ValueKey(record.name),
     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
     child: Container(
       decoration: BoxDecoration(
         border: Border.all(color: Colors.grey),
         borderRadius: BorderRadius.circular(5.0),
       ),
       child: ListTile(
         title: Text(record.name),
         trailing: Text(record.num_groceries.toString()),
         onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Shreya(record.name, record.items.toList())));
         },
       ),
     ),
   );
 }
}

class Record {
 final String name;
 final int num_groceries;
 final List<String> items;
 final DocumentReference reference;

 Record.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['name'] != null),
       assert(map['num_groceries'] != null),
       assert(map['items'] != null),
       name = map['name'],
       num_groceries = map['num_groceries'],
       items = map['items'].cast<String>();

 Record.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

 @override
 String toString() => "Record<$name:$num_groceries>";
}

class UserPage extends StatefulWidget {
 @override
 _UserPageState createState() {
   return _UserPageState();
 }
}

class _UserPageState extends State<UserPage> {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('User')),
     body: _buildBody(context),
   );
 }

Widget _buildBody(BuildContext context) {
 return StreamBuilder<QuerySnapshot>(
   stream: Firestore.instance.collection('users').snapshots(),
   builder: (context, snapshot) {
     if (!snapshot.hasData) return LinearProgressIndicator();

     return _buildList(context, snapshot.data.documents);
   },
 );
}

 Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
   return ListView(
     padding: const EdgeInsets.only(top: 20.0),
     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
   );
 }

 Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
   return Padding(
     key: ValueKey(data),
     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
     child: Container(
       decoration: BoxDecoration(
         border: Border.all(color: Colors.grey),
         borderRadius: BorderRadius.circular(5.0),
       ),
       child: ListTile(
        //  title: data,
       ),
     ),
   );
 }
}


class Shreya extends StatefulWidget {
  final String name; 
  final List<String> items;

  Shreya(this.name, this.items);

 @override
 _ShreyaState createState() {
   return _ShreyaState(name, items);
 }
}

class _ShreyaState extends State<Shreya> {
  final String name;
  final List<String> items;

  _ShreyaState(this.name, this.items);

  final Set<String> _saved = Set<String>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    // Future<DocumentSnapshot> items = Firestore.instance.collection('users').document('shreya').get();
    // items.data['items']

    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: items.length,
        itemBuilder: /*1*/ (context, i) {
          return _buildRow(items[i]);
        });
  }
  // #enddocregion _buildSuggestions

  // #docregion _buildRow
  Widget _buildRow(String data) {
    final bool alreadySaved = _saved.contains(data);
    return ListTile(
      title: Text(data),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(data);
          } else {
            _saved.add(data);
          }
        });
      },
    );
  }

   // #docregion RWS-build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name + "'s List"),
      ),
      body: _buildSuggestions(),
    );
  }
}