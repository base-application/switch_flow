import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(),
            TextFormField(),
            SizedBox(height: 30,),
            ElevatedButton(
              child: Text("Login"),
              onPressed: () {  },
            )
          ],
        ),
      ),
    );
  }
}
