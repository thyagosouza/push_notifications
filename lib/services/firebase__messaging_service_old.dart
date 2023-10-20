import 'package:firebase_messaging/firebase_messaging.dart';

import '../routes.dart';
import 'notification_service_old.dart';

class FirebaseMessagingService {
  //* Para que essa classe funcione, ela precisa de um serviço de no
  final NotificationService _notificationService;

  FirebaseMessagingService(this._notificationService);

  //* método para inicializar toda configuração necessária do firebase...
  //* e chamar os métodos necessários por ouvir as mensagens que vão vir do servidor
  Future<void> initialize() async {
    //* inicialização da configuração de quando o app estiver aberto
    //* FirebaseMessaging.instance recupera a instância do FirebaseMessaging
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      //* Como a configuração vai aparecer se o app estiver aberto
      //* Exemplo: caso o usuário esteja usando o app na hora que for enviada a notificação via Firebase
      badge: true,
      alert: true,
      sound: true,
    );
    //* quando o método 'initialize' for chamado e o FirebaseMessaging for inicializado...
    //* ele gera um ID/token único que precisa ser registrado
    //* é à partir desse ID/token que o servidor conseguirá enviar as mensagens par ao usuário
    getDeviceFirebaseToken();

    //* escutar as mensagens que chegarão para o usuário
    _onMessage();
    _onMessageOpenedApp();
  }

  getDeviceFirebaseToken() async {
    final token = await FirebaseMessaging.instance.getToken();

    print('=====================');
    print('TOKEN:$token');
    print('=====================');
  }

  //* responsável por capturar a mensagem de notificação enquanto o usuário estiver usando o app
  //* a mensagem pode chegar: quando o user está usando, quando está em segundo plano e quando estiver fechado
  _onMessage() {
    //* essa função só funcionará quando o app estiver aberto ou em segundo plano
    FirebaseMessaging.onMessage.listen(
      (message) {
        //* RemoteNotification => é a notificação que vem dentro da remote message
        RemoteNotification? notification = message.notification;
        //* AndroidNotification => pegando o valor da notification para android
        AndroidNotification? android = message.notification?.android;

        //* fazer a verificação para o android
        if (notification != null && android != null) {
          //* sendo assim, cria uma notificação local
          _notificationService.showNotification(
            CustomNotification(
                id: android.hashCode,
                title: notification.title!,
                body: notification.body!,
                payload: message.data['route'] ?? ''),
          );
        }
      },
    );
  }

  _onMessageOpenedApp() {
    //* dentro do FirebaseMessaging, além o metodo onMessage...
    //* pode-se ecustar a string onMessageOpenedApp...
    //* se o app tá fechado e o user clicou para abrir
    FirebaseMessaging.onMessageOpenedApp.listen(_goToPageAfterMessage);
  }

  //* praticamente o mesmo código definido no NotificationService()
  _goToPageAfterMessage(message) {
    //* recupera a rota
    final String route = message.data['route'] ?? '';
    //* se a rota não tiver vazia, manda para a página indicada
    if (route.isNotEmpty) {
      //* aqui é escutada direto pelo FirebaseMessage
      Routes.navigatorKey?.currentState?.pushNamed(route);
    }
  }
}
