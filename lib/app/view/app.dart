import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/auth/repository/auth_repository.dart';
import 'package:todo_list_app/auth/view/login_page.dart';
import 'package:todo_list_app/auth/view/signup_page.dart';
import 'package:todo_list_app/tasks/view/home_page.dart';
import 'package:todo_list_app/tasks/repository/task_repository.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => TaskRepository()),
      ],
      child: MaterialApp(
        title: 'To-Do List',
        theme: ThemeData(
          primaryColor: const Color(0xFF2962FF),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          useMaterial3: true,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}
