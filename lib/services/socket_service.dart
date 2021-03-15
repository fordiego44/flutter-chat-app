//Podria ser la carptea llamada provider o services

import 'package:chat/global/environment.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO; 

enum ServerStatus {
  Online,
  Offline, //Cuando se desconecta, o por si se cae
  Connecting //Cuando se conecta por primera vez,cunado inicia
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;  //Cuando cree la instnacia no sabre si estoy offline o en online, pero si estare tratando de conectarme
  IO.Socket _socket; // Para poder emitir desde flutter al servidor, extraemos esta variable para poder controlarla y exponerla fuera de esta clase, esta propiedad privada reemplazara la parte de inicializaciones de initConfig

  ServerStatus get serverStatus => this._serverStatus; //Para obtener la propiedad privada
  
  IO.Socket get socket => this._socket;

  Function get emit => this._socket.emit; //Para tener un codigo mas limpio podriamos colocar aqui el emit y solo llamar al getter de emit con los parametros requeridos, automaticamente son llevados aqui
  

  // SocketService(){ //No lousaremos porque esto activara la conexion al instanciarlo
  //   this.initConfig(); //Para no cargar mucho el controlador, voy a llamar esta funcion 
  // }

  // void initConfig(){
  void connect() async {

    final token = await AuthService.getToken();  
    // this._socket = IO.io('http://192.168.0.20:3000/', {
    this._socket = IO.io(Environment.sockectUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true, //Lo colocamos para el inicio de sesion, nos forzara a realizar una nueva sesion 
      'extraHeaders':{ //Podemos enviar cualquier tipo de headers adicionales en este mapa
        'x-token':token //De esta maneraenviamos el token al socket server
      }
    });

    this._socket.on('connect', (_) { //Estamos esperando a recibirun mensaje emitido por el servidor llamado conect
      this._serverStatus = ServerStatus.Online; //Cambiamos de numeracion
      notifyListeners(); 
    });

    this._socket.on('disconnect', (_) { //Es unlistener cuando se desconecta
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
 
    this._socket.on('nuevo-mensaje', ( payload ) { //Creamos unlistener personalizable, el payploaf es un callback que se va ejecutar cuando recibamos el emit del servidor llamado 'nuevo-mensaje' 
      // el paypload esta bien que sea dinamico, porquepodemosrecibir cualquier tipo de datos, mapa, String, entenros etc.
      print('Nuevo-mensaje: $payload'); //Si hemos creado un nuevo listener, tenemos que hacer un hot restart, para poder activar el listener
      print('nombre: ' +  payload['nombre']);
      print('mensaje: '+ payload['mensaje']);
      print( payload.containsKey('mensaje2') ? payload['mensaje2'] : 'No hay'); //Estructura de mapa (clave:valor), en caso no exista la clave, colocariamos otro mensaje
    });
  }

  void disconnect(){
    this._socket.disconnect();
  }
}