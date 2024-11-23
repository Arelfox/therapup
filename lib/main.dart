import 'package:flutter/material.dart';
import 'package:therapup/chat_screen.dart';
import 'package:therapup/home_screen.dart';
import 'package:therapup/chat_controller.dart';
import 'navigation_service.dart';
import 'package:provider/provider.dart';

NavigationService navigationService = NavigationService();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'therapup 0.0.1',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.grey[900]!,
          onPrimary: Colors.grey[400]!,
          inversePrimary: Colors.grey[900],
          secondary: Colors.amber[700]!,
          onSecondary: Colors.black,
          error: Colors.red[800]!,
          onError: Colors.white,
          surface: const Color.fromARGB(255, 43, 42, 40),
          onSurface: Colors.grey[600]!,
        ),
        useMaterial3: true,
      ),
      home: MainScreen(key: NavigationService.navigatorKey,)
    );
  }
}

// MARK: Main Screen

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<String> _screenNames = ["Home", "Chat"];
  final List<Widget> _screens = [  // List of screens to use in IndexStack
    const HomeScreen(),
    ChangeNotifierProvider(
      create: (_) => ChatController(),
      child: const ChatScreen(),
    ),
  ];

  bool _isNavigating = false;  // navigation debounce to prevent navigator.pop popping app root


  void _onItemTapped(int index) {
    if (_isNavigating) return;
    _isNavigating = true;

    setState(() {
      _selectedIndex = index;
    });

    Navigator.pop(context); // Close the drawer

    Future.delayed(const Duration(milliseconds: 1000), () {
      _isNavigating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screenNames[_selectedIndex]),
      ),
      drawer: Drawer(
        width: 200,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
              child: Text(
                'therapup 0.0.1',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 40
                ),
              ),
            ),
            ..._screenNames.map((screenName) {
              return ListTile(
                title: Text(screenName),
                onTap: () => _onItemTapped(_screenNames.indexOf(screenName)),
              );
            }).toList(),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
    );
  }
}


