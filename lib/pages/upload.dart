import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/models/user.dart';
import 'package:flutter_social_app/widgets/progress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;

class Upload extends StatefulWidget {
  final User currentUser;

  const Upload({Key key, this.currentUser}) : super(key: key);
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final StorageReference storageRef = FirebaseStorage.instance.ref();
  final postsRef = Firestore.instance.collection('posts');
  TextEditingController captionController = TextEditingController();
  File file;
  bool isUploading = false;
  String postId = Uuid().v4();

  handleTakePicture() async {
    // final picker = ImagePicker();

    // final pickedFile = await picker.getImage(
    //   source: ImageSource.camera,
    //   preferredCameraDevice: CameraDevice.rear,
    //   maxHeight: 675,
    //   maxWidth: 960,
    // );
    File picked = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      file = picked;
    });
    Navigator.pop(context);
  }

  handleChoosefromGallery() async {
    // final picker = ImagePicker();
    // final pickedFile = await picker.getImage(
    //   source: ImageSource.gallery,
    // );
    // setState(() {
    //   file = File(pickedFile.path);
    // });
    File picked = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      file = picked;
    });
    Navigator.pop(context);
  }

  selectImage(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('create post'),
            children: [
              SimpleDialogOption(
                onPressed: handleTakePicture,
                child: Text('take a picture'),
              ),
              SimpleDialogOption(
                onPressed: handleChoosefromGallery,
                child: Text('from gallery'),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('cancel'),
              )
            ],
          );
          // return AlertDialog(
          //   title: Text("Material Dialog"),
          //   content: Text("Hey! I'm Coflutter!"),
          //   actions: <Widget>[
          //     ElevatedButton(
          //       child: Text('Close me!'),
          //       onPressed: () {
          //         Navigator.of(context).pop();
          //       },
          //     ),
          //     ElevatedButton(
          //       onPressed: () {},
          //       child: Text('from gallery'),
          //     ),
          //     ElevatedButton(
          //       onPressed: () {},
          //       child: Text('take a picture'),
          //     ),
          //   ],
          // );
        });
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
        storageRef.child("post_$postId.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  createPostInFirestore(
      {String mediaUrl,
      String location,
      String description,
      DateTime timestamp}) {
    postsRef
        .document(widget.currentUser.id)
        .collection("userPosts")
        .document(postId)
        .setData({
      "postId": postId,
      "ownerId": widget.currentUser.id,
      "username": widget.currentUser.username,
      "mediaUrl": mediaUrl,
      "description": description,
      "timestamp": timestamp,
      "likes": {},
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });

    String mediaUrl = await uploadImage(file);
    createPostInFirestore(
      mediaUrl: mediaUrl,
      description: captionController.text,
    );
    captionController.clear();

    setState(() {
      file = null;
      isUploading = false;
      postId = Uuid().v4();
    });
  }

  Widget buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: clearImage,
        ),
        title: Text('caption post'),
        actions: [
          TextButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: Text('post'),
          )
        ],
      ),
      body: ListView(
        children: [
          isUploading ? linearProgress() : Text(""),
          Container(
            height: 220,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(file),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                widget.currentUser.photoUrl,
              ),
            ),
            title: Container(
              child: TextField(
                controller: captionController,
                decoration: InputDecoration(
                    hintText: 'description..', border: InputBorder.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSplahcScreen() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Text('Upload picture',
                      style: TextStyle(color: Colors.white, fontSize: 25)),
                ),
                onTap: () => {selectImage(context)}),
          ),
        ],
      ),
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return file == null ? buildSplahcScreen() : buildUploadForm();
  }
}
