import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:sms/sms.dart';

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
//Parameters
  final myUsername = TextEditingController();
  final myPassword = TextEditingController();

  @override
  void dispose() {
    myUsername.dispose();
    myPassword.dispose();
    super.dispose();
  }
  // String current_user = "";
  final _saved = {
  "Natalie": <String>{},
  "Shreya": <String>{},
  "Helena": <String>{},
  "House": <String>{}
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),//appBar
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            TextField (controller: myUsername,decoration: new InputDecoration(
                    hintText: ("Username"),
                  ),),
            TextField (controller: myPassword,decoration: new InputDecoration(
                    hintText: ("Password"),
                  ),),
            // ListTile(
            //   title: const Text('Natalie'),
            //   leading: Radio(
            //     value: "Natalie",
            //     groupValue: current_user,
            //     onChanged: (String value) {
            //       setState(() {current_user = value;});
            //     },
            //   ),
            // ),
            // ListTile(
            //   title: const Text('Helena'),
            //   leading: Radio(
            //     value: 'Helena',
            //     groupValue: current_user,
            //     onChanged: (String value) {
            //        setState(() {current_user = value;});
            //     },
            //   ),
            // ),
            //   ListTile(
            //   title: const Text('Shreya'),
            //   leading: Radio(
            //     value: 'Shreya',
            //     groupValue: current_user,
            //     onChanged: (String value) {
            //        setState(() {current_user = value;});
            //     },
            //   ),
            // ),
          ], //end of children list
        ), //end column
      ), //end body
      floatingActionButton: FloatingActionButton (
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(myUsername.text, _saved)));
      },//onPressed
      child: Icon(Icons.navigate_next),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => FinalList(current_user, _saved)));
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
  String record_name = record.name;
  if (record.name == current_user) {
    record_name = "Your List";
  }
   return Padding(
     key: ValueKey(record.name),
     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
     child: Container(
       decoration: BoxDecoration(
         border: Border.all(color: Colors.grey),
         borderRadius: BorderRadius.circular(5.0),
       ),
       child: ListTile(
         title: Text(record_name),
         trailing: Text(record.num_groceries.toString()),
         onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Shreya(current_user,record.name, record.items.toList(), _saved)));
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
  final String current_user;
  final String name; 
  final List<String> items;
  final Map<String,Set<String>> _saved;

  Shreya(this.current_user, this.name, this.items, this._saved);

 @override
 _ShreyaState createState() {
   return _ShreyaState(current_user, name, items, _saved);
 }
}

class _ShreyaState extends State<Shreya> {
  final String current_user;
  final String name;
  final List<String> items;
  final Map<String,Set<String>> _saved;

  _ShreyaState(this.current_user, this.name, this.items, this._saved);

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
        alreadySaved ? Icons.check : Icons.check_circle_outline,
        color: alreadySaved ? Colors.green : null,
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
    AppBar ap;
  if (current_user == name) {
      ap = AppBar(
        title: Text("Your List"),
        actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(add),
              onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddToList(name, items)));
              },
            )],
      );
    } else if (name=='House') {
      ap = AppBar(
        title: Text("House List"),
        actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(add),
              onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddToList(name, items)));
              },
            )],
      );
    }
    
    else {
    ap = AppBar(
        title: Text(name + "'s List"),
        
      );
    }
    return Scaffold(
      appBar: ap,
      body: _buildSuggestions(),
    );
  }
}


class FinalList extends StatefulWidget {
  final String current_user;
  final Map<String,Set<String>> _saved;

  FinalList(this.current_user,this._saved);

  @override
  FinalListState createState() => FinalListState(this.current_user, this._saved);    
}

class FinalListState extends State<FinalList> {
  final String current_user;
  final Map<String,Set<String>> _saved;
  final List<ListItem> items = [];

  final tecs = {};

  FinalListState(this.current_user,this._saved);

