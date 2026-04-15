import 'package:go_router/go_router.dart';
import 'package:login_app/presentation/screens/home_screen.dart';
import 'package:login_app/presentation/screens/login_screen.dart';
import 'package:login_app/presentation/screens/register_screen.dart';
import 'package:login_app/domain/users.dart';
import 'package:login_app/domain/drink.dart';
import 'package:login_app/presentation/screens/detail_screen.dart';

final users = Users();

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
      GoRoute(path: '/login', builder: (context, state) => LoginScreen(userManagement: users),),    
      GoRoute(path: '/register', builder: (context, state) => RegisterScreen(users : state.extra as Users),),
    GoRoute(path: '/home', builder: (context, state) => HomeScreen(userEmail : state.extra as String),),
    GoRoute(path:   '/detail', builder: (context, state) => DetailScreen(drink: state.extra as Drink),),
  ],
);