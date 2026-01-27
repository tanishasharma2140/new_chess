import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/app_colors.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/res/text_const.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  XFile? _selectedImage;
  bool _isEditing = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _showImagePickerOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: ChessColor.appBarColor,
          height: Sizes.screenHeight * 0.18,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: ChessColor.white),
                title: const TextConst(title: "Choose from Gallery", color: ChessColor.white),
                onTap: () {
                  _pickImage(ImageSource.gallery, context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: ChessColor.white),
                title: const TextConst(title: "Take a Photo", color: ChessColor.white),
                onTap: () {
                  _pickImage(ImageSource.camera, context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _selectedImage = image;
        _isEditing = true;
      });
    }
    Navigator.pop(context);
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isEditing = false;
    });

    String userId = FirebaseAuth.instance.currentUser!.uid;

    Map<String, dynamic> userData = {
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
    };

    if (_selectedImage != null) {
      try {
        String imagePath = 'user_profiles/$userId.jpg';
        File imageFile = File(_selectedImage!.path);
        UploadTask uploadTask = _storage.ref().child(imagePath).putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();
        userData['profile_picture'] = imageUrl;
      } catch (e) {
        print("Error uploading image: $e");
      }
    }

    try {
      await _firestore.collection('users').doc(userId).update(userData);
      print("Profile updated successfully");
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChessColor.bgGrey,
      appBar: AppBar(
        backgroundColor: ChessColor.appBarColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: ChessColor.white),
        ),
        centerTitle: true,
        title:  TextConst(
          title: "Edit Profile",
          color: ChessColor.white,
          size: Sizes.fontSizeSeven,
          fontWeight: FontWeight.bold,
        ),
        actions: _isEditing
            ? [
          IconButton(
            onPressed: _saveChanges,
            icon: const Icon(Icons.check, color: ChessColor.white),
          ),
        ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                   TextConst(title: "Profile Picture", color: ChessColor.white, size: Sizes.fontSizeSix),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      _showImagePickerOptions();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[700],
                      radius: 40.0,
                      backgroundImage: _selectedImage != null
                          ? FileImage(File(_selectedImage!.path))
                          : null,
                      child: _selectedImage == null
                          ? const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 45.0,
                      )
                          : null,
                    ),
                  ),
                ],
              ),
              Divider(color: ChessColor.black, thickness: Sizes.screenWidth * 0.001),
              const SizedBox(height: 15),
              GestureDetector(onTap: () => {}, child: profileSection("Flair")),
              Divider(color: ChessColor.black, thickness: Sizes.screenWidth * 0.001),
              const SizedBox(height: 15),
              GestureDetector(onTap: () => {}, child: profileSection("Status")),
              Divider(color: ChessColor.black, thickness: Sizes.screenWidth * 0.001),
              const SizedBox(height: 15),
              GestureDetector(onTap: () => {}, child: rowSection("Username", "clara112233")),
              const SizedBox(height: 15),
              Divider(color: ChessColor.black, thickness: Sizes.screenWidth * 0.001),
              editableField("First Name", "Clara", firstNameController),
              Divider(color: ChessColor.black, thickness: Sizes.screenWidth * 0.001),
              editableField("Last Name", "Sinn", lastNameController),
              Divider(color: ChessColor.black, thickness: Sizes.screenWidth * 0.001),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () => {},
                child: Row(
                  children: [
                     TextConst(
                      title: "Country",
                      color: ChessColor.white,
                      size: Sizes.fontSizeSix,
                    ),
                    SizedBox(width: Sizes.screenWidth * 0.12),
                    Row(
                      children: [
                         TextConst(
                          title: "India",
                          color: ChessColor.white,
                          fontWeight: FontWeight.bold,
                          size: Sizes.fontSizeSix,
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          Assets.assetsIndFlag,
                          height: 20,
                        ),
                        SizedBox(width: Sizes.screenWidth * 0.39),
                        const Icon(Icons.arrow_drop_down, color: ChessColor.white),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Divider(color: ChessColor.black, thickness: Sizes.screenWidth * 0.001),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextConst(
          title: title,
          color: ChessColor.white,
          size: Sizes.fontSizeSix,
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget rowSection(String title, String value) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextConst(
            title: title,
            color: ChessColor.white,
            size: Sizes.fontSizeSix,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 7,
          child: TextConst(
            title: value,
            color: ChessColor.white,
            fontWeight: FontWeight.bold,
            size: Sizes.fontSizeSix,
          ),
        ),
      ],
    );
  }

  Widget editableField(String label, String hint, TextEditingController controller) {
    return Row(
      children: [
        TextConst(
          title: label,
          color: ChessColor.white,
          size: Sizes.fontSizeSix,
        ),
        const SizedBox(width: 25),
        Expanded(
          child: TextFormField(
            controller: controller,
            cursorColor: ChessColor.grey,
            style: const TextStyle(color: ChessColor.white),
            onChanged: (value) {
              setState(() {
                _isEditing = true;
              });
            },
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
