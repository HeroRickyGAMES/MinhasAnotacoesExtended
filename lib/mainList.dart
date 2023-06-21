import 'dart:convert';
import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minhasanotacoesextended/MercadoP%C3%A1goAPI/MercadoPagoCheckoutAndroid.dart';
import 'package:minhasanotacoesextended/WindowsAds.dart';
import 'package:minhasanotacoesextended/criarAnota%C3%A7%C3%A3o.dart';
import 'package:minhasanotacoesextended/editaranotacao.dart';
import 'package:minhasanotacoesextended/mobileAds.dart';
import 'package:open_url/open_url.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

//Programado por HeroRickyGames

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

  donate(int Valor, context) async {
    var ServerReference = Firestore.instance.collection('Server').document('serverValues');

    var document = await ServerReference.get();

    String ChavePublica = "${document['ChavePublica']}";
    String AccessToken = "${document['Access Token']}";

    final url = 'https://api.mercadopago.com/checkout/preferences';

    final body = jsonEncode({
      "items": [
        {
          "title": "Pagamento do Donate",
          "description": "Pagamento do Donate",
          "quantity": 1,
          "currency_id": "ARS",
          "unit_price": Valor
        }
      ],
      "back_urls": {
        "success": "https://herorickygames.github.io/MinhasAnotacoesExtended/sucess",
        "failure": "https://herorickygames.github.io/MinhasAnotacoesExtended/falha"
      },
      "payer": {
        "email": "payer@email.com"
      }
    });

    final response = await http.post(
      Uri.parse('$url?access_token=$AccessToken'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    if(response.statusCode == 200 || response.statusCode == 201){

      final preferenceId = jsonDecode(response.body)['id'];
      print('Preference created with ID: $preferenceId');

      var uuid = Uuid().v4();

      Navigator.push(context,
          MaterialPageRoute(builder: (context){
            return ChekoutPayment(preferenceId, ChavePublica, uuid);
          }));
    }else{
      CherryToast.error(
          title:  const Text(
            "Ocorreu um erro ao executar a API de pagamentos ou chamar a API do Mercado Pago, tente novamente!",
            style: TextStyle(
                color: Colors.black
            ),
          ),
          displayTitle:  false,
          description:  const Text(
            "Pagamento realizado com sucesso!",
            style: TextStyle(
                color: Colors.black
            ),
          ),
          animationDuration:  const Duration(milliseconds:  1000),
          autoDismiss:  true
      ).show(context);
    }
  }

  verificarVersao(context) async {
    var ref = Firestore.instance.collection('Server').document('serverValues');

    var document = await ref.get();
    final info = await PackageInfo.fromPlatform();

    if(int.parse(info.version.replaceAll(".", '')) < int.parse((document['versao']).replaceAll(".", ''))){
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

                  final result = await openUrl('https://github.com/HeroRickyGAMES/MinhasAnotacoesExtended/releases');
                  if (result.exitCode == 0) {
                    CherryToast.error(
                        title:  const Text(
                          "Abrindo no navegador...",
                          style: TextStyle(
                              color: Colors.black
                          ),
                        ),
                        displayTitle:  false,
                        description:  const Text(
                          "Abrindo no navegador...",
                          style: TextStyle(
                              color: Colors.black
                          ),
                        ),
                        animationDuration:  const Duration(milliseconds:  1000),
                        autoDismiss:  true
                    ).show(context);
                  } else {
                    CherryToast.error(
                        title:  const Text(
                          "Algo de errado aconteceu!",
                          style: TextStyle(
                              color: Colors.black
                          ),
                        ),
                        displayTitle:  false,
                        description:  const Text(
                          "Algo de errado aconteceu!",
                          style: TextStyle(
                              color: Colors.black
                          ),
                        ),
                        animationDuration:  const Duration(milliseconds:  1000),
                        autoDismiss:  true
                    ).show(context);
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
    verificarVersao(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text('Minhas Anotações'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(16),
                child: const listaCloseeDesclose()
            ),
            Container(
              padding: const EdgeInsets.all(16),
              height: 200,
              width: double.infinity,
              child: Platform.isWindows == true ? const WindowsAd(): const mobileAds(),
            ),
          ],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
          child: IconButton(
            icon: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 10),
                    child: const Icon(Icons.monetization_on)
                ),
                const Text('Doe para o Desenvolvimento do app!')
              ],
            ), onPressed: () {
              int valor = 0;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Faça um donate para o desenvolvedor do app',
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    content: Container(
                      width: 350,
                      height: 350,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Faça uma doação para o desenvolvedor!\nQualquer valor é valido!',
                            style: TextStyle(
                                fontSize: 19
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(16),
                            child:
                            TextFormField(
                              onChanged: (vaalor){
                                valor = int.parse(vaalor);
                                //Mudou mandou para a String
                              },
                              keyboardType: TextInputType.number,
                              obscureText: false,
                              //enableSuggestions: false,
                              //autocorrect: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Valor',
                                hintStyle: TextStyle(
                                    fontSize: 20
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(onPressed: (){

                        if(valor <= 0){
                          CherryToast.error(
                              title: Text(
                                "O valor não pode ser menor que R\$0.00!",
                                style: const TextStyle(
                                    color: Colors.black
                                ),
                              ),
                              displayTitle:  false,
                              description: Text(
                                "O valor não pode ser menor que R\$0.00!",
                                style: TextStyle(
                                    color: Colors.black
                                ),
                              ),
                              animationDuration:  const Duration(milliseconds:  1000),
                              autoDismiss:  true
                          ).show(context);
                        }else{
                          if(valor >= 1){

                            String certa = "${valor}".replaceAll(",", ".");

                            donate(int.parse(certa), context);
                            Navigator.pop(context);
                          }
                        }
                      }, child: Text(
                        'Ok',
                        style: TextStyle(
                            fontSize: 19
                        ),
                      )
                      )
                    ],
                  );
                },
              );
            },
          ),
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
                  height: 800,
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
                            SizedBox(
                              width: 300,
                              height: 50,
                              child: Center(
                                child: Text(documento['mensage'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
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
