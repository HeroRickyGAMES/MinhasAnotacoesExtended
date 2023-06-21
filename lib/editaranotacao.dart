import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minhasanotacoesextended/WindowsAds.dart';
import 'package:minhasanotacoesextended/mainList.dart';
import 'package:minhasanotacoesextended/mobileAds.dart';

class editarAnotacao extends StatefulWidget {
  String id;
  String anotacao;
  editarAnotacao(this.id, this.anotacao, {Key? key}) : super(key: key);

  @override
  State<editarAnotacao> createState() => _editarAnotacaoState();
}

class _editarAnotacaoState extends State<editarAnotacao> {
  @override
  Widget build(BuildContext context) {
    String mensage = widget.anotacao;

    final anotacaoControl = TextEditingController(text: widget.anotacao);

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
                  enableSuggestions: true,
                  autocorrect: true,
                  controller: anotacaoControl,
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

                title:  const Text(
                  "Preencha a anotação!",
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),

                displayTitle:  false,

                description:  const Text(
                  "Preencha a anotação!",
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),

                animationDuration:  const Duration(milliseconds:  1000),

                autoDismiss:  true

            ).show(context);
          }else{

            String dateTime = DateFormat('MM-dd-yyyy HH:mm:ss').format(DateTime.now()).replaceAll('-', '/');

            CollectionReference UserReference = Firestore.instance.collection('anotacoes');

            UserReference.document(widget.id).update({
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
