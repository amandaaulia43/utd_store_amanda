import 'package:get_it/get_it.dart';
import '../../features/splash/domain/services/splash_service.dart';
import '../../core/network/api_client.dart';
import '../../core/network/isar_service.dart'; // Sesuaikan folder tempat kamu simpan IsarService
import '../../features/product/data/product_repository.dart';
import '../../features/product/presentation/cubit/product_cubit.dart';

final sl = GetIt.instance;

void init() {
  // 1. Splash Service
  sl.registerLazySingleton(() => SplashService());

  // 2. Network (Dio Client)
  sl.registerLazySingleton(() => ApiClient());

  // 3. Database (Isar)
  // Sesuai PDF: Untuk menyimpan bookmark secara lokal
  sl.registerLazySingleton(() => IsarService());

  // 4. Product Data Layer
  sl.registerLazySingleton(() => ProductRepository(sl()));

  // 5. Product Presentation Layer (Cubit)
  // Menggunakan registerFactory karena Cubit harus di-reset setiap kali masuk halaman
  sl.registerFactory(() => ProductCubit(sl()));
}