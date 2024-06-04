import 'package:flutter/material.dart';

import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {

  final String imageUrl;
  ProfileScreen({super.key, required this.imageUrl});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('username'),
        centerTitle: false,
      ),
      body: ListView(
        children:  [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        widget.imageUrl
                      ),
                      radius: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                               buildStateColumn(20, "posts"),
                              buildStateColumn(150, "followers"),
                              buildStateColumn(10, "following"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FollowButton(function: () {  },
                                text: 'Edit Profile',
                                borderColor: Colors.grey,
                                textColor: Colors.white,
                                backgroundColor: Colors.black,)
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    top: 15
                  ),
                  child: Text('username',style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                      top: 1
                  ),
                  child: Text('Some description',style: TextStyle(
                      color: Colors.white
                  ),),
                ),
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }
  Column buildStateColumn(int num, String label){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),

        Container(
          margin: const EdgeInsets.only(top: 4,right: 16),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
                color: Colors.white
            ),
          ),
        )
      ],
    );
  }
}
