import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/mainscreen/homepage.dart';
import 'dart:io';
import 'package:seller_app/widgets/custom_text_field.dart';
import 'package:seller_app/widgets/errordialog.dart';
import 'package:seller_app/widgets/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController confirmpasswordEditingController =
      TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController locationEditingController = TextEditingController();
  XFile? imageXfile;
  String completeaddress = "";
  // ignore: unused_field
  ImagePicker _imagePicker = ImagePicker();

  Future<void> _getImage() async {
    imageXfile = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      // ignore: unnecessary_statements
      imageXfile;
    });
  }

  Position? position;
  List<Placemark>? placemark;
  String sellerimageurl = "";

  getCurrentLocation() async {
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      forceAndroidLocationManager: true,
    );
    position = newPosition;
    placemark = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );
    Placemark pmark = placemark![0];
    completeaddress =
        '${pmark.subThoroughfare} ${pmark.thoroughfare}, ${pmark.subLocality}, ${pmark.locality}, ${pmark.subAdministrativeArea}, ${pmark.administrativeArea}, ${pmark.postalCode}, ${pmark.country}';
    locationEditingController.text = completeaddress;
  }

  Future<void> formValidator() async {
    if (imageXfile == null) {
      return showDialog(
        context: context,
        builder: (e) {
          return ErrorDialog(
            message: "Please select Image.",
          );
        },
      );
    } else if (passwordEditingController.text ==
        confirmpasswordEditingController.text) {
      if (nameEditingController.text.isNotEmpty &&
          passwordEditingController.text.isNotEmpty &&
          confirmpasswordEditingController.text.isNotEmpty &&
          phoneEditingController.text.isNotEmpty &&
          emailEditingController.text.isNotEmpty) {
        //start uploading image
        showDialog(
          context: context,
          builder: (c) {
            return LoadingDialog(
              message: "Registering Account ",
            );
          },
        );
        String filename = DateTime.now().millisecondsSinceEpoch.toString();
        fstorage.Reference reference = fstorage.FirebaseStorage.instance
            .ref()
            .child("Sellers")
            .child(filename);
        fstorage.UploadTask uploadTask =
            reference.putFile(File(imageXfile!.path));
        fstorage.TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() {});
        await taskSnapshot.ref.getDownloadURL().then((url) {
          sellerimageurl = url;
          //save information to database...
          authenticateUser();
        });
      } else {
        return showDialog(
          context: context,
          builder: (e) {
            return ErrorDialog(message: "Please fill all the blanks");
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: "Password do not match",
          );
        },
      );
    }
  }

  void authenticateUser() async {
    // ignore: unused_local_variable
    User? currentUser;
    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailEditingController.text.trim(),
      password: passwordEditingController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: e!.message.toString(),
          );
        },
      );
    });
    if (currentUser != null) {
      saveDataToFiresore(currentUser!).then((value) {
        Route newRoute = MaterialPageRoute(builder: (context) => HomePage());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future saveDataToFiresore(User currentUser) async {
    FirebaseFirestore.instance.collection("Sellers").doc(currentUser.uid).set(
          ({
            "sellerUID": currentUser.uid,
            "sellerEmail": currentUser.email,
            "sellerName": nameEditingController.text.trim(),
            "sellerAvatorUrl": sellerimageurl,
            "phone": phoneEditingController.text,
            "address": completeaddress,
            "status": "approved",
            "earning": 0.0,
            "lat": position!.latitude,
            "long": position!.longitude,
          }),
        );
    //save data locally also.
    SharedPreferences? sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString("uid", currentUser.uid);
    await sharedPreferences.setString(
        "name", nameEditingController.text.trim());
    await sharedPreferences.setString("email", currentUser.email.toString());
    await sharedPreferences.setString("photourl", sellerimageurl);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 20.0,
            ),
            InkWell(
              onTap: () {
                _getImage();
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.20,
                backgroundColor: Colors.white,
                backgroundImage: imageXfile == null
                    ? null
                    : FileImage(
                        File(imageXfile!.path),
                      ),
                child: imageXfile == null
                    ? Icon(
                        Icons.add_a_photo,
                        size: 50.0,
                      )
                    : null,
              ),
            ),
            Form(
              key: _globalKey,
              child: Column(
                children: [
                  CustomTextField(
                    isobsure: false,
                    hintText: "Name",
                    iconData: Icons.person,
                    isenable: true,
                    keytype: TextInputType.name,
                    textEditingController: nameEditingController,
                  ),
                  CustomTextField(
                    isobsure: false,
                    hintText: "Email",
                    iconData: Icons.person,
                    isenable: true,
                    keytype: TextInputType.emailAddress,
                    textEditingController: emailEditingController,
                  ),
                  CustomTextField(
                    isobsure: true,
                    hintText: "Password",
                    iconData: Icons.lock,
                    isenable: true,
                    keytype: TextInputType.name,
                    textEditingController: passwordEditingController,
                  ),
                  CustomTextField(
                    isobsure: true,
                    hintText: "Confirm Password",
                    iconData: Icons.password,
                    isenable: true,
                    keytype: TextInputType.name,
                    textEditingController: confirmpasswordEditingController,
                  ),
                  CustomTextField(
                    isobsure: false,
                    hintText: "Phone Number",
                    iconData: Icons.phone,
                    isenable: true,
                    keytype: TextInputType.number,
                    textEditingController: phoneEditingController,
                  ),
                  CustomTextField(
                    isobsure: false,
                    hintText: "Cafe/Restauaurant Address",
                    iconData: Icons.location_on,
                    isenable: true,
                    keytype: TextInputType.text,
                    textEditingController: locationEditingController,
                  ),
                  Container(
                    width: 400,
                    height: 50,
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.location_on),
                      onPressed: () {
                        getCurrentLocation();
                      },
                      label: Text(
                        "Get Current Location",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25.0,
                        ),
                        primary: Colors.red.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                //Sign Up..
                formValidator();
              },
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 70.0),
                primary: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }
}
