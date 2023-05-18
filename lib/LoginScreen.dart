import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:minhasanotacoesextended/WindowsAds.dart';
import 'package:minhasanotacoesextended/criarConta.dart';
import 'package:minhasanotacoesextended/mainList.dart';
import 'package:minhasanotacoesextended/mobileAds.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  String Email = '';
  String Senha = '';
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    //FirebaseAuth.initialize('AIzaSyBPeA_jhjE5Nj5VyW-kRQ9qYn6i4g2jlWs', VolatileStore());
    //Firestore.initialize("minhasanotacoesext-flutter");

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    irParaTelaMain(){
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context){
            return const mainList();
          }));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                enableSuggestions: false,
                autocorrect: false,
                onChanged: (value){
                  setState(() {
                    Email = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
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
                  hintText: 'Senha',
                  hintStyle: TextStyle(
                      fontSize: 16
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(onPressed: () async {

              if(Email == ''){
                CherryToast.error(

                    title:  const Text(
                        "Preencha seu email!",
                      style: TextStyle(
                          color: Colors.black
                      ),
                    ),

                    displayTitle:  false,

                    description:  const Text(
                        "Preencha seu email!",
                      style: TextStyle(
                          color: Colors.black
                      ),
                    ),

                    animationDuration:  const Duration(milliseconds:  1000),

                    autoDismiss:  true

                ).show(context);

              }else{
                if(Senha == ''){
                  CherryToast.error(

                      title:  const Text(
                          "Preencha sua senha!",
                        style: TextStyle(
                            color: Colors.black
                        ),
                      ),

                      displayTitle:  false,

                      description:  const Text(
                          "Preencha sua senha!",
                        style: TextStyle(
                            color: Colors.black
                        ),
                      ),

                      animationDuration:  const Duration(milliseconds:  1000),

                      autoDismiss:  true

                  ).show(context);

                }else{
                  var auth = FirebaseAuth.instance;

                  try{
                    await auth.signIn(Email, Senha).then((value) async {

                      final SharedPreferences prefs = await _prefs;

                      prefs.setString("Email", Email);
                      prefs.setString("Senha", Senha);
                      prefs.setBool("logado", true);


                      irParaTelaMain();


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
                          "Ocorreu um erro: $e",
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
            },
                child: const Text('Logar')
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Você ainda não não tem uma conta? '
                  ),
                  TextButton(onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context){
                          return const criarConta();
                        }));
                  }, child: const Text('Crie uma conta agora!')
                  ),
                ],
              )
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(onPressed: (){

                      if(Email == ''){
                        CherryToast.error(

                            title:  const Text(
                              "Preencha o seu email!",
                              style: TextStyle(
                                  color: Colors.black
                              ),
                            ),

                            displayTitle:  false,

                            description:  const Text(
                              "Preencha o seu email!",
                              style: TextStyle(
                                  color: Colors.black
                              ),
                            ),

                            animationDuration:  const Duration(milliseconds:  1000),

                            autoDismiss:  true

                        ).show(context);
                      }else{
                        var auth = FirebaseAuth.instance;

                        auth.resetPassword(Email).then((value){
                          CherryToast.error(

                              title:  const Text(
                                "Email de recuperação enviado para seu email!",
                                style: TextStyle(
                                    color: Colors.black
                                ),
                              ),

                              displayTitle:  false,

                              description:  const Text(
                                "Email de recuperação enviado para seu email!",
                                style: TextStyle(
                                    color: Colors.black
                                ),
                              ),

                              animationDuration:  const Duration(milliseconds:  1000),

                              autoDismiss:  true

                          ).show(context);
                        });
                      }

                    }, child: const Text('Esqueceu sua Senha?')
                    ),
                  ],
                )
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            height: 200,
            width: double.infinity,
            child: Platform.isWindows == true ? const WindowsAd(): const mobileAds(),
          ),
        ],
      ),
    );
  }
}
