import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:minhasanotacoesextended/WindowsAds.dart';
import 'package:minhasanotacoesextended/mainList.dart';
import 'package:minhasanotacoesextended/mobileAds.dart';
import 'package:minhasanotacoesextended/prepareMainList.dart';
import 'package:uuid/uuid.dart';

class CriarAnotacaoouEditar extends StatefulWidget {
  const CriarAnotacaoouEditar({Key? key}) : super(key: key);

  @override
  State<CriarAnotacaoouEditar> createState() => _CriarAnotacaoouEditarState();
}

class _CriarAnotacaoouEditarState extends State<CriarAnotacaoouEditar> {
  String mensage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Anotação'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
              Center(
                child:
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    minLines: 37,
                    maxLines: null,
                    onChanged: (value){
                      mensage = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Anotação',
                      hintStyle: TextStyle(
                          fontSize: 16
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                height: 200,
                width: double.infinity,
                child: kIsWeb == true? Container() : Platform.isWindows == true ? const WindowsAd(): const mobileAds(),
              ),
              WillPopScope(
                onWillPop: () async {

                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context){
                        return const mainList();
                      }));

                  return false;
                }, child: const Text(''),
              ),
            ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          if(mensage == ''){
            CherryToast.error(

                title:  Text(
                    "Preencha a anotação!",
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),

                displayTitle:  false,

                description:  Text(
                    "Preencha a anotação!",
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),

                animationDuration:  Duration(milliseconds:  1000),

                autoDismiss:  true

            ).show(context);
          }else{

            String dateTime = DateFormat('MM-dd-yyyy HH:mm:ss').format(DateTime.now()).replaceAll('-', '/');

            var uuid = const Uuid();

            String idd = "${DateTime.now().toString()}${uuid.v4()}";

            var auth = FirebaseAuth.instance;

            CollectionReference UserReference = Firestore.instance.collection('anotacoes');
            UserReference.document(idd).set({
              'id': idd,
              'idPertence': auth.userId,
              'mensage' : mensage,
              'horaPostada': dateTime,
            }).whenComplete((){

              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context){
                    return const mainList();
                  }));
            });
          }
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
