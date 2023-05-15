import 'package:cherry_toast/cherry_toast.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:minhasanotacoesextended/mainList.dart';
import 'package:uuid/uuid.dart';

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
