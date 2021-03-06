import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';

import 'package:chat/routes/routes.dart';
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) =>  AuthService()), //De esta manera gloabalizamos nuestra instancia gracias al provider
        ChangeNotifierProvider(create: (BuildContext context) =>  SocketService()), //De esta manera gloabalizamos nuestra instancia gracias al provider
        ChangeNotifierProvider(create: (BuildContext context) =>  ChatService()) //De esta manera gloabalizamos nuestra instancia gracias al provider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}