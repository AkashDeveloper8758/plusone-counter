import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:plusone_counter/utils/initials/app_routes.dart';
import 'package:plusone_counter/utils/initials/initialize_controllers.dart';
import 'package:plusone_counter/utils/ui/color_schemes.g.dart';

void main() async {
  await initMain();
  runApp(const MyApp());
}

initMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeControllers();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        // appBarTheme: AppBarTheme(
        //     backgroundColor: Theme.of(context).secondaryHeaderColor),
      ),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      onGenerateRoute: GenerateRoute.generateRoute,
      initialRoute: '/',
    );
  }
}
