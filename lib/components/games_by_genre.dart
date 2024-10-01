import 'package:flutter/material.dart';
import '../screens/games_by_filter_screen.dart';

class GamesByGenreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GamesByFilterScreen(
      filterType: 'genres', 
      title: 'Jogos por Gênero', 
    );
  }
}