import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/boton_azul.dart';
import 'package:flutter/material.dart';

import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatelessWidget {
//Esta pagina verificara si la cuenta esta autenticada para enviarle a una pagina distinta dependiendo el caso.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea( //Permite pintar loswidgets fuera de esosheader del dispositivo, aveces tapa
        child: SingleChildScrollView( //Para evitar que nos salga errores de que falta espacio
          physics: BouncingScrollPhysics(), //Rebota al llegar a un limite
          child: Container( //Lo encerramos dentro de un container para que el column no se estire en todo el scrollview, realmente no se va estirar al contrario se encoje
            height: MediaQuery.of(context).size.height * 0.9, //Tomamos el anchodel dispositivo ytomamos el 90%
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo( titulo: 'Messenger' ), //Si el widget o parte del diseño no cambia, es preferible encerrarlo en un  statelessWidget
                _Form(),
                Labels(ruta: 'register', titulo: '¿ No tienes cuenta ?', subtitulo: 'Crea una ahora',),
                Text('Terminos y condiciones de uso', style: TextStyle( fontWeight: FontWeight.w300 ))
              ],
            ),
          ),
        ),
      ),
   );
  }
}




class _Form extends StatefulWidget {
  
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>( context ); //Colocariamos el listen en false porque no vamos aredibujar nada, solo hacer un peticion
    final socketService = Provider.of<SocketService>( context ); //Colocariamos el listen en false porque no vamos aredibujar nada, solo hacer un peticion
                    

    return Container(//Siempre el container
       margin: EdgeInsets.only( top: 40.0),
       padding: EdgeInsets.symmetric(horizontal: 50.0) ,
       child: Column(
         children: [ 
          CustomInput(
            icon: Icons.mail_outline, 
            placeHolder: 'Correo',
            textController: emailCtrl, 
          ), 
          CustomInput(
            icon: Icons.lock_outline, 
            placeHolder: 'Contraseña',
            textController: passCtrl, 
            isPassword: true,
          ), 
          BotonAzul(
            texto: 'Ingresar',
            onPressed: authService.autenticando ? null : () async { //Colocamose n async porque nuestro future esta retornando un valor, caso contrario lo dejariamos sin async
                    
                    FocusScope.of(context).unfocus(); //Esto desaparece el foco principal, ejemplo, el foco principal era mi teclado del cell y cone l metodo lo quito
                    
                    final loginOk = await authService.login(emailCtrl.text.trim(), passCtrl.text.trim());

                    if (loginOk) {
                        socketService.connect(); //Se ejecuta la conecion al socket server 
                        //Navegar a otra pantalla
                        Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      //Mostrar alerta
                      mostrarAlerta(context, 'Login incorrecto', 'Revise sus credenciales');
                    }
            },
          )//Crea un boton rectangular      
         ],
       )
    );
  }
}

