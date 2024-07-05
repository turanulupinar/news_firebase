import 'package:flutter/material.dart';
import 'package:news_firebase/model/news_model.dart';
import 'package:news_firebase/user_post.dart';

import '../service/fireservice.dart';

class NewsList extends StatefulWidget {
  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewsForm()));
              },
              icon: Icon(Icons.add))
        ],
        title: Text('News List'),
      ),
      body: FutureBuilder(
        future: ManagerData().fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData == false) {
            return Center(child: Text('No data available'));
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
