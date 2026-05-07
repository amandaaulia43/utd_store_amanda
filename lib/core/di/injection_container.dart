import 'package:get_it/get_it.dart';
import '../../features/splash/domain/services/splash_service.dart';
import '../../core/network/api_client.dart';
import '../../features/product/data/product_repository.dart';
import '../../features/product/presentation/cubit/product_cubit.dart';

final sl = GetIt.instance;

void init() {
  // Splash
  sl.registerLazySingleton(() => SplashService());
  
  // Network
  sl.registerLazySingleton(() => ApiClient());
  
  // Product Data
  sl.registerLazySingleton(() => ProductRepository(sl()));
  
  // Product Presentation (Cubit)
  sl.registerFactory(() => ProductCubit(sl()));
}