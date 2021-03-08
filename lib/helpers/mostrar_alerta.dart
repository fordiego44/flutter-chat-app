import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


mostrarAlerta( BuildContext context, String titulo, String subtitulo ){

    if ( Platform.isAndroid ) { //Si estamos en un Android
        return showDialog(
                  context: context,
                  builder: ( _ ) => AlertDialog(
                      title: Text(titulo),
                      content: Text(subtitulo),
                      actions: <Widget>[
                        MaterialButton(
                          child: Text('Ok'),
                          elevation: 5.0,
                          textColor: Colors.blue,
                          onPressed: () => Navigator.pop(context)
                        )
                      ],
                  )
                );
    }

    showCupertinoDialog(
      context: context, 
      builder: ( _ ) => CupertinoAlertDialog(
        actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () => Navigator.pop(context),
            )
        ],
      )
    );

}