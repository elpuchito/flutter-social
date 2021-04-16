import 'package:flutter/material.dart';
import 'package:flutter_social_app/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String username;

  submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      SnackBar sanckbar = SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Welcome $username!'),
      );
      _scaffoldKey.currentState.showSnackBar(sanckbar);
      // ScaffoldMessenger.of(context).showSnackBar(sanckbar);

      Navigator.pop(context, username);
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context,
          tittleText: 'setup your profile', removeBackButton: true),
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: Center(
                    child: Text('Your Name'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    child: Form(
                      autovalidateMode: AutovalidateMode.always,
                      key: _formKey,
                      child: TextFormField(
                        validator: (val) {
                          if (val.trim().length < 3 || val.isEmpty) {
                            return 'Provide a username with at least 3 characters';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => username = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide.none),
                          hintText: 'Name',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: submit,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
