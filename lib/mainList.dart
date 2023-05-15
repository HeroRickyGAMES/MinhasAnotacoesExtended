
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:minhasanotacoesextended/criarAnota%C3%A7%C3%A3o.dart';
import 'package:minhasanotacoesextended/editaranotacao.dart';
import 'package:open_url/open_url.dart';
import 'package:package_info_plus/package_info_plus.dart';

class mainList extends StatefulWidget {
  const mainList({Key? key}) : super(key: key);

  @override
  State<mainList> createState() => _mainListState();
}
CollectionReference UserReference = Firestore.instance.collection('anotacoes');

Future<List<Document>> getAnotacoes() async {

  var auth = FirebaseAuth.instance;

  List<Document> mensages = await UserReference.where('idPertence', isEqualTo: auth.userId).get();

  return mensages;
}

class _mainListState extends State<mainList> {
  verificarVersao() async {
    var ref = Firestore.instance.collection('Server').document('serverValues');

    var document = await ref.get();
    print('snapshot: ${document['versao']}');
    final info = await PackageInfo.fromPlatform();

    if(int.parse(info.version.replaceAll(".", '')) == int.parse((document['versao']).replaceAll(".", ''))){
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Nova Atualização!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('O app acabou de lançar uma nova atualização!\nSua versão é a ${info.version}, mas a ultima é ${document['versao']}'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Baixar'),
                onPressed: () async {

                  final result = await openUrl('https://github.com/renatoathaydes/open_url');
                  if (result.exitCode == 0) {
                    print('URL should be open in your browser');
                  } else {
                    print('Something went wrong (exit code = ${result.exitCode}): '
                        '${result.stderr}');
                  }

                },
              ),
            ],
          );
        },
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    verificarVersao();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text('Minhas Anotações'),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(16),
            child: const listaCloseeDesclose()
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context){
                return const CriarAnotacaoouEditar();
              }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
class listaCloseeDesclose extends StatefulWidget {
  const listaCloseeDesclose({Key? key}) : super(key: key);

  @override
  State<listaCloseeDesclose> createState() => _listaCloseeDescloseState();
}

class _listaCloseeDescloseState extends State<listaCloseeDesclose> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<Document>>(
          future: getAnotacoes(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Document>> snapshot) {
            return snapshot.data!.isEmpty
                ? const Center(child: Text('A lista está vazia!'))
                : SizedBox(
              width: double.infinity,
              height: 600,
              child: ListView(
                children: snapshot.data!.map((documento) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(documento['mensage'],
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(documento['horaPostada'],
                                style: const TextStyle(
                                  fontSize: 12,
                                )),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: ElevatedButton(onPressed: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context){
                                  return editarAnotacao(documento['id'], documento['mensage']);
                                }));
                          }, child: const Icon(Icons.edit)
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: ElevatedButton(onPressed: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Deseja excluir essa anotação?'),
                                  content: const SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text('Após essa ação os dados escritos dentro dessa anotação deixarão de existir e não terá voltas!'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancelar'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Deletar anotação'),
                                      onPressed: () {
                                        UserReference.document(documento.id).delete().then((value){
                                          setState(() {
                                            const listaCloseeDesclose();
                                          });
                                          Navigator.of(context).pop();
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }, child: const Icon(Icons.delete)
                          ),
                        )
                      ],
                    ),
                  );
                }).toList().reversed.toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}