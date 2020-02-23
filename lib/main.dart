import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());
const IconData done_outline = IconData(0xe92f, fontFamily: 'MaterialIcons');
const IconData add = IconData(0xe145, fontFamily: 'MaterialIcons');

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
  final _saved = {
  "Natalie": <String>{},
  "Shreya": <String>{},
  "Helena": <String>{},
  "House": <String>{}
  };
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(myUsername.text, _saved)));
      },//onPressed
      child: Icon(Icons.text_fields),
    ),//Button
    );//Scaffold
  } //end build
}//end home page

class MyHomePage extends StatefulWidget {
  final String current_user; 
  final Map<String,Set<String>> _saved;
  MyHomePage(this.current_user, this._saved);

 @override
 _MyHomePageState createState() {
   return _MyHomePageState(current_user, _saved);
 }
}

class _MyHomePageState extends State<MyHomePage> {
  final String current_user;
  final Map<String,Set<String>> _saved;
  _MyHomePageState(this.current_user, this._saved);

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('Hi ' + current_user),
     actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(done_outline),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FinalList(_saved)));
              },
            )]
      ),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => Shreya(record.name, record.items.toList(), _saved)));
         },
       ),
     ),
   );
 }
}

// class Groceries {
//   final String name;
//   final List<String> items;
// }

class Record {
 final String name;
 final int num_groceries;
 final List<String> items;
 final DocumentReference reference;

 Record.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['name'] != null),
       assert(map['items'] != null),
       name = map['name'],
       num_groceries = map['items'].length,
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
     appBar: AppBar(title: Text('User'),
     actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(add),
              onPressed: () {

              },
            )]),
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
  final Map<String,Set<String>> _saved;

  Shreya(this.name, this.items, this._saved);

 @override
 _ShreyaState createState() {
   return _ShreyaState(name, items, _saved);
 }
}

class _ShreyaState extends State<Shreya> {
  final String name;
  final List<String> items;
  final Map<String,Set<String>> _saved;

  _ShreyaState(this.name, this.items, this._saved);

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
    final bool alreadySaved = _saved[name].contains(data);
    return ListTile(
      title: Text(data),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved[name].remove(data);
          } else {
            _saved[name].add(data);
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
        actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(add),
              onPressed: () {
              },
            )],
      ),
      body: _buildSuggestions(),
    );
  }
}


class FinalList extends StatelessWidget {
  final Map<String,Set<String>> _saved;
  final List<ListItem> items = [];

  FinalList(this._saved);

  @override
  Widget build(BuildContext context) {
    final title = 'Final List';
    _saved.forEach((k,v) {
      items.add(HeadingItem(k));
      v.forEach((item)=>
      items.add(MessageItem(item)));}
    );
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(add),
              onPressed: () {
              },
            )],
        ),
        body: ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: items.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = items[index];

            if (item is HeadingItem) {
              return ListTile(
                title: Text(
                  item.heading,
                  style: Theme.of(context).textTheme.headline,
                ),
              );
            } else if (item is MessageItem) {
              return ListTile(
                title: Text(item.body),
              );
            } 
      //       else if (item is CostItem) {
      //         return ListTile(
      //           leading: const Icon(Icons.person),
      //           title: new TextField(
      //           decoration: new InputDecoration(
      //           hintText: "",
      //     ),
      //   ),
      // ),
            // }
          },
        ),
      ),
    );
  }
}

// The base class for the different types of items the list can contain.
abstract class ListItem {}

// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;
  HeadingItem(this.heading);
}

// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String body;
  MessageItem(this.body);
}
