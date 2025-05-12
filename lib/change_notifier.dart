import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Deck {
  final String name;
  final List<String> cards;
  final String imagePath;

  Deck({required this.name, required this.cards, required this.imagePath});
}

class CardDetails {
  final String name;
  final String description;
  final String meaningUp;
  final String meaningRev;

  CardDetails({
    required this.name,
    required this.description,
    required this.meaningUp,
    required this.meaningRev,
  });
}

class DeckProvider with ChangeNotifier {
  // Состояния для управления загрузкой
  bool _isLoading = false;
  String? _errorMessage;

  // Данные о колодах
  List<Deck> _decks = [];
  int _currentDeckIndex = 0;

  // Данные о картах
  Map<String, CardDetails> _cardDetails = {};

  // Геттеры
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Deck> get decks => _decks;
  int get currentDeckIndex => _currentDeckIndex; // Добавлен геттер
  List<String> get currentDeck => _decks[_currentDeckIndex].cards;
  String get currentDeckImagePath => _decks[_currentDeckIndex].imagePath;

  // Метод для изменения текущей колоды
  void changeDeck(int index) {
    _currentDeckIndex = index;
    notifyListeners();
  }

  // Метод для загрузки данных о колодах с сервера
  Future<void> loadDecks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://mad-batm.github.io/taro_info/deck_info.json'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _decks =
            data
                .map(
                  (deck) => Deck(
                    name: deck['name'],
                    cards: List<String>.from(deck['cards']),
                    imagePath: deck['imagePath'],
                  ),
                )
                .toList();
      } else {
        _errorMessage = 'Ошибка загрузки данных: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Ошибка: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Метод для загрузки описаний карт с сервера
  Future<void> loadCardDescriptions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://mad-batm.github.io/taro_info/card_data.json'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _cardDetails = {
          for (var card in data)
            card['name_short']: CardDetails(
              name: card['name_short'],
              description: card['desc'],
              meaningUp: card['meaning_up'],
              meaningRev: card['meaning_rev'],
            ),
        };
      } else {
        _errorMessage = 'Ошибка загрузки данных: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Ошибка: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Получение информации о конкретной карте
  CardDetails? getCardDetails(String cardName) {
    return _cardDetails[cardName];
  }
}
