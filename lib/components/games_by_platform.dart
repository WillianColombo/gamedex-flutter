import 'package:flutter/material.dart';
import '../screens/games_by_filter_screen.dart';

class GamesByPlatformScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GamesByFilterScreen(
      filterType: 'platforms', 
      title: 'Jogos por Plataforma', 
    );
  }
}