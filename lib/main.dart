import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'spread_selection_screen.dart'; // Экран выбора расклада
import 'virtual_deck_screen.dart'; // Экран просмотра колоды
import 'change_notifier.dart'; // Файл с DeckProvider

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем провайдер через контекст
    final deckProvider = Provider.of<DeckProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Гадание на Таро'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Если данные загружаются, показываем индикатор загрузки
            if (deckProvider.isLoading)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  // Кнопка "Выбрать расклад"
                  ElevatedButton(
                    onPressed: () async {
                      await deckProvider
                          .loadDecks(); // Загрузка данных о колодах
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SpreadSelectionPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Выбрать расклад',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Отступ между кнопками
                  // Кнопка "Открыть виртуальную колоду"
                  ElevatedButton(
                    onPressed: () async {
                      await deckProvider
                          .loadDecks(); // Загрузка данных о колодах
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VirtualDeckScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Открыть виртуальную колоду',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
