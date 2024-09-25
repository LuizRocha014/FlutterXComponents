import 'dart:io';

import 'package:local_auth/local_auth.dart';

Future<bool> get biometryCheck async {
  final validatedBiometry = await LocalAuthentication().authenticate(
    localizedReason: "${Platform.isAndroid ? "Utilize a sua digital" : "Utilize o FaceId"} para fazer o login.",
  );
  return validatedBiometry;
}
