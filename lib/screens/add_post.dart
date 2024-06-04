import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gpt/utils/image_picker.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  final String imageUrl;
  final String username;
  const AddPostScreen({required this.imageUrl, required this.username});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;
  bool _isUploading = false;

  selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a Post"),
            children: [
              SimpleDialogOption(
                child: Text("Take a Photo", style: TextStyle(fontSize: 15)),
                padding: const EdgeInsets.all(20),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                child: Text(
                  "Choose from gallery",
                  style: TextStyle(fontSize: 15),
                ),
                padding: const EdgeInsets.all(20),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(fontSize: 15),
                ),
                padding: const EdgeInsets.all(20),
                onPressed: ()  {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose(){
    super.dispose();
    _descriptionController.dispose();
  }

  Future<void> _uploadImageToFirebase(BuildContext context) async {
    setState(() {
      _isUploading = true;
    });
    try {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
      FirebaseStorage.instance.ref().child('posted/$imageName.jpg');
      UploadTask uploadTask = storageReference.putData(_file!);
      await uploadTask.whenComplete(() async {
        String imageUrl = await storageReference.getDownloadURL();

        // Additional information
        String username = widget.username;
        String userId = FirebaseAuth.instance.currentUser!.uid;
        String postId = FirebaseFirestore.instance.collection('posted').doc().id; // Using the same name as image for simplicity
        String datePublished = DateTime.now().toString();
        String description = _descriptionController.text;

        // Store additional information in Firestore
        await FirebaseFirestore.instance.collection('posted').doc(postId).set({
          'username': username,
          'postId': postId,
          'userId': userId,
          'datePublished': datePublished,
          'description': description,
          'imageUrl': imageUrl,
          'likes': 0,
          'likedBy' : [ ]
        });

        // Show a snackbar to indicate successful upload
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Posted!'),
          duration: Duration(seconds: 2),
        ));
      });
      clearImage();
      // Add any other logic here if needed
    } catch (error) {
      print('Error uploading image: $error');
      // Handle error
    }finally{
      setState(() {
        _isUploading = false;
      });
    }
  }
  void clearImage(){
    _file = null;
  }

  @override
  Widget build(BuildContext context) {
    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
                color: Colors.white,
              ),
              onPressed: () => selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text('Post to'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () {
                    _uploadImageToFirebase(context);
                  },
                  child: const Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                )
              ],
            ),
            body: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isLoading? const LinearProgressIndicator() :
                const Padding(padding: EdgeInsets.only(top: 0)),
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.imageUrl),
                ),
                const Divider(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: TextField(
                    controller: _descriptionController,
                    style: TextStyle(
                      color: Colors.grey
                    ),
                    decoration: InputDecoration(
                      hintText: "Write a Caption...",
                      border: InputBorder.none,
                    ),
                    maxLines: 8,
                  ),
                ),
                SizedBox(
                  height: 45,
                  width: 45,
                  child: AspectRatio(
                    aspectRatio: 500 / 451,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: MemoryImage(_file!),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                      )),
                    ),
                  ),
                ),
                Divider(),
              ],
            ),
          );
  }
}
