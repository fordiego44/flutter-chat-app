import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {
  
  final String texto;
  final String uid;
  final AnimationController animationController;

  const ChatMessage({
    Key key, 
    @required this.texto, 
    @required this.uid, 
    @required this.animationController
  }) : super(key: key); //Si el uid es mio, entonces son mis textos, caso contrario no lo son

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context); 

    return FadeTransition( //Es una transiccion de opcidad
      opacity:  this.animationController, //Contendra el controlador del page que lo llama a este widget con la duracion y todo
      child: SizeTransition( //Permite manejar eltamaño del widget en transicion
        sizeFactor: CurvedAnimation(parent: this.animationController, curve: Curves.easeOut ),
        child: Container(
          child: ( this.uid == authService.usuario.uid )
            ? _myMessage()
            : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(
          right: 5.0,
          bottom: 5.0,
          left: 50.0
        ) ,
        padding: EdgeInsets.all(8.0),
        child: Text('${this.texto}', style: TextStyle( color: Colors.white )),
        decoration: BoxDecoration(
          color: Color(0xff4D9EF6),
          borderRadius: BorderRadius.circular(20.0)
        ),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          right: 50.0,
          bottom: 5.0,
          left: 5.0
        ) ,
        padding: EdgeInsets.all(8.0),
        child: Text('${this.texto}', style: TextStyle( color: Colors.black87 )),
        decoration: BoxDecoration(
          color: Color(0xffE4E5E8),
          borderRadius: BorderRadius.circular(20.0)
        ),
      ),
    );
  }
}