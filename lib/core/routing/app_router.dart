import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/product/presentation/pages/product_page.dart';
import '../../features/bookmark/presentation/pages/bookmark_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const ProductPage(),
    ),
    GoRoute(
      path: '/bookmarks',
      builder: (context, state) => const BookmarkPage(),
    ),
  ],
);