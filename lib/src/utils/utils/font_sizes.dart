import 'package:componentes_lr/src/utils/utils/app_measurements.dart';

final bool isMobile = AppMeasurements.instance.isMobile;

final veryLargeFont = isMobile ? 20.sp : 16.sp;
final largeFont = isMobile ? 17.sp : 13.sp;
final mediumLargeFont = isMobile ? 15.sp : 10.sp;
final mediumFont = isMobile ? 13.sp : 9.sp;
final smallMediumFont = isMobile ? 12.sp : 8.sp;
final smallFont = isMobile ? 12.sp : 8.sp;
final verySmallFont = isMobile ? 11.sp : 8.sp;
final tinyFont = isMobile ? 10.sp : 6.sp;
final standardTextFont = isMobile ? 14.sp : 11.sp;
