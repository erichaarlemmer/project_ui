import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'screens/home_screen.dart';
import 'screens/control_screen.dart';
import 'screens/plate_details_screen.dart';
import 'screens/admin_placeholder_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Badge Login App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case ControlScreen.routeName:
              return MaterialPageRoute(builder: (_) => const ControlScreen());

            case PlateDetailsScreen.routeName:
              final args = settings.arguments as PlateDetailsScreenArgs;
              return MaterialPageRoute(
                builder: (_) => PlateDetailsScreen(response: args.response),
              );

            case AdminPlaceholderScreen.routeName:
              return MaterialPageRoute(
                builder: (_) => const AdminPlaceholderScreen(),
              );

            default:
              return null;
          }
        },
      ),
    );
  }
}
