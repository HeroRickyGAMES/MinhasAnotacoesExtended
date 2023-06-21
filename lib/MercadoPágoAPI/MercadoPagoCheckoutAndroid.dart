import 'dart:async';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';
import 'package:minhasanotacoesextended/mainList.dart';

//Desenvolvido por HeroRIckyGames

class ChekoutPayment extends StatefulWidget {
  String idCompra;
  String id;
  String PubKey;
  ChekoutPayment(this.idCompra,this.PubKey, this.id, {super.key});

  @override
  State<ChekoutPayment> createState() => _ChekoutPaymentState();
}

class _ChekoutPaymentState extends State<ChekoutPayment> {
  CollectionReference DonateCollection = Firestore.instance.collection('Donate');

  @override
  Widget build(BuildContext context) {
    String publicKey = widget.PubKey;
    String preferenceId = widget.idCompra;

    iniciarapi(context) async {


      PaymentResult result =
      await MercadoPagoMobileCheckout.startCheckout(
        publicKey,
        preferenceId,
      );
      print('resultado é ${result.result}');

      if(result.result == 'done'){
        //todo algo
        CherryToast.error(
            title:  const Text(
              "Pagamento realizado com sucesso!",
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

        print(widget.id);

        DonateCollection.document(widget.idCompra).set({
          'UIDCompra': widget.id,
          'idCompra': widget.idCompra,
          'Status': result.result,
          'Origin': 'Mobile (Android)',
        }).then((value) async {
          CherryToast.error(
              title:  const Text(
                "Pagamento realizado com sucesso!",
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
          CherryToast.error(
              title:  const Text(
                "Obrigado por colaborar com o desenvolvedor!",
                style: TextStyle(
                    color: Colors.black
                ),
              ),
              displayTitle:  false,
              description:  const Text(
                "Obrigado por colaborar com o desenvolvedor!",
                style: TextStyle(
                    color: Colors.black
                ),
              ),
              animationDuration:  const Duration(milliseconds:  1000),
              autoDismiss:  true
          ).show(context);
          await Future.delayed(const Duration(seconds: 5));
          Navigator.push(context,
              MaterialPageRoute(builder: (context){
                return const mainList();
              }));
        });
      }else{

        DonateCollection.document(widget.idCompra).set({
          'UIDCompra': widget.id,
          'idCompra': widget.idCompra,
          'Status': result.result,
          'Origin': 'Mobile (Android)',
        });

        CherryToast.error(
            title:  const Text(
              "Ocorreu algum erro no pagamento e ele foi cancelado, tente trocar de cartão ou tentar novamente",
              style: TextStyle(
                  color: Colors.black
              ),
            ),
            displayTitle:  false,
            description:  const Text(
              "Ocorreu algum erro no pagamento e ele foi cancelado, tente trocar de cartão ou tentar novamente",
              style: TextStyle(
                  color: Colors.black
              ),
            ),
            animationDuration:  const Duration(milliseconds:  1000),
            autoDismiss:  true
        ).show(context);

        await Future.delayed(const Duration(seconds: 5));
        Navigator.push(context,
            MaterialPageRoute(builder: (context){
              return const mainList();
            }));
      }
    }

    iniciarapi(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('PedeFacil Entregadores - Pagamento'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text('Aguarde um momento!')
              ),
              Container(
                padding: const EdgeInsets.all(16),
                  child: const CircularProgressIndicator()
              ),
            ],
          ),
        )
    );
  }
}