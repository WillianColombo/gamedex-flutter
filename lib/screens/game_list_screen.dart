import 'package:flutter/material.dart';
import '../services/rawg_serv.dart';
import 'game_details_screen.dart';

class GameListScreen extends StatefulWidget {
  @override
  _GameListScreenState createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {
  final RawgService _rawgService = RawgService();  
  late Future<List<dynamic>> _games;

  @override
  void initState() {
    super.initState();
    _games = _rawgService.fetchGames();  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos os jogos'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _games,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());  
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));  
          } else {
            final games = snapshot.data!;
            return ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return GameCard(game: game);  
              },
            );
          }
        },
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final dynamic game;  

  const GameCard({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameDetailsScreen(gameId: game['id']),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              game['background_image'] ?? '',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                game['name'] ?? 'Nome não disponível',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Nota: ${game['rating']?.toString() ?? 'N/A'}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