  @override
  Widget build(BuildContext context) {
    final title = 'Final List';
    String messageString = current_user + " went shopping! Here's a summary of their trip.";

    _saved.forEach((k,v) {
      if (_saved[k].length > 0) {
        if (k != current_user){
          items.add(HeadingItem(k));
          messageString = messageString + k + "'s items: \n";
        } else {
          items.add(HeadingItem('Your Items'));
          messageString = messageString + k + "'s items: \n";
        }
      v.forEach((item) {
      messageString = messageString + item + '\n';
      items.add(MessageItem(item));
      });
      items.add(CostItem(k));
      }
    });
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            // action button
            IconButton(
              icon: const Icon(Icons.navigate_next),
              onPressed: () {
                Map<String,double> _costs = {};
                tecs.forEach((k,v) {
                  _costs[k] = double.parse(v.text);
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) => FinalPage(current_user, _costs, messageString)));
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
            } else if (item is CostItem) {
              TextEditingController  a = new TextEditingController();
              tecs[item.name] = a;
              return ListTile(
                leading: const Icon(Icons.attach_money),
                title: new TextField(
                  controller: a,
                  decoration: new InputDecoration(
                    hintText: (item.name + "'s cost for items"),
                  ),
              ),
              );
            }
          },
        ));
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

class CostItem implements ListItem{
  final String name;
  CostItem(this.name);
}

class UserItem implements ListItem{
final String name;
final String item;

UserItem(this.name,this.item);
}

class FinalPage extends StatefulWidget {
  final String current_user; 
  final Map<String, double> _costs;
  final String messageString;
  FinalPage(this.current_user, this._costs, this.messageString);

 @override
 _FinalPageState createState() {
   return _FinalPageState(current_user, _costs, messageString);
 }
}

class _FinalPageState extends State<FinalPage> {
  final String current_user;
  final Map<String,double> _costs;
  String messageString;
  _FinalPageState(this.current_user, this._costs, this.messageString);

  
  Widget _buildSuggestions() {
    // Future<DocumentSnapshot> items = Firestore.instance.collection('users').document('shreya').get();
    // items.data['items']
  final Map<String, double> finalCosts = {
    "Natalie": 0.0,
    "Shreya": 0.0,
    "Helena": 0.0,
    };

    double extra = 0.0;
    double house_extra = 0.0;

    if (_costs.containsKey(current_user)) {
      extra = extra+(_costs[current_user]*.1);
    }

    if (_costs.containsKey("House") && _costs["House"]!=0) {
      house_extra = _costs["House"]/3;
    }

    finalCosts.forEach((k,v) {
      if (_costs.containsKey(k) && k!=current_user && k!="House") {
        finalCosts[k] = _costs[k]+extra+house_extra;    
      }
      else if (_costs.containsKey(k) && k!="House") {
        finalCosts[k]=_costs[k] + house_extra;
      }
      else if (k!="House") {
        finalCosts[k]=finalCosts[k] + house_extra;
      }
      messageString = messageString + k + " was charged: \$" + finalCosts[k].toStringAsFixed(2);
    });

    List<String> names = finalCosts.keys.toList();

    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: finalCosts.length,
        itemBuilder: /*1*/ (context, i) {
          return _buildRow(names[i],finalCosts[names[i]]);
        });
  }
  // #enddocregion _buildSuggestions

  // #docregion _buildRow
  Widget _buildRow(String name, double cost) {
    if (name == current_user) {
      name = "Your total cost";
    }
    return ListTile(
      title: Text(name),
      trailing: Text('\$'+cost.toStringAsFixed(2))
      );
  }

   // #docregion RWS-build
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Final Prices"),
      ),
      body: 
       Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Expanded(
              child: SizedBox(height: 200,
                child:_buildSuggestions())),
            const SizedBox(height: 30),
            RaisedButton(
              onPressed: () {

                // _sendSMS(messageString,["8154512285", "8438221283", "8432604372"]);
                Navigator.push(context, MaterialPageRoute(builder: (context) => DonePage()));
              },
              child: const Text(
                'Open Venmo',
                style: TextStyle(fontSize: 20)
              ),
            ),
          ]
    )));
  }
}


// Define a custom Form widget.
class AddToList extends StatefulWidget {
  final String docName;
  final List<String> items;
  AddToList(this.docName, this.items);

  @override
  _AddToListState createState() => _AddToListState(docName, this.items);
}

//Define a corresponding State class, which holds
//the data related in the form
class _AddToListState extends State<AddToList> {
  final String docName;
  final List<String> items;
  final newItem = TextEditingController();
  
