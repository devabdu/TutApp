import 'package:tut_app/data/network/error_handler.dart';
import 'package:tut_app/data/response/response.dart';

const CACHE_HOME_KEY = "Cache_Home_Key";
const CACHE_STORE_DETAILS_KEY = "Cache_Store_Details_Key";
const CACHE_HOME_INTERVAL = 60 * 1000;
const CACHE_STORE_DETAILS_INTERVAL = 30 * 1000;

abstract class LocalDataSource {
  Future<HomeResponse> getHomeData();
  Future<StoreDetailsResponse> getStoreDetails();

  Future<void> saveHomeToCache(HomeResponse homeResponse);
  Future<void> saveStoreDetailsToCache(StoreDetailsResponse storeDetailsResponse);

  void clearCache();

  void removeFrmCache(String key);
}

class LocalDataSourceImplementation implements LocalDataSource {
  Map<String, CachedItem> cacheMap = Map();

  @override
  Future<HomeResponse> getHomeData() async{
    CachedItem? cachedItem = cacheMap[CACHE_HOME_KEY];

    if (cachedItem != null && cachedItem.isValid(CACHE_HOME_INTERVAL)) {
      return cachedItem.data;
    } else {
      throw ErrorHandler.handle(DataSource.cacheError);
    }
  }

  @override
  Future<void> saveHomeToCache(HomeResponse homeResponse) async {
    cacheMap[CACHE_HOME_KEY] = CachedItem(homeResponse);
  }

  @override
  Future<StoreDetailsResponse> getStoreDetails() async{
    CachedItem? cachedItem = cacheMap[CACHE_STORE_DETAILS_KEY];

    if (cachedItem != null && cachedItem.isValid(CACHE_STORE_DETAILS_INTERVAL)) {
      return cachedItem.data;
    } else {
      throw ErrorHandler.handle(DataSource.cacheError);
    }
  }

  @override
  Future<void> saveStoreDetailsToCache(StoreDetailsResponse storeDetailsResponse) async{
    cacheMap[CACHE_STORE_DETAILS_KEY] = CachedItem(storeDetailsResponse);
  }

  @override
  void clearCache() {
    cacheMap.clear();
  }

  @override
  void removeFrmCache(String key) {
    cacheMap.remove(key);
  }
}

class CachedItem {
  dynamic data;
  int cacheTime = DateTime.now().millisecondsSinceEpoch;

  CachedItem(this.data);
}

extension CachedItemExtension on CachedItem {
  bool isValid(int expirationTimeInMills) {
    int currentTimeInMills = DateTime.now().millisecondsSinceEpoch;

    bool isValid = currentTimeInMills - cacheTime <= expirationTimeInMills;
    return isValid;
  }
}
