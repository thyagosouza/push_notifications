import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes.dart';
import 'services/firebase__messaging_service.dart';
import 'services/notification_service.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    initializeFirebaseMessaging();
    //? Quando o app carregar, verificará se já existem notificações que o sistema enviou...
    //? os dados do payload, pra nossa aplicação
    checkNotifications();
  }

  //* esse metodo pode ser chamado no main.dart
  initializeFirebaseMessaging() async {
    //* listen: false => pois não está esperando atualizações desse provider
    await Provider.of<FirebaseMessagingService>(context, listen: false)
        .initialize();
  }

  checkNotifications() async {
    await Provider.of<NotificationService>(context, listen: false)
        .checkForNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: false,
      ),
      //onGenerateRoute: RouteGenerator.onGenerateRoute,
      routes: Routes.list,
      initialRoute: Routes.initial,
      navigatorKey: Routes.navigatorKey,
    );
  }
}
