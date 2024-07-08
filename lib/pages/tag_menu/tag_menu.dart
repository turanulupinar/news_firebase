import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_firebase/model/tags_model.dart';
import 'package:news_firebase/service/tags_collection.dart';

import '../../model/news_model.dart';

class TagMenu extends StatefulWidget {
  const TagMenu({super.key});

  @override
  State<TagMenu> createState() => _TagMenuState();
}

class _TagMenuState extends State<TagMenu> {
  List<Tags> tagList = [];
  List<News> newsList = [];
  @override
  void initState() {
    addData();
    super.initState();
  }

  fetchNews(String category) async {
    newsList = await NewsCollection().fetchNewsByCategory(category);
    setState(() {});
  }

  addData() async {
    tagList = await TagsCollection().fetchNews();
    setState(() {});
  }

  int selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("tags"),
      ),
      body: Column(
        children: [
          SizedBox(
              height: 70,
              width: 450,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tagList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChoiceChip(
                        selectedColor: Colors.red,
                        disabledColor: Colors.grey,
                        onSelected: (val) {
                          selectedIndex = val ? index : -1;
                          fetchNews(tagList[index].tagname.toString());

                          setState(() {});
                        },
                        selected: selectedIndex == index,
                        label: Text(tagList[index].tagname.toString()),
                      ),
                    );
                  })),
          Expanded(
              child: ListView.builder(
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(newsList[index].title),
                      subtitle: Text(newsList[index].category),
                    );
                  }))
        ],
      ),
    );
  }
}

class NewsCollection {
  final CollectionReference newsCollection =
      FirebaseFirestore.instance.collection('news');

  Future<List<News>> fetchNewsByCategory(String category) async {
    QuerySnapshot querySnapshot =
        await newsCollection.where('category', isEqualTo: category).get();
    return querySnapshot.docs
        .map((doc) =>
            News.fromFirestore(doc.data() as Map<String, dynamic>, category))
        .toList();
  }
}
