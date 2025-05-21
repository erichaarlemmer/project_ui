import 'package:flutter/material.dart';
import 'package:project_ui/controler/services/websocket_service.dart';
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
        routes: {
          ControlScreen.routeName: (context) => const ControlScreen(),
          PlateDetailsScreen.routeName: (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments
                    as PlateDetailsScreenArgs;
            return PlateDetailsScreen(
              response: args.response,
              wsService: args.wsService,
            );
          },
          AdminPlaceholderScreen.routeName: (context) {
            final wsService =
                ModalRoute.of(context)!.settings.arguments as WebSocketService;
            return AdminPlaceholderScreen(wsService: wsService);
          },
        },
      ),
    );
  }
}
