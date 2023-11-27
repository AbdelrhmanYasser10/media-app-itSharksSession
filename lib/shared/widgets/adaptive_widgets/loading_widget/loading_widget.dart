import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else if(Platform.isIOS){
      return const Scaffold(
        body: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }
    else{
      return const Placeholder();
    }
  }
}
