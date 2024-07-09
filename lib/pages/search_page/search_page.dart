import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_firebase/pages/tag_menu/tag_menu.dart';

import '../../model/news_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isLoading = false;
  String errorMessage = "hatalı giriş";

  void searchNewses(String query) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });
      searchResults = await SearchCollectionManager().searchNews(query);
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load search results';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  TextEditingController searchController = TextEditingController();
  List<News> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arama yap "),
      ),
      body: Column(
        children: [
          Center(
            child: SizedBox(
              height: 50,
              width: 300,
              child: TextField(
                onChanged: (val) {
                  searchNewses(val);
                  setState(() {});
                },
                controller: searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: "ara",
                ),
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        searchResults[index].title,
                      ),
                      subtitle: Text(searchResults[index].category),
                    );
                  }))
        ],
      ),
    );
  }
}

class SearchCollectionManager {
  final newsCollection =
      FirebaseFirestore.instance.collection('news').withConverter<News>(
            fromFirestore: (snapshot, _) =>
                News.fromFirestore(snapshot.data()!, snapshot.id),
            toFirestore: (news, _) => news.toFirestore(),
          );

  Future<List<News>> searchNews(String query) async {
    try {
      QuerySnapshot<News> querySnapshot =
          await newsCollection.where('title', isEqualTo: query).get();
      if (querySnapshot.docs.isEmpty) {
        querySnapshot =
            await newsCollection.where('category', isEqualTo: query).get();
      }
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to search news: $e');
    }
  }
}
