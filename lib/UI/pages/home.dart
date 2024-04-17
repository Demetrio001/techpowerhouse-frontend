import 'package:flutter/material.dart';

import '../../model/model.dart';

import '../../model/objects/cards.dart';
import '../widgets/box_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Cards> cards = [];
  int currentPage = 0;
  int itemsPerPage = 10;
  TextEditingController titleController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCards();
  }

  Future<void> fetchCards() async {
    try {
      final retrievedCards = await Model.sharedInstance.getCards();
      setState(() {
        cards = retrievedCards;
        isLoading = false;
      });
    } catch(e) {
      isLoading = false;
    }
  }

  void previousPage() async {
    if (currentPage > 0) {
      final List<Cards> retrievedBooks;
      if(titleController.text == '') {
        retrievedBooks = await Model.sharedInstance.getCards(pageNumber: currentPage-1);
      } else {
        retrievedBooks = await Model.sharedInstance.getCardsByTitle(titleController.text, pageNumber: currentPage-1);
      }
      setState(() {
        currentPage-=1;
        cards = retrievedBooks;
      });
    }
  }

  void nextPage() async {
    final List<Cards> retrievedBooks;
    if(titleController.text == '') {
      retrievedBooks = await Model.sharedInstance.getCards(pageNumber: currentPage+1);
    } else {
      retrievedBooks = await Model.sharedInstance.getCardsByTitle(titleController.text, pageNumber: currentPage+1);
    }
    if (retrievedBooks.isNotEmpty) {
      setState(() {
        currentPage+=1;
        cards = retrievedBooks;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        children: <Widget>[
          SizedBox(
            width: 500,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: titleController,
                  style: TextStyle(color:Colors.white),
                  onSubmitted: (String searchTitle) async {
                    List<Cards> searchResults = await Model.sharedInstance.getCardsByTitle(searchTitle);
                    setState(() {
                      cards = searchResults;
                      currentPage = 0;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Titolo',
                    hintStyle: TextStyle(color: Colors.white),
                    border: const OutlineInputBorder(),
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.clear, color:Colors.white),
                      onPressed: () {
                        titleController.clear();
                      },
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search_rounded,color:Colors.white),
                      onPressed: () async {
                        String searchTitle = titleController.text;
                        List<Cards> searchResults = await Model.sharedInstance.getCardsByTitle(searchTitle);
                        setState(() {
                          cards = searchResults;
                          currentPage = 0;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
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

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back,color:Colors.white),
                onPressed: previousPage,
              ),
              Text('Pagina: ${currentPage+1}', style: TextStyle(color: Colors.white)),
              IconButton(
                icon: const Icon(Icons.arrow_forward, color:Colors.white),
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