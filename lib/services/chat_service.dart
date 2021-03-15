import 'package:chat/global/environment.dart';
import 'package:chat/models/usaurio.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/mensajes_response.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {

  Usuario usuarioPara   ;

  Future<List<Mensaje>> getChat( usuarioID ) async {
    
      final response = await http.get('${ Environment.apiUrl}/mensajes/$usuarioID',
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        });

        final mensajesResp = mensajesResponseFromJson(response.body);

        return mensajesResp.mensajes;
  }
}