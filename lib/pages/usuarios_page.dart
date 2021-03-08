import 'package:chat/models/usaurio.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class UsuariosPage extends StatefulWidget { //Lo convertimos a statefullwidget para manejar los estados, ya que vamos a revibir despues datos del backend

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  RefreshController _refreshController =  RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario( uid: '1', nombre: 'Maria', email: 'maria@gmail.com', online: true ),
    Usuario( uid: '2', nombre: 'Diego', email: 'diego@gmail.com', online: false ),
    Usuario( uid: '3', nombre: 'Fernando', email: 'fernando@gmail.com', online: true ) 
  ];
  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context); 
  	final usuario = authService.usuario;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text( usuario.nombre , style: TextStyle( color: Colors.black87 )),
        centerTitle: true,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black87,), 
          onPressed: (){
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
          }
        ) ,
        actions: [
            Container(
              margin: EdgeInsets.only(right: 10.0) ,
              child: Icon(Icons.check_circle, color: Colors.blue[400],),
              // child: Icon(Icons.offline_bolt, color: Colors.blue[400],),
            )
        ],
      ),
      body: SmartRefresher( //Este widget me permite dar el desliz hacia abajo para cargar nuevamente los datos. gracias a la libreria flutter_pulltorefresh y tenemos que comentar una linea de codigo
        controller: _refreshController, 
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon( Icons.check, color: Colors.blue[400] ),
          waterDropColor: Colors.blue[400],
        ), 
        child: _listViewUsuarios(),
      ) 
      
   );
  }

  ListView _listViewUsuarios() {
    return ListView.separated( //Genera una lista y tiene un separador donde podemos almacenar cosas
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioListTile( usuarios[i] ), 
      separatorBuilder: ( _ , i) => Divider(), 
      itemCount: usuarios.length
    );
  }

  ListTile _usuarioListTile( Usuario usuario ) {
    return ListTile(
        title: Text(usuario.nombre),
        leading: CircleAvatar(
          child: Text(usuario.nombre.substring(0,2)),
          backgroundColor: Colors.blue[100], //Coloca el fondo mas blanco y las letras mas oscuras
        ),
        trailing: Container(
          height: 10.0,
          width: 10.0,
          decoration: BoxDecoration(
            color: ( usuario.online ) ? Colors.green : Colors.red,
            borderRadius:  BorderRadius.circular(100.0)
          ),
        ),
      );
  }

  void _cargarUsuarios() async {
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}