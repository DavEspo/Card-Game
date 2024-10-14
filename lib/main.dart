import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final List<CardModel> cards = List.generate(4, (index) => CardModel(index));

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return CardWidget(card: cards[index]);
      },
    );
  }
}

class CardModel {
  final int id;
  bool isFaceUp = false;
  final String front;
  final String back = "BACK";

  CardModel(this.id) : front = "CARD $id";
}

class GameState extends ChangeNotifier {
  List<CardModel> cards = List.generate(4, (index) => CardModel(index));
  List<CardModel> faceUpCards = [];
  int pairsMatched = 0;

  void flipCard(CardModel card) {
    if (card.isFaceUp) return;

    card.isFaceUp = true;
    faceUpCards.add(card);
    notifyListeners();

    if (faceUpCards.length == 2) {
      Future.delayed(Duration(seconds: 1), () {
        checkMatch();
      });
    }
  }

  void checkMatch() {
    if (faceUpCards[0].id != faceUpCards[1].id) {
      faceUpCards[0].isFaceUp = false;
      faceUpCards[1].isFaceUp = false;
    } else {
      pairsMatched++;
      if (pairsMatched == cards.length ~/ 2) {
        // Display victory message
        notifyListeners();
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
          image: card.isFaceUp ? DecorationImage(image: AssetImage('assets/Card.jpg')) : DecorationImage(image: AssetImage('assets/Back_of_Card.png')),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(card.isFaceUp ? card.front : card.back),
        ),
      ),
    );
  }
}