//Método para verificar conexão do dispositivo
import 'dart:io';

Future<bool> checkConnection() async {
  try {
    final result = await InternetAddress.lookup("google.com");
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (e) {
    return false;
  }
}
