import 'package:flutter/material.dart';
import '../screens/games_by_filter_screen.dart';

class GamesByDeveloperScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GamesByFilterScreen(
      filterType: 'developers', 
      title: 'Jogos por Desenvolvedora', 
    );
  }
}
