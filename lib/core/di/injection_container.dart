import 'package:get_it/get_it.dart';
import '../../features/splash/domain/services/splash_service.dart';
import '../../core/network/api_client.dart';
import '../../core/network/isar_service.dart';
import '../../features/product/data/product_repository.dart';
import '../../features/product/presentation/cubit/product_cubit.dart';
// Import CryptoService yang baru dibuat
import '../../features/crypto/data/crypto_service.dart';

final sl = GetIt.instance;

void init() {
  // 1. Splash Service
  sl.registerLazySingleton(() => SplashService());

  // 2. Network (Dio Client)
  sl.registerLazySingleton(() => ApiClient());

  // 3. Database (Isar)
  sl.registerLazySingleton(() => IsarService());

  // 4. Product Data Layer (PERBAIKAN DI SINI: pakai apiClient:)
  sl.registerLazySingleton(() => ProductRepository(apiClient: sl()));

  // 5. Product Presentation Layer (Cubit)
  sl.registerFactory(() => ProductCubit(sl()));

  // 6. Crypto Service (WebSocket & Isolate)
  sl.registerLazySingleton(() => CryptoService());
}