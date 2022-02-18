import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: SafeArea(child: Center(
        child: Text("Loading"),
      )),
    );
  }
}


class ErrorPage extends StatelessWidget {
  final String? error;
  const ErrorPage({Key? key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Center(
          child: Text(error ?? "Error"),
        ),
      ),
    );
  }
}
