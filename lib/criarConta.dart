import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:minhasanotacoesextended/WindowsAds.dart';
import 'package:minhasanotacoesextended/mainList.dart';
import 'package:minhasanotacoesextended/mobileAds.dart';
import 'package:shared_preferences/shared_preferences.dart';

class criarConta extends StatefulWidget {
  const criarConta({Key? key}) : super(key: key);

  @override
  State<criarConta> createState() => _criarContaState();
}

class _criarContaState extends State<criarConta> {
  String nome = '';
  String Email = '';
  String Senha = '';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  irParaTelaMain(){
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context){
          return mainList();
        }));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Criar uma nova conta'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                keyboardType: TextInputType.visiblePassword,
                enableSuggestions: false,
                autocorrect: false,
                onChanged: (value){
                  setState(() {
                    nome = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Seu nome',
                  hintStyle: TextStyle(
                      fontSize: 16
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                keyboardType: TextInputType.visiblePassword,
                enableSuggestions: false,
                autocorrect: false,
                onChanged: (value){
                  setState(() {
                    Email = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Seu Email',
                  hintStyle: TextStyle(
                      fontSize: 16
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                keyboardType: TextInputType.visiblePassword,
                enableSuggestions: false,
                autocorrect: false,
                obscureText: true,
                onChanged: (value){
                  setState(() {
                    Senha = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Sua Senha',
                  hintStyle: TextStyle(
                      fontSize: 16
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(onPressed: () async {
              if(nome == ''){
                CherryToast.error(

                    title:  Text(
                        "Preencha o seu nome!",
                      style: TextStyle(
                        color: Colors.black
                      ),
                    ),

                    displayTitle:  false,

                    description:  Text(
                        "Preencha o seu nome!",
                      style: TextStyle(
                          color: Colors.black
                      ),
                    ),

                    animationDuration:  Duration(milliseconds:  1000),

                    autoDismiss:  true

                ).show(context);
              }else{
                if(Email == ''){
                  CherryToast.error(

                      title:  Text(
                          "Preencha seu email!",
                        style: TextStyle(
                            color: Colors.black
                        ),
                      ),

                      displayTitle:  false,

                      description:  Text(
                          "Preencha seu email!",
                        style: TextStyle(
                            color: Colors.black
                        ),
                      ),

                      animationDuration:  Duration(milliseconds:  1000),

                      autoDismiss:  true

                  ).show(context);
                }else{
                  if(Senha == ''){
                    CherryToast.error(

                        title:  Text(
                            "Preencha sua senha!",
                          style: TextStyle(
                              color: Colors.black
                          ),
                        ),

                        displayTitle:  false,

                        description:  Text(
                            "Preencha sua senha!",
                          style: TextStyle(
                              color: Colors.black
                          ),
                        ),

                        animationDuration:  Duration(milliseconds:  1000),

                        autoDismiss:  true

                    ).show(context);
                  }else{


                    var auth = FirebaseAuth.instance;

                    await auth.signUp(Email, Senha);

                    try{
                      CollectionReference UserReference = Firestore.instance.collection('Users');

                      UserReference.document(auth.userId).set({
                        'uid': auth.userId,
                        'Nome' : nome,
                        'Email': Email,
                      }).whenComplete(() async {
                        final SharedPreferences prefs = await _prefs;

                        prefs.setString("Email", Email);
                        prefs.setString("Senha", Senha);
                        prefs.setBool("logado", true);

                        irParaTelaMain();
                        //go to mainScreen
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
                  }
                }
              }
            },
                child: const Text('Criar uma conta.')
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            height: 200,
            width: double.infinity,
            child: Platform.isWindows == true ? WindowsAd(): mobileAds(),
          ),
        ],
      ),
    );
  }
}
