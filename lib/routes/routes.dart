//Aqui vamos a difinir todaslas rutas quetendra mi aplicacion


import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/loading_page.dart';
import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/register_page.dart';
import 'package:chat/pages/usuarios_page.dart';
import 'package:flutter/cupertino.dart';

final Map<String, Widget Function( BuildContext )>appRoutes = {

  'usuarios': (_) => UsuariosPage() , 
  'chat'    : (_) => ChatPage()     ,
  'login'   : (_) => LoginPage()    ,
  // 'register' : (_) => RegisterPage() ,
  'register' : (_) {
    PageRouteBuilder( //En ves de usar el MaterialPage usamos este, que tiene animaciones
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => RegisterPage(),
      transitionDuration: Duration( seconds: 2 ), //El tiempo a demorar la animacion
      transitionsBuilder: (  context, animation , secondaryAnimation, child){
        
        final curvedAnimation = CurvedAnimation( parent: animation, curve: Curves.easeOut); //Escogemos la animacion
        
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(0.0, 1.0) ,end: Offset.zero).animate(curvedAnimation) , //Indicamos de donde a donde ira la transicion
          child: child,
        );
      }
     );
  },
  'loading' : (_) => LoadingPage()

};