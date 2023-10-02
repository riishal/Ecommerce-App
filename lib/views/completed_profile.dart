import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/user_model.dart';
import 'package:ecommerce_app/service/ui_helper.dart';
import 'package:ecommerce_app/views/Homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:image_picker/image_picker.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfile(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  File? imageFile;
  TextEditingController fullNameController = TextEditingController();

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? cropedImage = await ImageCropper.platform.cropImage(
      sourcePath: file.path,
      // aspectRatio: CropAspectRatio(
      //   ratioX: 1,
      //   ratioY: 1,
      // ),
      // compressQuality: 20
    );
    if (cropedImage != null) {
      setState(() {
        imageFile = File(cropedImage.path);
      });
    }
  }

  void showPhotoOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upload Profile Picture'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            onTap: () {
              selectImage(ImageSource.gallery);
              // pickImageFromGallery();
              Navigator.pop(context);
            },
            leading: Icon(Icons.photo_album),
            title: Text('Select from gallery'),
          ),
          ListTile(
            onTap: () {
              selectImage(ImageSource.camera);
              // selectImageFromCamera();
              Navigator.pop(context);
            },
            leading: Icon(Icons.camera),
            title: Text('Take a Photo'),
          )
        ]),
      ),
    );
  }

  void checkValues() {
    String fullname = fullNameController.text.trim();
    if (fullname == "" || imageFile == null) {
      UIHelper.showAlertDialog(context, "Incomplite Data",
          "Please fill all the fields and upload a profile picture");
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    UIHelper.showLoadingDialog(context, "Loading...");
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepictures")
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    String fullname = fullNameController.text.trim();
    widget.userModel.fullName = fullname;
    widget.userModel.profilepic = imageUrl;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      print('Data Uploaded');
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(
                userModel: widget.userModel, firebaseUser: widget.firebaseUser),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.black),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "Complete Profile",
              style: GoogleFonts.abhayaLibre(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(
              height: 28,
            ),
            Stack(
              children: [
                CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        imageFile != null ? FileImage(imageFile!) : null,
                    radius: 70,
                    child: imageFile == null
                        ? Icon(
                            Icons.person,
                            color: Colors.grey[400],
                            size: 90,
                          )
                        : null),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: IconButton(
                        onPressed: () {
                          showPhotoOptions();
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        )),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                height: size.height * 0.074,
                width: size.width * 0.89,
                child: TextFormField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      hintText: "Full Name",
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ))),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: () {
                    checkValues();
                  },
                  child: Text(
                    "Submit",
                    style: GoogleFonts.abhayaLibre(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),
            ),
          ],
        ),
      )),
    );
  }
}