  _AddToListState(this.docName, this.items);

  @override
  void dispose() {
    newItem.dispose();
    super.dispose();
  }
  String pressed = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter New Item'),
      ),//appBar
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            TextField (controller: newItem), 
            IconButton(
              icon: Icon(add),
              onPressed: () {
                items.add(newItem.text);
                setState(() {pressed = newItem.text;});
                Firestore.instance.collection('users').document(docName).updateData({'items':items});
                // Navigator.push(context, MaterialPageRoute(builder: (context) => AddToList(docName, items)));
              },
            ),
            pressed != '' ? Text(pressed + ' was added to the list') : Text('')
          ], //end of children list
        ), //end column
      ), //end body
    );//Scaffold
  } //end build
}//end home page


// class AllList extends StatefulWidget {
//   final String current_user;
//   final Map<String,Set<String>> _saved;
//   final List<ListItem> items;

//   AllList(this.current_user,this._saved, this.items);

//   @override
//   AllListState createState() => AllListState(this.current_user, this._saved, this.items);    
// }
// class AllListState extends State<AllList> {
//   final String current_user;
//   final Map<String,Set<String>> _saved;
//   final Map<String,Set<String>> allItems;
//   final List<ListItem> items;

//   AllListState(this.current_user,this._saved, this.items);

//   @override
//   Widget build(BuildContext context) {
//     final title = 'All Items';
//     _saved.forEach((k,v) {
//       if (_saved[k].length > 0) {
//         if (k != current_user){
//           items.add(HeadingItem(k));
//         } else {
//           items.add(HeadingItem('Your Items'));
//         }
//       v.forEach((item)=>
//       items.add(UserItem(k,item)));
//       }}
//     );
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(title),
//           actions: <Widget>[
//             // action button
//             // IconButton(
//             //   icon: const Icon(Icons.navigate_next),
//             //   onPressed: () {
//             //     Navigator.push(context, MaterialPageRoute(builder: (context) => AddToList(current_user, items)));
//             //   },
//             // ),
//             // IconButton(
//             //   icon: const Icon(Icons.person_outline),
//             //   onPressed: () {
//             //     Navigator.push(context, MaterialPageRoute(builder: (context) => AddToList('Home', items)));
//             //   },
//             // ),
//             IconButton(
//               icon: const Icon(Icons.home),
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => FinalPage(current_user, _saved)));
//               },
//             ),
//             ],
//         ),
//         body: ListView.builder(
//           // Let the ListView know how many items it needs to build.
//           itemCount: items.length,
//           // Provide a builder function. This is where the magic happens.
//           // Convert each item into a widget based on the type of item it is.
//           itemBuilder: (context, index) {
//             final item = items[index];

//             if (item is HeadingItem) {
//               return ListTile(
//                 title: Text(
//                   item.heading,
//                   style: Theme.of(context).textTheme.headline,
//                 ),
//               );
//             } else if (item is UserItem) {
//               final bool alreadySaved = _saved[item.name].contains(item.item);
//               return ListTile(
//                title: Text(item.item),
//                 trailing: Icon(
//                   alreadySaved ? Icons.favorite : Icons.favorite_border,
//                   color: alreadySaved ? Colors.red : null,
//                 ),
//                 onTap: () {
//                   setState(() {
//                     if (alreadySaved) {
//                       _saved[item.name].remove(item.item);
//                     } else {
//                       _saved[item.name].add(item.item);
//                     }
//                   });
//                 },
//               );
//             } 
//           },
//         ));
//   }
// }


// Define a custom Form widget.
class DonePage extends StatefulWidget {
  @override
  _DonePageState createState() => _DonePageState();
}

//Define a corresponding State class, which holds
//the data related in the form
class _DonePageState extends State<DonePage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("You're Done!"),
      ),//appBar
      body: Center(
        // padding: const EdgeInsets.all(16.0),
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Icon(Icons.check, color: Colors.green, size: 100.0,),
            Text("You're done!", style: TextStyle(fontSize: 32)),
          ], //end of children list
        ), //end column
      ), //end body
    );//Scaffold
  } //end build
}//end home page

void _sendSMS(String message, List<String> recipents) async {
 String _result = await FlutterSms
        .sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
print(_result);
}