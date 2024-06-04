import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpt/screens/add_post.dart';
import 'package:gpt/screens/feed_screen.dart';
import 'package:gpt/screens/profile_screen.dart';
import 'package:gpt/screens/search_screen.dart';
import '../icon_routed_pages/profile_page.dart';

class WorkScreen extends StatefulWidget {
  final String imageUrl;
  final String username;

  WorkScreen({required this.imageUrl,required this.username});

  @override
  _WorkScreenState createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  int _selectedIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
     setState(() {
       _selectedIndex = page;
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          children: [
            FeedScreen(profilePicUrl: widget.imageUrl, username: widget.username,),
            SearchScreen(),
            AddPostScreen(imageUrl: widget.imageUrl,username: widget.username,),
            Text('notif'),
            ProfilePage(imageUrl: widget.imageUrl, username: widget.username, uid: '', )
           ],
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: Colors.black,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? Colors.white : Colors.grey,
              ),
              label: '',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _selectedIndex == 1 ? Colors.white : Colors.grey,
              ),
              label: '',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: _selectedIndex == 2 ? Colors.white : Colors.grey,
              ),
              label: '',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: _selectedIndex == 3 ? Colors.white : Colors.grey,
              ),
              label: '',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _selectedIndex == 4 ? Colors.white : Colors.grey,
              ),
              label: '',
              backgroundColor: Colors.black,
            ),
          ],
          onTap: navigationTapped,
        )
    );
  }
}



