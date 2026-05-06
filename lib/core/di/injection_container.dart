import 'package:get_it/get_it.dart';
import '../../features/splash/domain/services/splash_service.dart';

final sl = GetIt.instance;

void init() {
  // Mendaftarkan SplashService agar tidak perlu inisialisasi manual (new Object) di UI
  sl.registerLazySingleton(() => SplashService());
}