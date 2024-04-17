import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../model/objects/cards.dart';
import '../widgets/box_card.dart';


class RisultatiRicerca extends StatefulWidget {
  final String name;
  final String creator;
  final String publisher;
  final String category;
  final String orderBy;

  const RisultatiRicerca(
      this.name,
      this.creator,
      this.publisher,
      this.category,
      this.orderBy, {
        Key? key,
      }) : super(key: key);

  @override
  _RisultatiRicercaState createState() => _RisultatiRicercaState();
}

class _RisultatiRicercaState extends State<RisultatiRicerca> {
  List<Cards> cards = [];
  int currentPage = 0;
  int itemsPerPage = 10;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      final retrivedCards = await Model.sharedInstance.advancedSearch(
        name: widget.name,
        creator: widget.creator,
        publisher: widget.publisher,
        category: widget.category,
        sortBy: widget.orderBy,
        pageNumber: currentPage,
      );
      setState(() {
        cards = retrivedCards;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void previousPage() async {
    if (currentPage > 0) {
      final List<Cards> retrievedBooks = await Model.sharedInstance.advancedSearch(
        name: widget.name,
        creator: widget.creator,
        publisher: widget.publisher,
        category: widget.category,
        sortBy: widget.orderBy,
        pageNumber: currentPage - 1,
      );
      setState(() {
        currentPage -= 1;
        cards = retrievedBooks;
      });
    }
  }

  void nextPage() async {
    final List<Cards> retrievedCards = await Model.sharedInstance.advancedSearch(
      name: widget.name,
      creator: widget.creator,
      publisher: widget.publisher,
      category: widget.category,
      sortBy: widget.orderBy,
      pageNumber: currentPage + 1,
    );
    if (retrievedCards.isNotEmpty) {
      setState(() {
        currentPage += 1;
        cards = retrievedCards;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade600,
        title: const Text(
          'Risultati Ricerca',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 50,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
        image: DecorationImage(
        image: AssetImage('assets/images/background.jpg'),
        fit: BoxFit.cover,
        opacity: 0.9,
        ),
      ),
    child:isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final item = cards[index];
                  return BoxCard(c: item);
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: previousPage,
              ),
              Text('Pagina: ${currentPage + 1}'),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: nextPage,
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}

