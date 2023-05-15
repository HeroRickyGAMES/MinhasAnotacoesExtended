
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:minhasanotacoesextended/LoginScreen.dart';
import 'package:minhasanotacoesextended/prepareMainList.dart';

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
  await Future.delayed(Duration(seconds: 2));
  FirebaseAuth.initialize('AIzaSyBPeA_jhjE5Nj5VyW-kRQ9qYn6i4g2jlWs', VolatileStore());
  Firestore.initialize("minhasanotacoesext-flutter");

  bool user = FirebaseAuth.instance.isSignedIn;
  //var user = await FirebaseAuth.instance.getUser();

  if(user == true){
    //ir para a mainScreen
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context){
          return prepareAc();
        }));

  }else if(user == false){
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

