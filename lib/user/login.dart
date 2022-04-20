import 'package:auto_route/auto_route.dart';
import 'package:base_app/page/top_company.dart';
import 'package:base_app/privider/company_provider.dart';
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
  void initState() {
    Api.company(context).then((value){
      Provider.of<CompanyProvider>(context,listen: false).company = value;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const TopCompany(),
              const SizedBox(height: 30),
              TextFormField(
                onSaved: (v){
                  username = v;
                },
                decoration: const InputDecoration(
                  hintText: "userName"
                ),
                validator: (v){
                  if(v==null || v.isEmpty){
                    return "is not empty";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12,),
              TextFormField(
                obscureText: true,
                onSaved: (v){
                  password = v;
                },
                decoration: const InputDecoration(
                    hintText: "password",
                ),
                validator: (v){
                  if(v==null || v.isEmpty){
                    return "is not empty";
                  }
                  return null;
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
                        AutoRouter.of(context).replaceAll([ const ChooseProfileRoute()]);
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
