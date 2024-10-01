import 'package:flutter/material.dart';
import '../services/rawg_serv.dart';

class GameDetailsScreen extends StatefulWidget {
  final int gameId;

  const GameDetailsScreen({Key? key, required this.gameId}) : super(key: key);

  @override
  _GameDetailsScreenState createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  final RawgService _rawgService = RawgService();
  late Future<Map<String, dynamic>> _gameDetails;

  @override
  void initState() {
    super.initState();
    _gameDetails = _rawgService.fetchGameDetails(widget.gameId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Jogo'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _gameDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            final game = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    game['background_image'] ?? '',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    game['name'] ?? 'Nome não disponível',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Descrição: ${game['description_raw'] ?? 'Sem descrição disponível'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Lançamento: ${game['released'] ?? 'Data de lançamento não disponível'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Nota: ${game['rating']?.toString() ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Plataformas: ${game['platforms'] != null ? game['platforms'].map((p) => p['platform']['name']).join(', ') : 'Informação indisponível'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Gêneros: ${game['genres'] != null ? game['genres'].map((g) => g['name']).join(', ') : 'Informação indisponível'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Desenvolvedor(es): ${game['developers'] != null ? game['developers'].map((d) => d['name']).join(', ') : 'Informação indisponível'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
