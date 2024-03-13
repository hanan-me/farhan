import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/auth/Login_Page.dart';
import 'package:first/edit_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Dashborad.dart';
import 'SeeAll.dart';
import 'auth_controller.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  var opacity = 0.0;
  bool position = false;
  String selectedFeature = '';
  int selectedPageIndex = 1;
  var isLoading = false;
  String status = "new";

String address = '';


  void saveAddress() {
    // Here, you can save the address to the desired location
    // For example, you can save it to a database or use it for other purposes
    print('Address saved: $address');
  }
  Future<void> updateKYCStatus() async {
    prefs = await SharedPreferences.getInstance();
    applied = prefs.getBool("hasApplied") ?? false;
    print("appled: $applied");
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        status = value.get("status");

        isLoading = false;
      });
    });
  }

  late final SharedPreferences prefs;
  bool applied = false;

  @override
  void initState() {
    print("init state called");
    updateKYCStatus();

    super.initState();
  }

  void applyForVerification() async {
    // if (prefs.getBool("hasApplied") == true &&
    //     (status != "approved" || status != "new")) {
    //   Get.snackbar(
    //     "KYC Status",
    //     "You have already applied for KYC",
    //     colorText: Colors.white,
    //     backgroundColor: Colors.red,
    //   );
    //   return;
    // }

    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"status": "new"}).then((value) {
      //set the status in shared preferences
      prefs.setBool("hasApplied", true);
      setState(() {
        applied = true;
        status = "new";
      });
      //show a snackbar
      Get.snackbar(
        "KYC Status",
        "You've successfully applied for KYC",
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Get.find<AuthController>().currUser.value;
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(),
                )),
            icon: const Icon(Icons.arrow_back, color: Colors.greenAccent)),
        title: const Text("Profile"),
      ),
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.green,
            ))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: const EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  children: [
                    SizedBox(
                      height: h * 0.012,
                    ),
                    Container(
                      width: 130,
                      height: h * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: const DecorationImage(
                          image: AssetImage(
                            "assets/images/Person.png",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      "${user!.fname} ${user.lname}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      height: h * 0.012,
                    ),
                    Text(
                      "${user.email}",
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: h * 0.035,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const EditProfile());
                      },
                      child: Container(
                          width: w * 0.45,
                          height: h * 0.06,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  spreadRadius: 4,
                                  offset: const Offset(1, 1),
                                  color: Colors.green.withOpacity(.7),
                                )
                              ],
                              gradient: const LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.green,
                                  Colors.green,
                                ],
                              )
                              // image: DecorationImage(
                              //   image: AssetImage(
                              //       "img/btn.jpg"
                              //   ),
                              //   fit: BoxFit.cover,
                              // )
                              ),
                          child: const Center(
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: h * 0.05,
                    ),
                    isLoading
                        ? const CircularProgressIndicator()
                        : Card(
                            child: ListTile(
                              //tileColor: Colors,
                              title: const Text("KYC Status"),
                              trailing: !applied
                                  ? GestureDetector(
                                      onTap: () {
                                        applyForVerification();
                                      },
                                      child: Chip(
                                        label: const Text("Apply for KYC"),
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        side: BorderSide.none,
                                      ),
                                    )
                                  : status == "new"
                                      ? Chip(
                                          label: const Text("Pending"),
                                          backgroundColor: Colors.orange,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          side: BorderSide.none,
                                        )
                                      : status == "approved"
                                          ? Chip(
                                              label: const Text("Approved"),
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              side: BorderSide.none,
                                            )
                                          : Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    applyForVerification();
                                                  },
                                                  child: Chip(
                                                    label:
                                                        const Text("Re Apply"),
                                                    backgroundColor:
                                                        Colors.blue,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    side: BorderSide.none,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Chip(
                                                  label: const Text("Rejected"),
                                                  backgroundColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  side: BorderSide.none,
                                                ),
                                              ],
                                            ),
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    // for user wallet's address 
                    Padding(
  padding: const EdgeInsets.symmetric(vertical: 20),
  child: TextFormField(
    decoration: InputDecoration(
      labelText: "Enter your wallet's address",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: Colors.white,
          width: 1.0,
        ),
      ),
    ),
    onChanged: (value) {
      setState(() {
        address = value;
      });
    },
    validator: (value) {
      if (value!.trim().length <= 40) {
        return 'Please enter a valid address!';
      }
      return null;
    },
  ),
),
ElevatedButton(
  onPressed: () {
    if (address.length > 40) {
      // Save address and show snackbar if validation passes
      saveAddress();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your address submitted successfully'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your valid wallet address'),
        ),
      );
    }
  },
  child: const Text('Submit'),
),


 const SizedBox(
                      height: 20,
                    ),
                    ProfileManage(
                        title: "Logout",
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        color: Colors.red,
                        endIcon: false,
                        onPress: () {
                          FirebaseAuth.instance.signOut().then((value) {
                            Get.offAll(const LoginPage());
                          });
                        }),
                  ],
                ),
              ),
            ),
    );
  }
}

class ProfileManage extends StatelessWidget {
  const ProfileManage({
    Key? key,
    required this.title,
    required this.icon,
    this.endIcon = true,
    required this.onPress,
    required this.color,
  }) : super(key: key);
  final String title;
  final Widget icon;
  final bool endIcon;
  final Color color;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: color.withOpacity(0.1),
        ),
        child: icon,
      ),
      title: Text(title),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: color.withOpacity(0.1),
              ),
              child: Icon(Icons.keyboard_arrow_right,
                  color: color.withOpacity(.6)),
            )
          : null,
    );
  }
}
