import 'package:flutter/material.dart';
import 'package:news_firebase/model/news_model.dart';
import 'package:news_firebase/pages/add_post_pages/user_post.dart';

import '../../service/fireservice.dart';
import '../search_page/search_page.dart';
import '../tag_menu/tag_menu.dart';

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TagMenu()));
                },
                child: Text("tags")), 
                 ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchPage()));
                },
                child: Text("arama yap"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ManagerData().fetchDokId();
          setState(() {});
        },
        child: const Text("döküman ıd getir"),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewsForm()));
              },
              icon: const Icon(Icons.add))
        ],
        title: Text('News List'),
      ),
      body: FutureBuilder(
        future: ManagerData().fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData == false) {
            return const Center(child: Text('No data available'));
          } else {
            final newsList = snapshot.data;
            return ListView.builder(
              itemCount: newsList?.length,
              itemBuilder: (context, index) {
                final news = newsList?[index];
                return GestureDetector(
                  onLongPress: () async {
                    final updateArticle = News(
                        category: "masal",
                        id: news?.id ?? "",
                        image: "sadsd",
                        title: "masallar çocukalr içindir.");

                    ManagerData().updateNews(news?.id ?? "", updateArticle);
                    setState(() {});
                  },
                  onTap: () async {},
                  child: ListTile(
                    title: Text(news?.title ?? ""),
                    subtitle: Text(news?.category ?? ""),
                    trailing: IconButton(
                        onPressed: () async {
                          setState(() {});
                          String dokumanId = news?.id ?? "";
                          await ManagerData().deleteNews(dokumanId);
                        },
                        icon: const Icon(Icons.delete)),
                    // leading: SizedBox(
                    //     height: 100,
                    //     width: 80,
                    //     child: Image.network(news?.image ?? "")),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
