import 'package:flutter/material.dart';
import 'package:my_new_taro_app/spread_selection_page.dart';
import 'package:provider/provider.dart';
import 'spread_selection_screen.dart'; // Экран выбора расклада
import 'virtual_deck_screen.dart'; // Экран просмотра колоды
import 'change_notifier.dart'; // Файл с DeckProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final deckProvider = DeckProvider();
  await Future.wait([
    deckProvider.loadDecks(), // Загрузка данных о колодах
    deckProvider.loadCardDescriptions(), // Загрузка описаний карт
  ]);

  runApp(
    ChangeNotifierProvider(
      create: (_) => deckProvider,
      child: const TarotApp(),
    ),
  );
}

class TarotApp extends StatelessWidget {
  const TarotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tarot App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Гадание на Таро'),
        backgroundColor: const Color(0xFF1B003B), // Темно-фиолетовый фон
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Кнопка "Выбрать расклад"
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8A2BE2), // Фон кнопки
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SpreadSelectionPage(),
                  ),
                );
              },
              child: const Text(
                'Выбрать расклад',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20), // Отступ между кнопками
            // Кнопка "Открыть виртуальную колоду"
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8A2BE2), // Фон кнопки
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VirtualDeckScreen(),
                  ),
                );
              },
              child: const Text(
                'Открыть виртуальную колоду',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
