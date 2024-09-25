import 'package:componentes_lr/src/utils/utils/dotenv.dart';
import 'package:componentes_lr/src/utils/utils/package_info.dart';
import 'package:componentes_lr/src/utils/utils/storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

PackageInfo get versaoAplicativo => packageInfo;

Future<void> initAppInfos({bool isOptional = false}) async {
  await Future.wait([
    initPackageInfo(),
    initStorage(),
    initDotenv(isOptional: isOptional),
  ]);
}
