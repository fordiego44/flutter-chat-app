import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
   
   final String texto;
   final Function onPressed;

  const BotonAzul({
    Key key, 
    @required this.texto, 
    @required this.onPressed,  
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
            elevation: 2, //El boton se eleva y da como unasombra
            highlightElevation: 5,
            color: Colors.blue,
            shape: StadiumBorder(), //Le da bordes redondeados
            onPressed: this.onPressed,
            child:Container(
              width: double.infinity,
              height: 55.0,
              child: Center(
                child: Text(this.texto, style: TextStyle( color: Colors.white, fontSize: 17.0 ),)),
            ) , 
          )  
    );
  }
}