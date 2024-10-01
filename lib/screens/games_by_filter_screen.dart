import 'package:flutter/material.dart';
import '../services/rawg_serv.dart';
import 'game_details_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';

class GamesByFilterScreen extends StatefulWidget {
  final String filterType; 
  final String title; 

  GamesByFilterScreen({required this.filterType, required this.title});

  @override
  _GamesByFilterScreenState createState() => _GamesByFilterScreenState();
}

class _GamesByFilterScreenState extends State<GamesByFilterScreen> {
  final RawgService _rawgService = RawgService();
  late Future<Map<String, List<dynamic>>> _gamesByFilter;

  @override
  void initState() {
    super.initState();
    _gamesByFilter = _fetchGamesByFilter();
  }

  Future<Map<String, List<dynamic>>> _fetchGamesByFilter() async {
    
    final filters = await _rawgService.fetchFilterResults(widget.filterType);
    Map<String, List<dynamic>> gamesByFilter = {};

    for (var filter in filters) {
      final games = await _rawgService.fetchGamesByFilter(widget.filterType, filter['slug']);
      gamesByFilter[filter['name']] = games;
    }

    return gamesByFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<Map<String, List<dynamic>>>(
        future: _gamesByFilter,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            final gamesByFilter = snapshot.data!;
            return ListView(
              children: gamesByFilter.keys.map((filterName) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        filterName.toUpperCase(),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 250,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                      ),
                      items: gamesByFilter[filterName]!.map((game) {
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
                            child: Column(
                              children: [
                                Image.network(
                                  game['background_image'] ?? '',
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    game['name'] ?? 'Nome não disponível',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
