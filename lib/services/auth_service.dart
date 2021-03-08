import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;  

import 'package:chat/global/environment.dart';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/usaurio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  
  Usuario usuario; 
  bool _autenticando = false; //No hacemos la operacion directamente, utilizamos getters and setters, para poder tambien notificara los demas de sus cambios

  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  set autenticando( bool valor ){
    this._autenticando = valor;
    notifyListeners();
  }

  //Getters del token de forma estatica
  static Future<String> getToken() async { //No podemos obtener las propiedades establecidas afuera de este metodo que es estatico
    final _storage = new FlutterSecureStorage(); //Por eso declaramos nuevamente esto
    final token = await _storage.read(key: 'token'); //Obtenemos los datos de la llave token, que seria el token en si
    return token;
  }
  //Obtenemos el token haciendo referencia a este provider authServices
  static Future<void> deleteToken() async { //No podemos obtener las propiedades establecidas afuera de este metodo que es estatico
    final _storage = new FlutterSecureStorage(); //Por eso declaramos nuevamente esto
    await _storage.delete(key: 'token'); 
  }

  Future<bool> isLoggedIn() async {
    final token =  await _storage.read(key: 'token');
    
    final resp = await http.get( '${Environment.apiUrl}/login/renew',
        headers: {
          'Content-Type': 'application/json',
          'x-token': token
        }
      );

      print(resp.body);

      if (resp.statusCode == 200) { //Si la peticion se realizo exitosamente
        final loginResponse = loginResponseFromJson(resp.body); //Lo transforma a una clase
        this.usuario = loginResponse.usuario; 
        //Guardar token en lugar seguro
        await this._guardarToken(loginResponse.token);
        return true;
      }else{

        this.logout();
        return false;
      }

  }

  Future<bool> login( String email, String password ) async {

      this.autenticando = true;


      final data = {
        'email': email,
        'password': password
      };
       final resp = await http.post( '${Environment.apiUrl}/login',
        body: jsonEncode(data), //Convertimos el objeto en formato json
        headers: {
          'Content-Type': 'application/json'
        }
      );

      print(resp.body);
      this.autenticando = false;

      if (resp.statusCode == 200) { //Si la peticion se realizo exitosamente
        final loginResponse = loginResponseFromJson(resp.body); //Lo transforma a una clase
        this.usuario = loginResponse.usuario;

        //Guardar token en lugar seguro
        await this._guardarToken(loginResponse.token);
        return true;
      }else{
        return false;
      }

  }

  Future<dynamic> register( String nombre,String email, String password ) async {

      // this.autenticando = true; 

      final data = {
        'nombre': nombre,
        'email': email,
        'password': password
      };
       final resp = await http.post( '${Environment.apiUrl}/login/new',
        body: jsonEncode(data), //Convertimos el objeto en formato json
        headers: {
          'Content-Type': 'application/json'
        }
      );

      print(resp.body);
      // this.autenticando = false;

      if (resp.statusCode == 200) { //Si la peticion se realizo exitosamente
        final loginResponse = loginResponseFromJson(resp.body); //Lo transforma a una clase
        this.usuario = loginResponse.usuario;

        //Guardar token en lugar seguro
        await this._guardarToken(loginResponse.token);
        return true;
      }else{
        final respBody =  jsonDecode(resp.body); //No podemos trabajar cone l json en bruto, tenemos que mapearlo
        return respBody['msg'];
      }

  }

  Future _guardarToken( String token ) async { //Guardamos eltoken con esta sentencia y hacemos un return

    return  await _storage.write(key: 'token', value: token); //La llave se llamara token para obtener el token
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }

}