import 'package:flutter/material.dart';
import 'register.dart';
import 'home.dart';
import '../Models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() {
    return new LoginState();
  }
}

SharedPreferences prfer;

class LoginState extends State<Login> {
  BuildContext con;
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String name = '';

  UserProvider userProvider = UserProvider();
  List<User> currentUsers = List();
  @override
  void initState() {
    super.initState();
    readLocal();
    userProvider.open('member.db').then((r) {
      print("open");
      getUsers();
    });
  }

  void getUsers() {
    userProvider.getUsers().then((r) {
      setState(() {
        currentUsers = r;
      });
    });
  }

  void readLocal() async {
    final prfer = await SharedPreferences.getInstance();
    name = prfer.getString('name' ?? '');

    // Force refresh input
    setState(() {});
  }

  TextFormField userid() {
    return TextFormField(
      controller: user,
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        labelText: "User ID",
        hintText: "User ID",
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "Please fill out this form";
        }
      },
      keyboardType: TextInputType.text,
      onSaved: (value) => print(value),
    );
  }

  TextFormField password() {
    return TextFormField(
      controller: pass,
      decoration: InputDecoration(
        icon: Icon(Icons.lock),
        labelText: "Password",
        hintText: "password",
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "Please fill out this form";
        }
      },
      keyboardType: TextInputType.text,
      onSaved: (value) => print(value),
      obscureText: true,
    );
  }

  Row register() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton(
          child: Text("Register New Account",
              style: TextStyle(
                  //color: Color(0xff00976b),
                  color: Colors.pink)),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Register()));
          },
        ),
      ],
    );
  }

  RaisedButton loginButton() {
    
    return RaisedButton(
      child: Text("LOGIN", style: TextStyle(color: Colors.pink)),
      onPressed: () async {
        bool flag = false;
        if (_formKey.currentState.validate()) {
          await userProvider.open("member.db");
          final prfer = await SharedPreferences.getInstance();
          for (int i = 0; i < currentUsers.length; i++) {
            if (user.text == currentUsers[i].userid &&
                pass.text == currentUsers[i].password) {
              flag = true;
              print(name);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(user: currentUsers[i]),
                ),
              );
              await prfer.setString('name', currentUsers[i].name);
            }
          }
          if (!flag) {
            _scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: Text("Invalid user or password"),
            ));
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    con = context;
    return Scaffold(
        key: _scaffoldKey,
        body: Form(
          key: _formKey,
          child: Center(
            child: ListView(
              padding: EdgeInsets.all(20.0),
              shrinkWrap: true,
              children: <Widget>[
                Image.asset(
                  "assets/img/bg_login.jpg",
                  height: 200,
                  width: 200,
                ),
                userid(),
                password(),
                loginButton(),
                register(),
              ],
            ),
          ),
        ));
  }
}
