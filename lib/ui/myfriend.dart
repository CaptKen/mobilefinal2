import 'package:flutter/material.dart';
import '../Models/user.dart';
import 'friend.dart';
import 'todos.dart';


class FriendInfoScreen extends StatefulWidget {
  int id;
  String name;
  final User user;
  FriendInfoScreen({Key key, this.id, this.name, this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return FriendInfoScreenState();
  }
}

class FriendInfoScreenState extends State<FriendInfoScreen> {
  @override

  RaisedButton todosButton() {
    int id = widget.id;
    String name = widget.name;
    User myself = widget.user;
    return RaisedButton(
      child: Text("TODOS"),
      onPressed: () {
                        Navigator.pushReplacement(
                         context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TodosScreen(id: id, name: name, user: myself),
                          ),
                       );
                     },
    );
  }



  RaisedButton backButton() {
    User myself = widget.user;
    return RaisedButton(
      child: Text("BACK", style: TextStyle(fontWeight: FontWeight.bold),),
       onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FriendScreen(user: myself),
                        ),
                      );
       }
    );
  }


  

  @override
  Widget build(BuildContext context) {
    int id = widget.id;
    String name = widget.name;
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("INFO"),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            Text(
              "${id} : ${name}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            todosButton(),
            backButton()
          ],
        ),
      ),
    );
  }
}