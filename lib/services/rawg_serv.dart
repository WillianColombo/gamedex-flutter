import 'dart:convert';
import 'package:http/http.dart' as http;

class RawgService {
  final String _baseUrl = 'https://api.rawg.io/api';
  final String _apiKey = 'aa72bea4e05444108a22ab1957f69a72';

  // Retorna todos os jogos para a tela inicial do app
  Future<List<dynamic>> fetchGames() async {
    final response = await http.get(Uri.parse('$_baseUrl/games?key=$_apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Falha ao carregar jogos');
    }
  }

  // Retorna os detalhes dos jogos, acessado pelo click no card do game
  Future<Map<String, dynamic>> fetchGameDetails(int gameId) async {
    final response = await http.get(Uri.parse('$_baseUrl/games/$gameId?key=$_apiKey'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar os detalhes do jogo');
    }
  }

  // Retorna os jogos por categoria no filtro. Ex: Se for 'developers' vai retornar os estudios de desenvolvimento
  Future<List<dynamic>> fetchGamesByFilter(String searchType, String searchValue, {int page = 1}) async {
    final url = Uri.parse('$_baseUrl/games?$searchType=$searchValue&key=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    } else {
      throw Exception('Erro ao buscar jogos por $searchType: $searchValue');
    }
  }

  // Retorna o filtro a partir do parâmetro: gênero, plataforma ou desenvolvedora
  Future<List<dynamic>> fetchFilterResults(String filterType) async {
    final response = await http.get(Uri.parse('$_baseUrl/$filterType?key=$_apiKey'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['results'];
    } else {
      throw Exception('Erro ao buscar $filterType');
    }
  }


  Future<List<dynamic>> fetchGamesByName(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/games?key=$_apiKey&search=$query'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['results'];
    } else {
      throw Exception('Erro ao buscar jogos');
    }
  }
}
