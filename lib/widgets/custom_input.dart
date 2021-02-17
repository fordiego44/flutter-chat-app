import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  
  final IconData icon;
  final String placeHolder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;

  const CustomInput({
      Key key, //ocupamos la referencia al mismo pero - no lo usamos siempre 
      @required this.icon, 
      @required this.placeHolder, 
      @required this.textController, 
      this.keyboardType = TextInputType.text, 
      this.isPassword = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
            margin: EdgeInsets.only( bottom: 20.0 ) ,
            padding: EdgeInsets.only( top:5.0, left: 5.0, bottom: 5.0, right: 20.0 ) ,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: <BoxShadow>[
                  BoxShadow( //Estilo de sombra
                    color: Colors.black.withOpacity(0.05),
                    offset: Offset(0.0, 5.0), //Cambia la posicion del boxshadow
                    blurRadius: 5.0 // Expande la sombra, lo difumina
                  )
              ]
            ),
            child:TextField(
              controller: this.textController,
              autocorrect: false, //No me corregira lo que escriba
              keyboardType: this.keyboardType, //Indicamos que el contenido es de tipo email, nos aparecera el arroba
              obscureText: this.isPassword,
              decoration: InputDecoration(
                prefixIcon: Icon(this.icon),
                focusedBorder: InputBorder.none, //Borra el borde del inputal escribir
                border: InputBorder.none, //Borra la rayita que sale cuando escribimos
                hintText: this.placeHolder
              ) ,
            ), //Crea un widget input ,
          );
  }
}