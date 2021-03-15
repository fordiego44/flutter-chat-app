import 'dart:io';
import 'package:chat/services/mensajes_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';

import 'package:chat/widgets/chat_message.dart';


class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin { //Lo convertimos a statefullwidget para mantener el stado

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

   ChatService chatService; 
   SocketService socketService;
   AuthService authService;

  final List<ChatMessage> _messages = [   ];

  bool _estaEscribiendo = false;

  @override
  void initState() { 
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false); //Los declaramos desde un inicio, para emitir el mensaje desde el socket
    this.authService = Provider.of<AuthService>(context, listen: false);
    
    this.socketService.socket.on('mensaje-personal', _escucharMensaje );
    

    _cargarhistorial( chatService.usuarioPara.uid );

    super.initState();
    
  }

  void _cargarhistorial( String usuarioID ) async {
      List<Mensaje> chat = await chatService.getChat(usuarioID); 
      
      final history = chat.map((m) => new ChatMessage(
        texto: m.mensaje,
        uid: m.de, 
        animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 0))..forward() //Con el 2puntos activaremos al instante la animacion
      ));

      setState(() {
        _messages.insertAll( 0, history );
      });
  }


  void _escucharMensaje( dynamic payload){ //Como es much codigo lo encerramos en una funcion aparte, de todos modos ahi pedia una funcion
    final message =  ChatMessage(
      texto: payload['mensaje'], 
      uid: payload['de'], 
      animationController: AnimationController(vsync: this, duration: Duration( milliseconds: 300 ) )
    );

    setState(() {
    _messages.insert( 0,message );
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {

    
    final usaurioPara =  chatService.usuarioPara;        
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(usaurioPara.nombre.substring(0,2), style: TextStyle( fontSize: 12.0 ),),
              backgroundColor: Colors.blue[100],
              maxRadius: 14.0,
            ),
            SizedBox(height: 3.0),
            Text(usaurioPara.nombre, style: TextStyle( color: Colors.black87, fontSize: 12.0 ),)
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[ 
              Flexible( //Permite al widget tomar todo el ancho, sin esto nos daria error
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: _messages.length,
                  itemBuilder: ( _ , i) => _messages[i], //Recorre cada widget
                  reverse: true
                ),
              ), 
            Divider( height: 1.0 ),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
   );
  }

  Widget _inputChat() {
    return SafeArea( //Para evitar que este debajo de partes inaccesibles de algunos dispositivos
      child: Container(
        margin: EdgeInsets.symmetric( horizontal: 8.0 ),
        child: Row(
          children: <Widget>[
            Flexible( //Es como el widget de Expanded
              child: TextField( //Widget de input de texto
                controller: _textController,
                onSubmitted: _handleSubmit, //Al hacer un enter, Mnadamos solo la referencia, es como lamisma funcion pero esta en otro lado
                onChanged: ( String texto ){

                    if ( texto.trim().length > 0 ) { //El trim devuelve una cadena sin espacios iniciales y finales 
                        setState(() {
                          _estaEscribiendo = true;
                        });
                    }  
                }, // Se iniciara al ver un cambio en el input, ejemplo: el ingreso de una nueva letra
                decoration: InputDecoration(
                  hintText: 'Enviar mensaje',
                ),
                focusNode: _focusNode, //Nos permitira controlar el foco, cuando demos al submit, el teclado suele desaparecer, con esto nospermitira mantener elteclado ahi.
              )
            ),
            Container(
              margin: EdgeInsets.symmetric( horizontal: 4.0 )  ,
              child: Platform.isIOS
                  ? CupertinoButton(
                    child: Text('Enviar'),
                    onPressed: _estaEscribiendo 
                          ? () => _handleSubmit( _textController.text ) //Si no queremos activar la funcion antes de dar el tap lo colocamos asi
                          : null,
                  )
                  : Container(
                    margin: EdgeInsets.symmetric( horizontal: 4.0 ),
                    child: IconTheme( //Lo colocamos para cambiar el color del boton del IconButton, es necesario si queremos deshabilitar el boton cuando este vacio el input
                      data: IconThemeData( color: Colors.blue[400] ) ,
                      child: IconButton(
                        highlightColor: Colors.white, //Para no ver esa sombra al hacer click en el boton
                        splashColor: Colors.white, //Para no ver esa sombra al hacer click en el boton
                        icon: Icon( Icons.send), 
                        onPressed: _estaEscribiendo 
                          ? () => _handleSubmit( _textController.text ) //Si no queremos activar la funcion antes de dar el tap lo colocamos asi
                          : null
                      ),
                    ),
                  ) ,
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmit( String texto ){ 
     if ( texto.length == 0 )   return;
      _textController.clear();
      _focusNode.requestFocus();

      final  newMessage = new ChatMessage(
        uid: authService.usuario.uid, 
        texto: texto, 
        animationController: AnimationController(
          vsync: this, //Proviene de la mezcla con el   TickerProviderStateMixin
          duration: Duration( milliseconds: 400 )
        )
      );
      _messages.insert(0, newMessage); //inserta el mensaje desde la posicion 0 de nuestra lista
      newMessage.animationController.forward(); //Accedo a los datos de mi message y empiezo a correr la animacion, no corre sola, se tiene que activar manualmente
      setState(() {
        _estaEscribiendo = false;
      });  
 
      this.socketService.emit('mensaje-personal', {
          'de': this.authService.usuario.uid,
          'para': this.chatService.usuarioPara.uid,
          'mensaje': texto
      });  
  }

  @override
  void dispose() {
    // TODO:  off del socket

    for (var message in _messages) {
        message.animationController.dispose(); //Cerramos todo antes de salir de este page
    }

    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }
  

}

