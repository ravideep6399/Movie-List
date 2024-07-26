import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:movieslist/auth%20repo/user_services.dart';
import 'package:movieslist/firebase_options.dart';
import 'package:movieslist/google_sign_in.dart';
import 'package:movieslist/movies.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final documentsDlr = await getApplicationDocumentsDirectory();
  Hive.init(documentsDlr.path);
  Hive.registerAdapter(MoviesAdapter());
  await Hive.openBox('movies_box');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserViewModel()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 0, 166, 255)),
            useMaterial3: true,
          ),
          home: const LoginView(),
        ));
  }
}
