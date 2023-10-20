import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/notification_service_old.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool valor = false;
  showNotification() {
    setState(() {
      valor = !valor;
      if (valor) {
        //* como só irá exibir a notificação, usa-se listen = false, pois não está esperando modificações
        //* provider acessa o showNotification para passar os detalhes da modificação
        Provider.of<NotificationService>(context, listen: false)
            .showNotification(
          CustomNotification(
            id: 1,
            title: 'Teste Local Notification',
            body: 'Vai para a página',
            //* no payload se passa a rota nomeada
            payload: '/notificacao',
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2895DE),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            child: ListTile(
              title: const Text('Testar Push Notification Local'),
              trailing: valor
                  ? const Icon(Icons.check_box, color: Color(0xFF2895DE))
                  : const Icon(Icons.check_box_outline_blank),
              onTap: showNotification,
            ),
          ),
        ),
      ),
    );
  }
}
