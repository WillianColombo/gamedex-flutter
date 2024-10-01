import 'package:flutter/material.dart';
import '../services/rawg_serv.dart';
import 'package:teste_mobile/screens/game_details_screen.dart';

class GameSearchDelegate extends SearchDelegate {
  final RawgService _rawgService;

  GameSearchDelegate(this._rawgService);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: _rawgService.fetchGamesByName(query),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum jogo encontrado'));
        }

        final games = snapshot.data!;
        return ListView.builder(
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            return ListTile(
              title: Text(game['name']),
              leading: Image.network(
                game['background_image'] ?? '',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameDetailsScreen(gameId: game['id']),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Digite o nome de um jogo'));
    } else {
      return FutureBuilder(
        future: _rawgService.fetchGamesByName(query),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum jogo encontrado'));
          }

          final games = snapshot.data!;
          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return ListTile(
                title: Text(game['name']),
                onTap: () {
                  close(context, null);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameDetailsScreen(gameId: game['id']),
                    ),
                  );
                },
              );
            },
          );
        },
      );
    }
  }
}
