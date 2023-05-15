import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:minhasanotacoesextended/mainList.dart';

class prepareAc extends StatefulWidget {
  const prepareAc({Key? key}) : super(key: key);

  @override
  State<prepareAc> createState() => _prepareAcState();
}

class _prepareAcState extends State<prepareAc> {
  @override
  Widget build(BuildContext context) {

    FirebaseAuth.initialize('AIzaSyBPeA_jhjE5Nj5VyW-kRQ9qYn6i4g2jlWs', VolatileStore());
    Firestore.initialize("minhasanotacoesext-flutter");

    Navigator.push(context,
        MaterialPageRoute(builder: (context){
          return const mainList();
        }));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preparando login...'),
        centerTitle: true,
      ),
      body: const Column(
        children: [

        ],
      ),
    );
  }
}
