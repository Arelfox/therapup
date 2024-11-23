import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'chat_controller.dart';
// import 'home_screen.dart';
// import 'chat_screen.dart';
// import 'main.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Route<dynamic> generateRoute(RouteSettings settings) {
  //   Widget viewToShow;
  //   switch (settings.name) {
  //     case '/chat':
  //       viewToShow = ChangeNotifierProvider(
  //         create: (_) => ChatController(),  // Creating the ChatController
  //         child: const ChatScreen(title: "Chat")
  //       );
  //       break;
  //     default:
  //       viewToShow = const HomeScreen(title: "Home");
  //   }

  //   return MaterialPageRoute(  // add to main screen
  //     settings: settings,
  //     builder: (_) => MainScreen(child: viewToShow),
  //   );
  // }

  // Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
  //   return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  // }

  // void back() {
  //   return navigatorKey.currentState!.pop();
  // }
}