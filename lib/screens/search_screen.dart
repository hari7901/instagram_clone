
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
   bool isShowUsers = false;
  @override
  void dispose(){
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextFormField(
          style: TextStyle(
            color: Colors.white
          ),
          controller: searchController,
          decoration: const InputDecoration(
           labelText: "Search for a user",
            labelStyle: TextStyle(
              color: Colors.grey,
            ),
          ),
          onFieldSubmitted: (String _){
            setState(() {
              isShowUsers = true;
            });
          },
        ),
      ),
      body: isShowUsers? FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('username',
            isGreaterThanOrEqualTo: searchController.text)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            if (data != null && data.docs != null) {
              return ListView.builder(
                itemCount: data.docs.length,
                itemBuilder: (context, index) {
                  var profilePicUrl =
                      data.docs[index]['profilePicUrl'] ?? '';
                  var username = data.docs[index]['username'] ?? '';
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(profilePicUrl),
                    ),
                    title: Text(username,style: TextStyle(
                      color: Colors.white
                    ),),
                  );
                },
              );
            } else {
              return Center(
                child: Text('No users found.'),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
      : FutureBuilder(
        future: FirebaseFirestore.instance.collection('posted').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }

          var data = snapshot.data as QuerySnapshot;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns in the grid view
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: data.docs.length,
              itemBuilder: (context, index) {
                var imageUrl = data.docs[index]['imageUrl'] ?? '';
                return Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
