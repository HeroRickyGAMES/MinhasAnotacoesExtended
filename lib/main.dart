
import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minhasanotacoesextended/LoginScreen.dart';
import 'package:minhasanotacoesextended/mainList.dart';
import 'package:minhasanotacoesextended/prepareMainList.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  runApp(
    MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: mainClass(),
    ),
  );
}

appPrepare(context) async {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final SharedPreferences prefs = await _prefs;

  bool? logado = prefs.getBool('logado');

  await Future.delayed(Duration(seconds: 2));


  if(kIsWeb){
    FirebaseAuth.initialize('AIzaSyDY60t0Yrh9e9s8HnJVVoV-k7gJChKTgNU', VolatileStore());
    Firestore.initialize("minhasanotacoesext-flutter");
  }else{
    if(Platform.isAndroid){
      FirebaseAuth.initialize('AIzaSyDY60t0Yrh9e9s8HnJVVoV-k7gJChKTgNU', VolatileStore());
      Firestore.initialize("minhasanotacoesext-flutter");
    }else{
      if(Platform.isWindows){
        FirebaseAuth.initialize('AIzaSyBPeA_jhjE5Nj5VyW-kRQ9qYn6i4g2jlWs', VolatileStore());
        Firestore.initialize("minhasanotacoesext-flutter");
      }
    }
  }
  //bool user = FirebaseAuth.instance.isSignedIn;
  //var user = await FirebaseAuth.instance.getUser();

  if(logado == true){
    try{
      String? email = prefs.getString('Email');
      String? Senha = prefs.getString('Senha');

      var auth = FirebaseAuth.instance;
      await auth.signIn(email!, Senha!).whenComplete(() {

        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context){
              return mainList();
            }));
      });
    }catch(e){

      CherryToast.error(

          title: Text(
            "Ocorreu um erro: $e",
            style: const TextStyle(
                color: Colors.black
            ),
          ),

          displayTitle:  false,

          description: Text(
            "Ocorreu um erro: $e, desinstale e instale o app!",
            style: TextStyle(
                color: Colors.black
            ),
          ),

          animationDuration:  const Duration(milliseconds:  1000),

          autoDismiss:  true

      ).show(context);

    }


  }else{
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context){
          return loginScreen();
        }));
  }
}

class mainClass extends StatefulWidget {
  const mainClass({Key? key}) : super(key: key);

  @override
  State<mainClass> createState() => _mainClassState();
}

class _mainClassState extends State<mainClass> {
  @override
  Widget build(BuildContext context) {

    appPrepare(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text('Preparando...'),
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}

