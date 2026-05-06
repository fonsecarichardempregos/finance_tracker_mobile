import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker_app/manager/user_manager.dart';
import 'package:finance_tracker_app/screen/login/login_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await initializeDateFormatting('pt_BR', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserManager())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
        ),
        debugShowCheckedModeBanner: false,
        home: const LoginScreen(),
      ),
    );
  }
}