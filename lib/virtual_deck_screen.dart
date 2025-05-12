import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'change_notifier.dart'; // Для DeckProvider

class VirtualDeckScreen extends StatelessWidget {
  const VirtualDeckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deckProvider = Provider.of<DeckProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Виртуальная колода'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Выбор колоды
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<int>(
              value: deckProvider.currentDeckIndex,
              items: List.generate(
                deckProvider.decks.length,
                (index) => DropdownMenuItem<int>(
                  value: index,
                  child: Text(deckProvider.decks[index].name),
                ),
              ),
              onChanged: (value) {
                if (value != null) {
                  deckProvider.changeDeck(value);
                }
              },
              hint: const Text('Выберите колоду'),
              isExpanded: true,
            ),
          ),
          // Отображение карт
          Expanded(
            child: Consumer<DeckProvider>(
              builder: (context, deckProvider, child) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // Количество столбцов
                    mainAxisSpacing: 8.0, // Отступ между строками
                    crossAxisSpacing: 8.0, // Отступ между столбцами
                  ),
                  itemCount: deckProvider.currentDeck.length,
                  itemBuilder: (context, index) {
                    final cardName = deckProvider.currentDeck[index];
                    return GestureDetector(
                      onTap: () {
                        _showCardDetails(context, cardName);
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          '${deckProvider.currentDeckImagePath}$cardName.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Метод для показа деталей карты
  void _showCardDetails(BuildContext context, String cardName) {
    final deckProvider = Provider.of<DeckProvider>(context, listen: false);
    final cardDetails = deckProvider.getCardDetails(cardName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(cardDetails?.name ?? 'Карта не найдена'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (cardDetails != null) ...[
                  Text(
                    'Значение (прямое): ${cardDetails.meaningUp}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Значение (перевёрнутое): ${cardDetails.meaningRev}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }
}
