import 'package:auto_route/auto_route.dart';
import 'package:base_app/privider/auth_provider.dart';
import 'package:base_app/request/api.dart';
import 'package:base_app/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? username;
  String? password;
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                onSaved: (v){
                  username = v;
                },
                validator: (v){
                  if(v==null || v.isEmpty){
                    return "is not empty";
                  }
                },
              ),
              TextFormField(
                onSaved: (v){
                  password = v;
                },
                validator: (v){
                  if(v==null || v.isEmpty){
                    return "is not empty";
                  }
                },
              ),
              const SizedBox(height: 30,),
              ElevatedButton(
                child: const Text("Login"),
                onPressed: () {
                  if(_formKey.currentState?.validate() == true){
                    _formKey.currentState?.save();
                    Api.login(context,username!,password!).then((value) {
                      if(value){
                        AutoRouter.of(context).push(const ChooseProfileRoute());
                      }
                    });
                  }
                },
              )
            ],
          ),
        )
      ),
    );
  }
}
