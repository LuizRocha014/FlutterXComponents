import 'package:componentes_lr/src/utils/utils/instance_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String? getDotEnvVariable(String variable) {
  return dotenv.env[variable];
}

final instanceManager = InstanceManager();
