import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';
import '../Models/user.dart';
import 'friend.dart';
import 'quote.dart';

class Home extends StatefulWidget {
  final User user;
  Home({Key key, this.user}) : super(key: key);
  @override
  _HomeState createState() {
    return _HomeState();
  }
}

String quote;
String hname = '';
class _HomeState extends State<Home> {
  @override
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences prfer;
  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    quote = await QuoteText().readText();
    final prfer = await SharedPreferences.getInstance();
    hname = prfer.getString('name');
    // Force refresh input
    setState(() {});
  }

  // RaisedButton setup() {
  //   User user = widget.user;
  //   return RaisedButton(
  //     child: Text(
  //       "ProFile setup",
  //       style: TextStyle(color: Colors.pink),
  //     ),
  //     onPressed: () {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => Profile(user: user,),
  //                     ),
  //                   );
  //                 },

  // RaisedButton sign_out() {

  // return
  // }
  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(15.0),
                children: <Widget>[
                  ListTile(
                    // title: Text(name),
                    title: Text(
                      'Hello ${hname}',
                      style: new TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    subtitle: Text('this is my quote " ' + quote + ' "'),
                  ),
                  RaisedButton(
                    child: Text(
                      "ProFile setup",
                      style: TextStyle(color: Colors.pink),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(user: user),
                        ),
                      );
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      "My friends",
                      style: TextStyle(color: Colors.pink),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FriendScreen(user: user),
                        ),
                      );
                    },
                  ),
                  RaisedButton(
                    child: Text("Sign Out",
                    style: TextStyle(color: Colors.pink),
                    ),
                    onPressed: () async {
                      final prfer = await SharedPreferences.getInstance();
                      await prfer.clear();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                ]),
          ),
        ));
  }
}
