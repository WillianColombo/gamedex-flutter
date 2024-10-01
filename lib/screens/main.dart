import 'package:flutter/material.dart';
import 'package:teste_mobile/components/search.dart';
import 'game_list_screen.dart';
import '../components/games_by_genre.dart';
import '../components/games_by_platform.dart';
import '../components/games_by_developer.dart';
import '../services/rawg_serv.dart';

void main() {
  runApp(GameApp());
}

class GameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gamedex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final RawgService _rawgService = RawgService();

  final List<Widget> _pages = [
    GameListScreen(),
    GamesByGenreScreen(),
    GamesByPlatformScreen(),
    GamesByDeveloperScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Gamedex'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: GameSearchDelegate(_rawgService));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Tela Principal'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Por Gênero'),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.videogame_asset),
              title: const Text('Por Plataforma'),
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Por Desenvolvedora'),
              onTap: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}