import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Models/user.dart';
import 'login.dart';

class Register extends StatefulWidget {
  @override
  RegisterState createState() {
    // TODO: implement createState
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  TextEditingController userid = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController age =TextEditingController();
  TextEditingController password = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  UserProvider userProvider = UserProvider();
  List<User> currentUsers = List();
  @override
  void initState() {
    super.initState();
    userProvider.open('member.db').then((r) {
      print("open success");
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

  void deleteUsers() {
    userProvider.deleteUsers().then((r) {});
  }

  TextFormField new_user() {
    return TextFormField(
      controller: userid,
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        labelText: "User_id",
        hintText: "Input your user id",
      ),
      validator: (value){
        if(value.isEmpty){
          return "กรุณากรอก user id";
        }
        else if(value.length < 6 || value.length > 12){
          return "user id ต้องมีความยาวอยู่ในช่วง 6-12 ตัวอักษร";
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
      validator: (value){
        if (value.isEmpty) {
          return "กรุณากรอกขื่อ";
        }else if (" ".allMatches(value).length != 1) {
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
      validator: (value){
        if (value.isEmpty) {
          return "กรุณากรอกอายุ";
        }else if(int.parse(value) < 10 || int.parse(value) > 80){
          return "กรุณากรอกอายุระหว่าง 10-80";
        }
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
            WhitelistingTextInputFormatter(RegExp("[0-9]"))],
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
      validator: (value){
        if (value.isEmpty) {
          return "กรุณากรอกรหัสผ่าน";
        }
        else if(value.length < 6 ){
           return "รหัสผ่านต้องมีความยาวมากกว่า 6 ตัวอักษร";
        }
      },
      obscureText: true,
    );
  }

  RaisedButton register() {
    return RaisedButton(
      child: Text(
        "Register New Account",
        style: TextStyle(color: Colors.pink),
      ),
                            onPressed: () {
                        bool flag = true;
                        if (_formKey.currentState.validate()) {
                          if (currentUsers.length == 0) {
                            print("รอบแรกไม่มีข้อมูลเลย");
                            User user = User(
                                userid: userid.text,
                                name: name.text,
                                age: age.text,
                                password: password.text);
                            userProvider.insert(user).then((r) {
                              Navigator.pushReplacementNamed(context, '/');
                            });
                          } else {
                            print("มีข้อมูลแล้ว เช็คก่อนว่าซ้ำมั้ย ถ้าซ้ำไป 4");
                            for (int i = 0; i < currentUsers.length; i++) {
                              if (userid.text == currentUsers[i].userid) {
                                flag = false;
                                break;
                              }
                            }
                            if (flag) {
                              print("ถ้าไม่ซ้ำ ลง db เลย");
                              User user = User(
                                  userid: userid.text,
                                  name: name.text,
                                  age: age.text,
                                  password: password.text);
                              userProvider.insert(user).then((r) {
                                Navigator.pushReplacementNamed(context, '/');
                                print("success");
                              });
                            } else {
                              print("useridซ้ำ = 4");
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(
                                          'userid ซ้ำ'),
                                    );
                                  });
                            }
                          }
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
          title: Text("REGISTER"),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(20.0),
                children: <Widget>[
                  new_user(),
                  nameuser(),
                  agefield(),
                  passwordfield(),
                  register(),
                ]),
          ),
        ));
  }
}
