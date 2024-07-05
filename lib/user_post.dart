import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_firebase/model/news_model.dart';

import 'service/fireservice.dart';

class NewsForm extends StatefulWidget {
  @override
  _NewsFormState createState() => _NewsFormState();
}

class _NewsFormState extends State<NewsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryController = TextEditingController();

  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  //data ekle

  Future<void> _addNews() async {
    if (_formKey.currentState?.validate() == true) {
      final newsNew = News(
          category: _categoryController.text,
          id: "",
          image: _imageController.text,
          title: _titleController.text);

      await ManagerData().addNews(newsNew);
      setState(() {});

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('News added')));
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add News'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addNews,
                child: Text('Add News'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
