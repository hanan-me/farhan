import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/Models/candidate.dart';
import 'package:first/auth_controller.dart';
import 'package:first/display_results.dart';
import 'package:first/na.dart';
import 'package:first/na_results_page.dart';
import 'package:first/user_dash.dart';
import 'package:first/voting_results.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SeeAll.dart';
import '/widgets/text_widget.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'guide.dart';

class Home extends StatefulWidget {
  final String? title;
  const Home({super.key, this.title});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedPageIndex = 0;
  String selectedFeature = "ONGOING";
  bool position = true;
  double opacity = 1;
  late final List<Map<String, dynamic>> ppData;

  bool isPPVoteCasted = false;
  bool isNAVoteCasted = false;

  void fetchVoteData() async {
    //fetch data from firestore

    await FirebaseFirestore.instance
        .collection("PP")
        .get()
        .then((value) => {
              for (var i in value.docs)
                {
                  // print(i.data()),
                  ppData.add(i.data()),
                },
            })
        .catchError((onError) {
      print(onError);
    });
  }

  var isElectionStarted = false;
  var announceResult = false;
  bool applied = false;

  String status = "new";

  Future<void> updateKYCStatus() async {
    final prefs = await SharedPreferences.getInstance();

    applied = prefs.getBool("hasApplied") ?? false;
    print("appled: $applied");

    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        status = value.get("status");
      });
    });
  }

  Future<void> checkElectionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isPPVoteCasted = prefs.getBool('isPPVoteCasted') ?? false;
    isNAVoteCasted = prefs.getBool('isNAVoteCasted') ?? false;

    await FirebaseFirestore.instance
        .collection("settings")
        .doc("2E19U8ygCkmLIocvaU0D")
        .get()
        .then((value) {
      setState(() {
        isElectionStarted = value.get("start_election");
        announceResult = value.get("announce_result");
      });
    });
  }

  Future<void> storeNAResult(Map<String, dynamic> data) async {
    try {
      // Access Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a collection named "NA-Result"
      CollectionReference naResultCollection =
          firestore.collection('NA-Result');

      // Create a document with id "NA#79"
      DocumentReference naDocument = naResultCollection.doc('NA#79');

      // Get candidates list and party list
      List<String> candidates = data['Candidates'];
      print(data['Candidates'].length);
      List<String> party = data['Party'];

      // Create documents for each candidate
      for (int i = 0; i < candidates.length; i++) {
        String candidateName = candidates[i];
        String candidateParty = party[i];

        // Create candidate document
        await naDocument.collection('Candidates').doc(candidateName).set({
          'vote_count': 0,
          'party': candidateParty,
          'NA#': 79,
          'name': candidateName,
        });
      }

      print('NA-Result data stored successfully!');
    } catch (e) {
      print('Error storing NA-Result data: $e');
    }
  }

  @override
  void initState() {
    updateKYCStatus();
    checkElectionStatus();
    ppData = [];

    fetchVoteData();

    // print("ppdta: $naData");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: Hero(
      //   tag: "results",
      //   child: GestureDetector(
      //     onTap: () {
      //       Get.to(() => const Displayresults());
      //     },
      //     child: Container(
      //       margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      //       padding: const EdgeInsets.all(10),
      //       decoration: BoxDecoration(
      //         color: Colors.green,
      //         borderRadius: BorderRadius.circular(50),
      //       ),
      //       width: double.infinity,
      //       height: 45,
      //       child: const Row(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           Icon(
      //             Icons.info,
      //             color: Colors.white,
      //           ),
      //           const SizedBox(
      //             width: 5,
      //           ),
      //           Text(
      //             "See Election Results",
      //             style: TextStyle(
      //               color: Colors.white,
      //               fontWeight: FontWeight.w500,
      //               fontSize: 14,
      //             ),
      //           ),
      //           const Spacer(),
      //           Icon(
      //             Icons.arrow_forward,
      //             color: Colors.white,
      //           )
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.model_training),
            label: 'Guide',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_vote),
            label: 'Vote',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            label: 'Results',
          ),


          // BottomNavigationBarItem(
          //   icon: Icon(Icons.stacked_line_chart_outlined),
          //   label: 'Re',
          // ),
        ],
        currentIndex: selectedPageIndex,
        selectedItemColor: Colors.green,
        onTap: (index) {
          setState(() {
            selectedPageIndex = index;
          });
          if (index == 0) {
            // Navigate to Home.dart
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),
            );
          }else if(index == 1){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>  VotingGuidePage(),
              ),
            );
          }
          else if (index == 2) {
            if (status != "approved") {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Your KYC is not approved yet.",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.red,
                ),
              );

              return;
            } else {
              if (!isElectionStarted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Election not started yet.",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeeAll(
                      votingEnabled: isElectionStarted,
                      isPPVoteCasted: isPPVoteCasted,
                      isNAVoteCasted: isNAVoteCasted,
                    ),
                  ),
                );
              }
            }
            // Stay on this page (SeeAll.dart)
          } else if (index == 3) {
            // Navigate to Profile page
            // You can replace 'ProfilePage()' with your actual profile page widget
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const UserDashboard(),
              ),
            );
          }
          else {
            // Navigate to VotingResults.dart
            if (isElectionStarted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Results not announced yet.",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Displayresults(
                    ppData: ppData,
                  ),
                ),
              );
            }
          }
        },
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 30, left: 0, right: 0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget("Hello, there!", 14,
                              Colors.black.withOpacity(.7), FontWeight.normal),
                          TextWidget(widget.title ?? "Chain Vote", 25,
                              Colors.black, FontWeight.bold),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 0,
                ),
                infoWidget(isElectionStarted),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            if (!isElectionStarted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Election not started yet.",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              Get.to(
                                () => VotingResults(
                                  ppData: ppData,
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            //height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),

                              //give the list tile a border radius

                              //leading: const Icon(Icons.how_to_vote),
                              title: const Text("Provincial Assembly"),
                              subtitle: const Text("Check results."),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            if (!isElectionStarted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Election not started yet.",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              // Navigate to Voting.dart
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            // height: 80,
                            decoration: BoxDecoration(
                              color: Colors.orange[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),

                                //give the list tile a border radius

                                // leading: const Icon(Icons.verified),
                                title: const Text("National Assembly"),
                                subtitle: const Text("Check results."),
                                onTap: () => Get.to(
                                      () => const NaResultsPage(),
                                    )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  padding: EdgeInsets.all(20),
                  //height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.how_to_vote,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            "Vote Status",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            " ⚫ Provincial Assembly",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          isPPVoteCasted
                              ? Chip(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide.none,
                                  label: const Text(
                                    "Voted",
                                    style: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                  backgroundColor: Colors.green.withOpacity(.2),
                                )
                              : Chip(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide.none,
                                  label: const Text(
                                    "Not Voted",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                  backgroundColor: Colors.red.withOpacity(.2),
                                ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            " ⚫ National Assembly",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          isNAVoteCasted
                              ? Chip(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide.none,
                                  label: const Text(
                                    "Voted",
                                    style: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                  backgroundColor: Colors.green.withOpacity(.2),
                                )
                              : Chip(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide.none,
                                  label: const Text(
                                    "Not Voted",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                  backgroundColor: Colors.red.withOpacity(.2),
                                ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container infoWidget(bool isElectionStarted) {
    final color = isElectionStarted ? Colors.green : Colors.yellow;
    return Container(
      padding: const EdgeInsets.all(20),
      height: 100,
      decoration: BoxDecoration(
        color: color.withOpacity(.5),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info,
            color: color,
          ),
          const SizedBox(
            width: 10,
          ),
          isElectionStarted
              ? const Text(
                  "Elections are live.\nVote for your favorite candidate.",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                )
              : const Text(
                  "Elections not started yet.\nStay tuned.",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
        ],
      ),
    );
  }
}
