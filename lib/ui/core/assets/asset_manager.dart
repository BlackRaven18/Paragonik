import 'package:paragonik/data/models/enums/store_enum.dart';

class AssetManager {
  AssetManager._();

  static const String _imagesPath = 'assets/images';
  static const String _iconsPath = 'assets/icons';

  static const String appLogo = '$_imagesPath/logo.png';

  static const String storeBiedronka = '$_iconsPath/biedronka.png';
  static const String storeZabka = '$_iconsPath/zabka.png';
  static const String storeLidl = '$_iconsPath/lidl.png';
  static const String storeSpolem = '$_iconsPath/spolem.png';

  static String? getIconForStore(StoreEnum store) {
    switch (store) {
      case StoreEnum.biedronka:
        return storeBiedronka;
      case StoreEnum.zabka:
        return storeZabka;
      case StoreEnum.lidl:
        return storeLidl;
      case StoreEnum.spolem:
        return storeSpolem;
      case StoreEnum.unknown:
      default:
        return null;
    }
  }
}
