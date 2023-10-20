import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../routes.dart';

class CustomNotification {
  final int id;
  final String? title; //* título que aparecerá na notificação
  final String? body; //* mensagem a ser exibida
  final String?
      payload; //* rota que será acessada quando usuário clicar na notificação
  final RemoteMessage? remoteMessage;

  CustomNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
    this.remoteMessage,
  });
}

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;

  //* Detalhes de notificação para cada plataforma
  //* consultar documentação do package "flutter_local_notifications" para as outras plataformas
  late AndroidNotificationDetails androidDetails;

  NotificationService() {
    //* instância para acessar os dados locais do sistema Android
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();

    //* auxilia a fazer todo setup inicial das notificações
    _setupNotifications();
  }
  // _setupAndroidDetails() {
  //   androidDetails = const AndroidNotificationDetails(
  //     'lembretes_notifications_details',
  //     'Lembretes',
  //     channelDescription: 'Este canal é para lembretes!',
  //     importance: Importance.max,
  //     priority: Priority.max,
  //     enableVibration: true,
  //   );
  // }

  _setupNotifications() async {
    await _setupTimezone();
    await _initializeNotifications();
  }

  Future<void> _setupTimezone() async {
    tz.initializeTimeZones();
    //* pega o timeZone do sistema operacional que tá setado
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    //* setar corretamente a location, baseada no time zone
    //* para garantir que as notificações agendadas sejam feitas no horário correto
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  //* configuração de cada sistema operacional
  _initializeNotifications() async {
    //* ícone exibido nas notificações, padrão do app
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    //* Fazer: macOs, iOS, Linux...
    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: android,
      ),
      onSelectNotification: _onSelectNotification,
    );
  }

  _onSelectNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Navigator.of(Routes.navigatorKey!.currentContext!).pushNamed(payload);
    }
  }

  showNotification(CustomNotification notification) {
    final date = DateTime.now().add(const Duration(seconds: 5));

    //* ISSO É SOMENTE A CONFIGURAÇÃO, NÃO É A INFORMAÇÃO QUE SERÁ EXIBIDA
    androidDetails = const AndroidNotificationDetails(
      //* Chanel ID deve ser único
      'Lembretes_notifications_X',

      //* Título
      'Lembretes',

      //* Descrição do que está sendo feito
      channelDescription: 'Este canal é para lembretes',

      //? Propriedades opcionais
      //* Como a notificação irá aparecer no topo do app PopUp
      importance: Importance.max,

      //* Tem a prioridade da notificação (Se será exibida em cima de outra)
      priority: Priority.max,

      //* Habilita vibração ao receber a notificação
      enableVibration: true,
    );

    //* Acessar o plugin e chamar o método 'show' para mostrar essas notificações
    //? para usar o dateTime, é necessário mudar para zoneSchedule
    localNotificationsPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      //* Configurações do sistemas operacionais
      NotificationDetails(
        android: androidDetails,
      ),
      //* necessário para exibir a informação depois
      payload: notification.payload,
    );

    // localNotificationsPlugin.zonedSchedule(
    //   notification.id,
    //   notification.title,
    //   notification.body,
    //   tz.TZDateTime.from(date, tz.local),
    //   NotificationDetails(
    //     android: androidDetails,
    //   ),
    //   payload: notification.payload,
    //   //* permite que a notificação seja exibida, mesmo com o app em segundo plano
    //   androidAllowWhileIdle: true,
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    // );
  }

  //? Recupera a instância, se fizer uma notificação agendada e app for fechado pelo usuário,
  checkForNotifications() async {
    //* captura os detalhes e verifica se existe uma notificação quando o app abrir
    //* isso é capturado via => localNotificationsPlugin
    final details =
        await localNotificationsPlugin.getNotificationAppLaunchDetails();

    //* se os detalhes forem diferentes de null e se tiver notificações ao abrir o app
    if (details != null && details.didNotificationLaunchApp) {
      //* o método _onSelectNotification será chamado para passar o payload
      //* caso contrário, o app será aberto apenas na tela inicial
      _onSelectNotification(details.payload);
    }
  }

  showNotificationScheduled(
      CustomNotification notification, Duration duration) {
    final date = DateTime.now().add(duration);

    localNotificationsPlugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      tz.TZDateTime.from(date, tz.local),
      NotificationDetails(
        android: androidDetails,
      ),
      payload: notification.payload,
      //* permite que a notificação seja exibida, mesmo com o app em segundo plano
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  showLocalNotification(CustomNotification notification) {
    localNotificationsPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      NotificationDetails(
        android: androidDetails,
      ),
      payload: notification.payload,
    );
  }

  // checkForNotifications() async {
  //   final details =
  //       await localNotificationsPlugin.getNotificationAppLaunchDetails();
  //   if (details != null && details.didNotificationLaunchApp) {
  //     _onSelectNotification(details.payload);
  //   }
  // }
}
