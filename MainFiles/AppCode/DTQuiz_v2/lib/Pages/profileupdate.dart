import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/Profile.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/Utils/Utility.dart';
import 'package:quizapp/Utils/sharepref.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/widget/myappbar.dart';
import 'package:quizapp/widget/myimage.dart';
import 'package:quizapp/widget/mynetimage.dart';
import 'package:quizapp/widget/mytext.dart';

bool topBar = false;

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({Key? key}) : super(key: key);

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? profilePic;
  XFile? _image;
  String? userId;
  SharePref sharePref = SharePref();

  _imgFromCamera() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title:  MyText(title: 'Photo Library',maltilanguage: false,),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title:  MyText(title: 'Camera', maltilanguage:false ),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  initState() {
    getUserId();
    super.initState();
  }

  getUserId() async {
    userId =Constant.userID ?? "";
    debugPrint('userID===>${userId.toString()}');

    final profiledata = Provider.of<ApiProvider>(context, listen: false);
    profiledata.getProfile(context, Constant.userID ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return buildProfile();
  }

  buildProfile() {
    return Scaffold(
      backgroundColor: appBgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/dash_bg.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(50.0, 50.0)),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getAppbar(),
                  buildHeader(),
                ],
              ),
            ]),
            buildData(),
          ],
        ),
      ),
    );
  }

  getAppbar() {
    return const MyAppbar(title: "editprofile");
  }

  buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                _showPicker(context);
              },
              child: Consumer<ApiProvider>(
                builder: (context, profile, child) {
                  return Opacity(
                    opacity: 0.5,
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.file(
                              File(_image!.path),
                              width: 120,
                              height: 120,
                              fit: BoxFit.fill,
                            ),
                          )
                        : (profile.profileModel.result?[0].profileImg
                                        .toString() ??
                                    "")
                                .isEmpty
                            ? MyImage(
                                imagePath: 'assets/images/ic_user_default.png',
                                width: 120,
                                height: 120,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: MyNetImage(
                                    width: 120,
                                    height: 120,
                                    imagePath: profile
                                            .profileModel.result?[0].profileImg
                                            .toString() ??
                                        ""),
                              ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ]),
          Positioned(
              child: InkWell(
            onTap: () {
              _showPicker(context);
            },
            child: MyImage(
              imagePath: 'assets/images/ic_camera.png',
              height: 70,
            ),
          ))
        ],
      ),
    );
  }

  buildData() {
    return Consumer<ApiProvider>(
      builder: (context, profiledata, child) {
        _nameController.text =
            profiledata.profileModel.result?[0].fullname.toString() ?? "";
        _emailController.text =
            profiledata.profileModel.result?[0].email.toString() ?? "";
        _contactController.text =
            profiledata.profileModel.result?[0].mobileNumber.toString() ?? "";
        _addressController.text =
            profiledata.profileModel.result?[0].biodata.toString() ?? "";

        profilePic =
            profiledata.profileModel.result?[0].profileImg.toString() ?? "";


        return Container(
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                formField("name", "assets/images/ic_profile_user.png",
                    _nameController),
                formField("email", "assets/images/ic_profile_email.png",
                    _emailController),
                formField("contectno", "assets/images/ic_profile_contact.png",
                    _contactController),
                formField("address", "assets/images/ic_profile_address.png",
                    _addressController),
                const SizedBox(height: 40),
                Center(
                  child: TextButton(
                      onPressed: () {
                        updateProfile();
                      },
                      style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(200, 50)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(28.0))),
                          backgroundColor: MaterialStateProperty.all(appColor)),
                      child: MyText(
                        maltilanguage: true,
                        title: 'save',
                        size: 18,
                        fontWeight: FontWeight.w500,
                        colors: white,
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  formField(String title, String iconpath, var contl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        MyText(
          maltilanguage: true,
            title: title,
            size: 16,
            fontWeight: FontWeight.w500,
            colors: black),
        const SizedBox(height: 5),
        TextField(
          controller: contl,
          decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  iconpath,
                  height: 10,
                  width: 10,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[600]),
              hintText: title,
              fillColor: Colors.white70),
        ),
      ],
    );
  }

  updateProfile() async {
    if (_nameController.text.isEmpty) {
      Utility.toastMessage("Please enter your name");
      return;
    }
    if (_emailController.text.isEmpty) {
      Utility.toastMessage("Please enter your email");
      return;
    }
    if (_contactController.text.isEmpty) {
      Utility.toastMessage("Please enter your contact number");
      return;
    }
    if (_addressController.text.isEmpty) {
      Utility.toastMessage("Please enter your address");
      return;
    }
    if (_image == null) {
      Utility.toastMessage("Please select profile picture");
      return;
    }

    var image = File(_image!.path);
    debugPrint('===>path ${_image!.path}');

    var update = Provider.of<ApiProvider>(context, listen: false);

    await update.getUpdateProfile(
        userId,
        _nameController.text.toString(),
        _emailController.text.toString(),
        _contactController.text.toString(),
        _addressController.text.toString(),
        image);

    if (!update.loading) {
      if (update.successModel.status == 200) {
        Utility.toastMessage(update.successModel.message.toString());
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Profile()));
      } else {
        Utility.toastMessage(update.successModel.message.toString());
      }
    }
  }
}
