import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../utils/menu_item.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  final String imageUrl;
  final String username;
  final String uid;

  ProfilePage({required this.imageUrl,required this.username, required this.uid,});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedTabIndex = 0;
  var userData = {};

  void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Snackbar display duration
      ),
    );
  }
  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  Future<List<String>> _getImagesFromFirebaseStorage() async {
    List<String> imageUrls = [];


    try {
      // Get a reference to the folder containing the images in Firebase Storage
      Reference storageReference = FirebaseStorage.instance.ref().child('posted');

      // List all items in the folder
      ListResult result = await storageReference.listAll();

      // Iterate through the items and get download URLs
      for (var item in result.items) {
        String downloadURL = await item.getDownloadURL();
        imageUrls.add(downloadURL);
      }
    } catch (e) {
      // Handle errors, e.g., folder not found or images not available
      print('Error fetching images from Firebase Storage: $e');
    }

    return imageUrls;
  }

  void _showCustomMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
            ),
            child: CustomMenu(
              menuItems: [
                MenuItem(
                  title: 'Settings and privacy',
                  icon: FontAwesomeIcons.gears,
                  onTap: () {
                    // Handle Settings and privacy
                  },
                ),
                MenuItem(
                  title: 'Threads',
                  icon: FontAwesomeIcons.comment,
                  onTap: () {
                    // Handle Threads
                  },
                ),
                MenuItem(
                  title: 'Your Activity',
                  icon: FontAwesomeIcons.solidNewspaper,
                  onTap: () {
                    // Handle Threads
                  },
                ),
                MenuItem(
                  title: 'Archive',
                  icon: FontAwesomeIcons.boxArchive,
                  onTap: () {
                    // Handle Threads
                  },
                ),
                MenuItem(
                  title: 'OR code',
                  icon: FontAwesomeIcons.qrcode,
                  onTap: () {
                    // Handle Threads
                  },
                ),
                MenuItem(
                  title: 'Saved',
                  icon: FontAwesomeIcons.bookmark,
                  onTap: () {
                    // Handle Threads
                  },
                ),
                MenuItem(
                  title: 'Supervision',
                  icon: FontAwesomeIcons.eye,
                  onTap: () {
                    // Handle Threads
                  },
                ),
                MenuItem(
                  title: 'Close friends',
                  icon: FontAwesomeIcons.userGroup,
                  onTap: () {
                    // Handle Threads
                  },
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            const Icon(
              Icons.lock_outlined,
              color: Colors.white,
            ),
            Text(widget.username,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.white),
          ],
        ),
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.bars, color: Colors.white),
            onPressed: () {
              _showCustomMenu(context);
            },
          ),
        ],
      ),

      body: Container(
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        widget.imageUrl,
                      ), // Add profile picture asset
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '123', // Replace with the actual number of posts
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text('Posts',style: TextStyle(
                          color: Colors.white,)),
                      ],
                    ),
                    const SizedBox(width: 24),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '  456k', // Replace with the actual number of followers
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text('Followers',style: TextStyle(
                          color: Colors.white,),)
                      ],
                    ),
                    const SizedBox(width: 24),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '   789', // Replace with the actual number of following
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text('Following',
                            style: TextStyle(
                              color: Colors.white,)),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Bio goes here. This is a sample bio for the user. Feel free to customize.',
                  style:  TextStyle(
                      color: Colors.white,
                      fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _buildProfileActions(),
              ),
              // Share Profile Button
              _buildTabBar(),
              _buildTabContent(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildProfileActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Show Edit Profile Dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Edit Profile'),
                    content: Text('Customize your edit profile options here.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle edit profile action
                          Navigator.of(context).pop();
                        },
                        child: Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Edit Profile'),
            style: ElevatedButton.styleFrom(
              primary: Colors.grey[850], // Background color
              onPrimary: Colors.white, // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Handle share profile action
            },
            child: Text("Share Profile"),
            style: ElevatedButton.styleFrom(
              primary: Colors.grey[850], // Background color
              onPrimary: Colors.white, // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
            ),

          ),
        ),
      ],
    );
  }
  Widget _buildTabBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildTabItem('Posts', 0),
          _buildTabItem('Tagged', 1),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    return GestureDetector(
      onTap: () {
        _onTabTapped(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _selectedTabIndex == index
                  ? Colors.black
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: _selectedTabIndex == index ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
      // TODO: Implement Posts grid view
        return _buildPostsGrid();
      case 1:
      // TODO: Implement Tagged photos content
        return Center();
      default:
        return Container();
    }
  }


  Widget _buildPostsGrid() {
    return FutureBuilder<List<String>>(
      future: _getImagesFromFirebaseStorage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No posts available'));
        } else {
          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  snapshot.data![index],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        }
      },
    );
  }
}