import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> initDotenv({bool isOptional = false}) async {
  await dotenv.load(
    isOptional: isOptional,
  );
}
