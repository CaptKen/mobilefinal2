import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';
import '../Models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quote.dart';

class Profile extends StatefulWidget {
  final User user;
  Profile({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  @override
  String myQuote;
  var userid = TextEditingController();
  var name = TextEditingController();
  var age = TextEditingController();
  var password = TextEditingController();
  var user_quote = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  UserProvider userProvider = UserProvider();
  List<User> currentUsers = List();
  @override
  void initState() {
    super.initState();
    userProvider.open('member.db').then((r) {
      print("open success");
    });
  }

  TextFormField new_user() {
    return TextFormField(
      controller: userid,
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        labelText: "User_id",
        hintText: "Input your user id",
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "กรุณากรอก user id";
        } else if (value.length < 6 || value.length > 12) {
          return "user id ต้องมีความยาว 6-12 ตัวอักษร";
        }
      },
    );
  }

  TextFormField nameuser() {
    return TextFormField(
      controller: name,
      decoration: InputDecoration(
        icon: Icon(Icons.person_outline),
        labelText: "Name",
        hintText: "Input your Name",
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "กรุณากรอกขื่อ";
        } else if (" ".allMatches(value).length != 1) {
          return "ระหว่างชื่อและนามสกุลต้องคั่นด้วย 1 space";
        }
      },
    );
  }

  TextFormField agefield() {
    return TextFormField(
      controller: age,
      decoration: InputDecoration(
        icon: Icon(Icons.calendar_today),
        labelText: "Age",
        hintText: "Input your age",
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "กรุณากรอกอายุ";
        } else if (int.parse(value) < 10 || int.parse(value) > 80) {
          return "กรุณากรอกอายุระหว่าง 10 - 80";
        }
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9]"))],
    );
  }

  TextFormField passwordfield() {
    return TextFormField(
      controller: password,
      decoration: InputDecoration(
        icon: Icon(Icons.lock),
        labelText: "Password",
        hintText: "Input your password",
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "กรุณากรอกรหัสผ่าน";
        } else if (value.length < 6) {
          return "รหัสผ่านต้องมีความยาวมากกว่า 6 ตัวอักษร";
        }
      },
      obscureText: true,
    );
  }

  TextFormField set_user_quote() {
    return TextFormField(
      controller: user_quote,
      decoration: InputDecoration(
          labelText: "Quote",
          hintText: "Input your user id",
          
          contentPadding:
              new EdgeInsets.symmetric(vertical: 35.0, horizontal: 20.0),
          border: OutlineInputBorder(
              borderSide:
                  new BorderSide(width: 5.0, style: BorderStyle.solid))),
      keyboardType: TextInputType.text,
    );
  }

  RaisedButton save() {
    User myself = widget.user;
    return RaisedButton(
      child: Text(
        "Save",
        style: TextStyle(color: Colors.pink),
      ),
      onPressed: () async {
        final prfer = await SharedPreferences.getInstance();
        if (_formKey.currentState.validate()) {
          if (userid.text != Null) {
            myself.userid = userid.text;
          }
          if (name != Null) {
            myself.name = name.text;
          }
          if (age.text != Null) {
            myself.age = age.text;
          }
          if (password.text != Null) {
            myself.password = password.text;
          }
          if (user_quote.text != Null) {
            await QuoteText().writeText(user_quote.text);
          }
          userProvider.updateUser(myself).then((r) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(user: myself),
              ),
            );
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(30.0),
                children: <Widget>[
                  new_user(),
                  nameuser(),
                  agefield(),
                  passwordfield(),
                  set_user_quote(),
                  save(),
                ]),
          ),
        ));
  }
}
