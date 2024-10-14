import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => GameState(),
    child: CardMatchingGame(),
  ),
);

class CardMatchingGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Matching Game',
      home: Scaffold(
        appBar: AppBar(title: Text('Card Matching Game')),
        body: CardGrid(),
      ),
    );
  }
}

class CardGrid extends StatelessWidget {
  final List<CardModel> cards = List.generate(16, (index) => CardModel(index));

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return CardWidget(card: cards[index]);
      },
    );
  }
}

class CardModel {
  int id;
  List<int> Id = [0, 1, 2, 3, 4, 5, 6, 7, 0, 1, 2, 3, 4, 5, 6, 7];
  bool isFaceUp = false;
  List<String> image = ["assets/Ace_of_Spades.png", "assets/7_of_Diamonds.png", "assets/Ace_of_Hearts.avif", "assets/King_of_Hearts.png",
                        "assets/Queen_of_Clover.jpg", "assets/4_of_Hearts.jpg", "assets/Jack_of_Diamonds.webp", "assets/7_of_Spades.jpg"];
  int len = 2;
  CardModel(this.id);
}

class GameState extends ChangeNotifier {
  List<CardModel> cards = List.generate(16, (index) => CardModel(index));
  List<CardModel> faceUpCards = [];
  int pairsMatched = 0;

  void flipCard(CardModel card) {
    if (card.isFaceUp) return;

    card.isFaceUp = true;
    faceUpCards.add(card);
    notifyListeners();

    if (faceUpCards.length == 2) {
      Future.delayed(Duration(milliseconds: 500), () {
        checkMatch();
      });
    }
  }

  void checkMatch() {
    if (faceUpCards[0].Id[faceUpCards[0].id] != faceUpCards[1].Id[faceUpCards[1].id]) {
      faceUpCards[0].isFaceUp = false;
      faceUpCards[1].isFaceUp = false;
    } else {
      pairsMatched++;
      if (pairsMatched == cards.length ~/ 8) {
        // Display victory message
        notifyListeners();
        Text("You won");
      }
    }
    faceUpCards.clear();
    notifyListeners();
  }
}



class CardWidget extends StatelessWidget {
  final CardModel card;

  CardWidget({required this.card});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    return GestureDetector(
      onTap: () {
        gameState.flipCard(card);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          image: card.isFaceUp ? DecorationImage(image: AssetImage(card.image[card.Id[card.id]])) : DecorationImage(image: AssetImage('assets/Back_of_Card.png')),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}