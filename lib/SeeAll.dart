import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:first/na.dart';
import 'package:first/user_dash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Dashborad.dart';
import '/widgets/text_widget.dart';
import '/res/lists.dart';
import 'package:csv/csv.dart';

import 'Chat.dart';

class SeeAll extends StatefulWidget {
  final bool votingEnabled;
  final bool isPPVoteCasted;
  final bool isNAVoteCasted;

  const SeeAll(
      {super.key,
      required this.votingEnabled,
      required this.isPPVoteCasted,
      required this.isNAVoteCasted});
  @override
  State<SeeAll> createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  final LocalAuthentication auth = LocalAuthentication();
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  _SupportState _supportState = _SupportState.unknown;

  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  var opacity = 0.0;
  bool position = false;
  int selectedPageIndex = 1;

  bool isCandidateSelected = false;

  var voteTypes = [
    "PP",
    "NA",
  ];

  Map<String, dynamic> finalisedNaNumber = NADATA[0];
  //a function that will check the collection settings and get the value of a boolean value

  void updateNA(String na) {
    switch (na) {
      case "NA#79":
        setState(() {
          finalisedNaNumber = NADATA[0];
        });
        break;

      case "NA#80":
        print("NA#80");
        setState(() {
          finalisedNaNumber = NADATA[1];
        });
        break;

      case "NA#81":
        setState(() {
          finalisedNaNumber = NADATA[2];
        });
        break;

      case "NA#82":
        setState(() {
          finalisedNaNumber = NADATA[3];
        });
        break;

      case "NA#83":
        setState(() {
          finalisedNaNumber = NADATA[4];
        });
        break;

      case "NA#84":
        setState(() {
          finalisedNaNumber = NADATA[5];
        });
        break;

      default:
        setState(() {
          finalisedNaNumber = NADATA[0];
        });
    }
    selectedNA = finalisedNaNumber['Areas'][0].toString().replaceAll("[", "");
    selectedNACandidate =
        finalisedNaNumber['Candidates'][0].toString().replaceAll("[", "");
    print("selected NA in updateNA: $selectedNA");
    print(
        "final na list: ${finalisedNaNumber['Areas'].toString().split(',').map((e) => e.toString().replaceAll("[", ""))}");
    setState(() {});
  }

  var voteTypeSelection = "PP";
  var selctedArea = "Abadi Alama";
  var selctedCandidate = "Imran Khalid Butt";

  //a function that will open a csv file names PP.csv and NA.csv
  //and will return the data in the form of a list

  var selectedNA = "";
  var selectedNACandidate = "";

  Future<Map<String, dynamic>> parseCSVData(String csvData) async {
    try {
      // Split the CSV data into lines
      List<String> lines = csvData.split('\n');
      // print("lines: ${lines.length}");

      // Initialize the result map
      Map<String, dynamic> resultMap = {};

      // Iterate through each line starting from the second line (skipping headers)
      for (int i = 1; i < lines.length; i++) {
        // Split the line by comma
        List<String> parts = lines[i].split('_');
        // print("parts: $parts");

        // Extract data from the parts
        String pp = parts[0];
        String name = parts[1];

        String party = parts[2]; // Remove leading/trailing whitespaces
        /// print("party: $party");

        // Format the data
        Map<String, dynamic> formattedData = {
          'PP': pp,
          'Name': name,
          'Party': party,
          'Areas': areas,
        };

        //print("formatted data: $formattedData");

        // Add the formatted data to the result map
        resultMap[name] = formattedData;
      }

      // Return the result map
      return resultMap;
    } catch (e) {
      // Handle errors
      print('Error parsing line : $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> parseNA(String csvData) async {
    try {
      // Split the CSV data into lines
      List<String> lines = csvData.split('\n');

      // Initialize the result map
      Map<String, dynamic> resultMap = {};

      // Iterate through each line starting from the second line (skipping headers)
      for (int i = 1; i < lines.length; i++) {
        // Skip empty lines
        if (lines[i].trim().isEmpty) continue;

        // Split the line by comma
        List<String> parts = lines[i].split(',');

        // Check if the line has enough parts
        if (parts.length >= 3) {
          // Extract data from the parts
          String pp = parts[0];
          String name = parts[1];
          String party = parts[2].trim(); // Remove leading/trailing whitespaces

          // Format the data
          Map<String, dynamic> formattedData = {
            'NA': pp,
            'Name': name,
            'Party': party,
          };

          // Add the formatted data to the result map
          resultMap[name] = formattedData;
        } else {
          print('Error parsing line $i: Insufficient data');
        }
      }

      // Return the result map
      return resultMap;
    } catch (e) {
      // Handle errors
      print('Error parsing line: $e');
      return {};
    }
  }

  Map<String, dynamic> parsedData = {};
  Map<String, dynamic> parsedNA = {};
  void formatCSVData() async {
    final data = await rootBundle.loadString('assets/PP.csv');

    // Parse the CSV data
    parsedData = await parseCSVData(data);
  }

  var selectedNAValue = "NA#79";

  @override
  void initState() {
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
    _checkBiometrics();
    selectedNA = finalisedNaNumber['Areas'][0].toString().replaceAll("[", "");
    selectedNACandidate = finalisedNaNumber['Candidates'][0].toString();

    print("All candidates: ${finalisedNaNumber['Candidates']}");

    print("selected NA candidate in init state: $selectedNACandidate");

    print(
        "final na list: ${finalisedNaNumber['Areas'].toString().split(',').map((e) => e.toString().replaceAll("[", ""))}");
    formatCSVData();
    super.initState();
  }

  var eligibleNas = [
    "NA#79",
    "NA#80",
    "NA#81",
    "NA#82",
    "NA#83",
    "NA#84",
  ];

  //a function that will save the vote in the firestore
  Future<void> saveVote() async {
    final prefs = await SharedPreferences.getInstance();
    if (voteTypeSelection == "PP") {
      if (widget.isPPVoteCasted == true) {
        Get.snackbar("Vote Casted", "You have already casted your vote for PP",
            colorText: Colors.white, backgroundColor: Colors.red);
        return;
      }
      await FirebaseFirestore.instance
          .collection("PP")
          .doc(selctedCandidate)
          .update({"votes": FieldValue.increment(1)}).then((value) async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Your Vote is Casted Successfully",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }).catchError((onError) {
        Get.snackbar("Error", "Error in casting vote for PP");
      });
    } else {
      if (widget.isNAVoteCasted == true) {
        Get.snackbar("Vote Casted", "You have already casted your vote for NA",
            colorText: Colors.white, backgroundColor: Colors.red);
        return;
      }
      await FirebaseFirestore.instance
          .collection("NA-Result")
          .doc(selectedNAValue)
          .collection("Candidates")
          .doc(selectedNACandidate.toString().trim())
          .update({"vote_count": FieldValue.increment(1)}).then((value) async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Your Vote is Casted Successfully",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
        // await prefs.setBool("isNAVoteCasted", true);
      }).catchError((onError) {
        Get.snackbar("Error", "Error in casting vote");
      });
    }

    if (voteTypeSelection == "PP") {
      await prefs.setBool("isPPVoteCasted", true);
    } else {
      await prefs.setBool("isNAVoteCasted", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    //print("finalised NA: ${finalisedNaNumber['Areas']}");
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cast a Vote"),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: const Icon(Icons.close),
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            //s crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //a dropdown button to select vote type
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select Vote Type"),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    // margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 30,
                      value: voteTypeSelection,
                      onChanged: (newValue) {
                        if (widget.isPPVoteCasted == true && newValue == "PP") {
                          Get.snackbar("Vote Casted",
                              "You have already casted your vote for PP",
                              colorText: Colors.white,
                              backgroundColor: Colors.red);
                          return;
                        }
                        if (widget.isNAVoteCasted == true && newValue == "NA") {
                          Get.snackbar("Vote Casted",
                              "You have already casted your vote for NA",
                              colorText: Colors.white,
                              backgroundColor: Colors.red);
                          return;
                        }
                        setState(() {
                          voteTypeSelection = newValue.toString();
                        });
                      },
                      items: voteTypes.map((valueItem) {
                        return DropdownMenuItem(
                          value: valueItem,
                          child: TextWidget(
                              valueItem, 20, Colors.black, FontWeight.normal),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

              voteTypeSelection == "NA"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        const Text("NA#"),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          // margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            value: selectedNAValue,
                            onChanged: (newValue) {
                              setState(() {
                                selectedNAValue = newValue.toString();
                                // print(finalisedNaNumber['Areas'][0]);
                                //selectedNA = finalisedNaNumber['Areas'][0];
                              });
                              updateNA(selectedNAValue);
                            },
                            items: eligibleNas.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: TextWidget(
                                    e, 18, Colors.black, FontWeight.normal),
                                onTap: () {
                                  setState(() {
                                    selectedNAValue = e;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        const Text("PP#56"),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          // margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            value: "PP#56",
                            onChanged: (newValue) {
                              setState(() {});
                            },
                            items: [
                              DropdownMenuItem(
                                value: "PP#56",
                                child: TextWidget("PP#56", 18, Colors.black,
                                    FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),

              //if (voteTypeSelection == "NA")

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text("Province"),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    // margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 30,
                      value: "Punjab",
                      onChanged: (newValue) {
                        setState(() {});
                      },
                      items: [
                        DropdownMenuItem(
                          value: "Punjab",
                          child: TextWidget(
                              "Punjab", 18, Colors.black, FontWeight.normal),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text("City"),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    // margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 30,
                      value: "Gujranwala",
                      onChanged: (newValue) {
                        setState(() {});
                      },
                      items: [
                        DropdownMenuItem(
                          value: "Gujranwala",
                          child: TextWidget("Gujranwala", 18, Colors.black,
                              FontWeight.normal),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Area"),
                  const SizedBox(
                    height: 10,
                  ),
                  voteTypeSelection == "PP"
                      ? Container(
                          // margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            value: voteTypeSelection == "PP"
                                ? selctedArea
                                : selectedNA,
                            onChanged: (newValue) {
                              setState(() {
                                voteTypeSelection == "PP"
                                    ? selctedArea = newValue.toString()
                                    : selectedNA = newValue.toString();
                              });
                            },
                            items: voteTypeSelection == "PP"
                                ? areas.map((valueItem) {
                                    return DropdownMenuItem(
                                      value: valueItem,
                                      child: TextWidget(valueItem, 16,
                                          Colors.black, FontWeight.normal),
                                    );
                                  }).toList()
                                :
                                //for NA
                                finalisedNaNumber['Areas']
                                    .toString()
                                    .split(',')
                                    .map((valueItem) {
                                    return DropdownMenuItem(
                                      value: valueItem,
                                      child: TextWidget(valueItem, 16,
                                          Colors.black, FontWeight.normal),
                                    );
                                  }).toList(),
                          ),
                        )
                      : Container(
                          // margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            value: selectedNA,
                            onChanged: (newValue) {
                              setState(() {
                                selectedNA = newValue.toString();
                              });
                            },
                            items:
                                //for NA
                                finalisedNaNumber['Areas']
                                    .toString()
                                    .split(',')
                                    .map(
                                        (e) => e.toString().replaceAll("[", ""))
                                    .map((valueItem) {
                              return DropdownMenuItem(
                                value: valueItem,
                                child: TextWidget(valueItem, 16, Colors.black,
                                    FontWeight.normal),
                              );
                            }).toList(),
                          ),
                        )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Candidates"),
                      if (voteTypeSelection == "NA")
                        Chip(
                          color: MaterialStateProperty.all(Colors.green),
                          label: Text(
                            finalisedNaNumber['Candidates'][
                                finalisedNaNumber['Candidates']
                                    .indexOf(selectedNACandidate.trim())],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    // margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 30,
                      value: voteTypeSelection == "PP"
                          ? selctedCandidate
                          : selectedNACandidate,
                      onChanged: (newValue) {
                        print("new value in candidate selection:$newValue");
                        setState(() {
                          voteTypeSelection == "PP"
                              ? selctedCandidate = newValue.toString()
                              : selectedNACandidate = newValue.toString();
                        });
                      },
                      items: voteTypeSelection == "PP"
                          ? parsedData.keys.map((valueItem) {
                              return DropdownMenuItem(
                                value: valueItem,
                                child: TextWidget(
                                    "$valueItem - ${parsedData[valueItem]['Party']}",
                                    16,
                                    Colors.black,
                                    FontWeight.normal),
                              );
                            }).toList()
                          //show the candidate name and party
                          : finalisedNaNumber['Candidates']
                              .toString()
                              .split(",")
                              .map((e) => e.toString().replaceAll("[", ""))
                              .map((valueItem) {
                              return DropdownMenuItem(
                                value: valueItem,
                                child: TextWidget(valueItem.replaceAll("}", ""),
                                    16, Colors.black, FontWeight.normal),
                              );
                            }).toList(),
                      // : finalisedNaNumber['Candidates']
                      //     .toString()
                      //     .split(',')
                      //     .map((e) => e.toString().replaceAll("[", ""))
                      //     .map((valueItem) {
                      //     return DropdownMenuItem(
                      //       value: valueItem,
                      //       child: TextWidget(valueItem.replaceAll("}", ""),
                      //           16, Colors.black, FontWeight.normal),
                      //     );
                      //   }).toList(),
                    ),
                  ),

                  // a button to cast vote
                  const SizedBox(
                    height: 30,
                  ),

                  Center(
                    child: TextButton(
                      //ask for biometric authentication

                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        disabledForegroundColor: Colors.grey.withOpacity(0.38),
                        padding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: size.width * 0.3),
                      ),
                      onPressed: () async {
                        if (_canCheckBiometrics == true) {
                          if (_isAuthenticating == false) {
                            await _authenticateWithBiometrics();
                          }
                        }

                        if (widget.votingEnabled == true) {
                          await saveVote();
                        } else {
                          Get.snackbar(
                              "Voting Disabled", "Voting is disabled for now");
                        }

                        Future.delayed(const Duration(seconds: 1), () {
                          Get.back();
                        });
                      },
                      child: const Text("Cast Vote"),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}

List<String> areas = [
  'Abadi Alama',
  'Abdul',
  'Adeel',
  'Ahsan T',
  'Allah Bux Collony',
  'Arshad T',
  'Asghar Colony',
  'B- Setllite T',
  'Bagoo Wala',
  'Bakhtay Wala',
  'Barri Civil Line',
  'Bazar',
  'Bazar GT',
  'Behaari Colony',
  'Bhabarrian',
  'Block No.2',
  'Bukhari Colony',
  'Cannal',
  'Caperi Colony',
  'Chaman Shah',
  'Chamarra Mandi',
  'Civil Line',
  'Colony',
  'Darbar Hussain Shah',
  'Davi wala T',
  'Dhool Wala',
  'Dispsal Road',
  'Faisal Colony',
  'Feroz wala Road',
  'G.T Road',
  'Gala',
  'Gala Ghulam',
  'Gala Mehar',
  'Gala Mehar Noor',
  'Gali Meeran Shah',
  'Gali No.12',
  'Gali No.12,13',
  'Gali No.29 Irfat',
  'Gali No.8',
  'Gali School Wali',
  'Geer Wali',
  'Ghazi Pura',
  'Ghor Dorr Road',
  'Gulshin, Mumtaz',
  'Haidary Road',
  'Haidery Chowk',
  'Haidery Road',
  'harian',
  'Hashmi Colony',
  'Hussan T',
  'Irfat Colony',
  'Islam Pura',
  'Islampura',
  'Jamia',
  'Jinnah Colony',
  'Jinnah Town',
  'Kachi Dam',
  'Kamboh Colony',
  'Kangani Wala',
  'Kangani Wala',
  'Kangni Wala',
  'Kasera Bazar',
  'Kashmeer Road',
  'Kashmir Colony',
  'Kashmir Road',
  'Kot Abdullah',
  'Madina Town',
  'Main Dina Nagar',
  'Main Sheikhupura',
  'Mandir Bavi wala',
  'Marrian  Road',
  'Mehar Bagoo',
  'Meran G T',
  'Moh.  Bilal',
  'Moh. Salamat',
  'Muhallah',
  'Muhammad',
  'Muhammadi T',
  'Muhammadia',
  'Mujahid Pura',
  'Mujahidpura',
  'Mukhtar',
  'Mukhtar Colony',
  'Mumtaz Colony',
  'Muslim Bazar',
  'Muslim Road',
  'Nasar Roar',
  'Nasir Colony',
  'Nawaz Colony',
  'No.13-20',
  'No.2-9',
  'No.4 Wapda',
  'No.9-13',
  'Parraoo Camp',
  'Pasroor Road',
  'Peoples Colony',
  'Police Line',
  'Raice Course',
  'Rail Bazar',
  'Rana Colony',
  'Rasheed',
  'Rasheed Colony',
  'Rd Pondanwala',
  'Rehman',
  'Rehman Pura',
  'Road Nasir',
  'Road,Rail Bazar',
  'Saddique Colony',
  'Said Nagari',
  'Saithy Palaza',
  'Sarfaraz Colony',
  'Sarfaraz Colony',
  'Shadaman T',
  'Shaheed Colony',
  'Shamas',
  'Shehzada',
  'Sialkoti Gate',
  'Socity',
  'Takbir Road',
  'Thakedar',
  'Thakedar Gal',
  'Thakedar Muslim',
  'Thathiarrian/Manc',
  'Thekedar wala',
  'Therri Sansi',
  'Urfat Colony',
  'Urfat Colony',
  'Wahdat Colony',
  'Wala/Ghulam',
  'W-Block Peoples',
  'Y- Block Peoples',
  'Y-Block Peoples',
  'Z-Block Gali',
  'Z-Block Gali No.2',
  'Z-Block Gali Z to',
];

List<String> NAs = [
  'ABBDULLAH PUR',
  'ABIDABAD',
  'ALLAH DITTA',
  'ARGAN',
  'AUDHO RAI (QILA NOHID SINGH)',
  'AULAKH BHAIKE',
  'BABBAR',
  'BADDO RATTA',
  'BADDOKE',
  'BAHMANIAN',
  'BAKHSHISH PURA',
  'BALLOKI',
  'BARI WALA',
  'BATH',
  'BAWRE PIARA',
  'BEIG PUR',
  'BHADDAR',
  'BHADE',
  'BHAN PUR',
  'BHANGWAN',
  'BHARAIAN',
  'Bhiri Kalan',
  'Bhiri Khurd',
  'BHUND',
  'BOGA',
  'BOPRA KALAN',
  'BOPRA KHURD',
  'BUDHA CHANDU',
  'BUDHA GORAYA',
  'CHABBA SANDHWAN',
  'CHACHOKE',
  'CHADIALA KALAN',
  'CHAK AYAH',
  'CHAK BAHLOL',
  'CHAK CHATHA',
  'CHAK CHOHAR',
  'CHAK DUNI CHAND',
  'CHAK GHOSIA',
  'CHAK MARALI',
  'CHAK PAKHAR',
  'CHAK RAJADA',
  'CHAK SADU',
  'CHAK UMAR',
  'CHAK VIRKAN',
  'CHANDANIAN',
  'CHANDHAR',
  'CHAUDHRI',
  'CHELEKE',
  'CHIAN WALI',
  'CHIANWALI',
  'DEHR VIRKAN',
  'DERA SHAH JAMAL',
  'DHALLA',
  'DHAPAI WASAKH SINGH',
  'DHARIWAL',
  'DHAROKE',
  'DHERAM KOT',
  'DHILANWALI',
  'DHILLU BASHA',
  'DIPEPUR',
  'DOBURJI',
  'DOGRAN WALA',
  'DOGRAN WALA MALIAN',
  'DUCHHA',
  'EMINABAD T.C. (MIRZA COLONY, BEROON DAMDAMA, CIRCULAR ROAD)',
  'EMINABAD T.C. (MOH. BHINDRIAN/MO H. KAKKY ZIAN)',
  'EMINABAD T.C. (MOH. GUJRAN, BEROON UNCHA KHOLA)',
  'EMINABAD T.C. (MOH. HUDAIBIA COLONY, MOH. RORI SAHIB)',
  'EMINABAD T.C. (MOH. ISLAMABAD, PUL WALA IDARA SHAMAL , MADINA HOSPITAL)',
  'EMINABAD T.C. (MOH. JINNAH COLONY, NAI ABADI TAIL PURA)',
  'EMINABAD T.C. (MOH. KHUDIAN, BEROON QAZI DARWAZA/SAID PURA SHARQI',
  'EMINABAD T.C. (MOH. NIKKI MANDI, UNCHA KHOLA/MOH. SAID PURA)',
  'EMINABAD T.C. (MOH. NIKKI MANDI/MOH. KACTCHEHRI)',
  'EMINABAD T.C. (TAJ CHOWK CHUNGI NO. 1, REHMAN COLONY)',
  'FATEH WALA',
  'FATEHKI',
  'GARMULA VIRKAN',
  'GHAIBI',
  'GHUMMAN WALA',
  'GODHA',
  'GOHRI',
  'GOPI RAI',
  'GORAYA',
  'HAMBOKE',
  'HARAR',
  'HARCHOKI',
  'HARDO KULLEWALA',
  'HARDO MUGHAL CHAK',
  'Hardo Udday',
  'HARDO UDDE',
  'HARLAN WALI KOT MAND',
  'HARPAL BHATTI',
  'Islam Pura BHADE',
  'JAGOWALA',
  'JAGOWALA(Dhondianwala)',
  'JAHLAN',
  'JAJOKE',
  'JHALIAN WALA',
  'JOGI WALA',
  'KAHLWAN',
  'KALSIAN',
  'KARIAL KALAN',
  'KARIAL KHURD',
  'KASSOKI',
  'KAULO WALA',
  'KHAN MUSLMAN',
  'KHAN PIARA',
  'KHARA',
  'KHARK',
  'KHAWASRA',
  'KHOKHRAN',
  'KHURD',
  'KIRAN WALI',
  'KOHLOWALA',
  'KOROTANA',
  'KOT ABDUL MALIK',
  'KOT BAQAR',
  'KOT BHANU SHAH',
  'KOT BHUTTA',
  'KOT CHAND',
  'KOT KARAM CHAND',
  'KOT LADHA',
  'KOT LAJJA RAM',
  'KOT LALA',
  'KOT MAITLA',
  'KOT MARI',
  'KOT NISAR',
  'KOT PURIAN',
  'KOT SHERA',
  'KOTLI MAHIL',
  'KOTLI MANO SINDHU',
  'KOTLI MANSU',
  'KOTLI SAIB SINGH',
  'KURALKE',
  'KURAR',
  'KUTHIALI',
  'LALA PUR',
  'LANDE SHARIF',
  'LANJ',
  'LAUNKE',
  'LIL',
  'LUDHAR MUSLIM',
  'MACHARAN WALI',
  'MADAN CHAK',
  'MAHAR',
  'MAHESIAN THATHA',
  'MAHIA',
  'MAHIL',
  'MAJHU CHAK',
  'MAKE WALI',
  'MALIAN',
  'MANAN CHAK',
  'MANDIALA MIR SHIKARAN',
  'MANGOKI VIRKAN',
  'MANJ WALI',
  'MARALI WALA',
  'MARI BHINDRAN',
  'MARI KHURD',
  'MARWAIN KALAN',
  'MARWAIN KHURD',
  'MASANDA',
  'MASWANI',
  'MATA VIRKAN',
  'MATTO BHAI KE',
  'MATTU BHANOKE',
  'MEHLO WALA',
  'MEHLO WALA MAQBOOL SHAHEED ABAD',
  'MELO',
  'MISRI MAINI',
  'NADDU SARAI',
  'NAND PUR',
  'NANGRAY DADAN',
  'NAROKE',
  'NATHO SOAYA',
  'NAUKARIAN',
  'NOKHAR',
  'Noshera Virkan M.C (Baddo Ratta Road Moh. Muslim Town)',
  'Noshera Virkan M.C (Masjid Quba Moh. Awan Town)',
  'Noshera Virkan M.C (Moh. Baddo Ratta Road, Moh. Madina Masijid',
  'Noshera Virkan M.C (Moh. Civil Hospital)',
  'Noshera Virkan M.C (Moh. Farooq Ganj)',
  'Noshera Virkan M.C (Moh. Hussain Abad, Chand Colony)',
  'Noshera Virkan M.C (Moh. Islam Pura)',
  'Noshera Virkan M.C (Moh. Islamabad, Baath, Chand Colony)',
  'Noshera Virkan M.C (Moh. Muhammad Pura)',
  'Noshera Virkan M.C (Moh. Purana Committee Ghar)',
  'Noshera Virkan M.C (Moh. Rarwala)',
  'Noshera Virkan M.C (Moh. Rehman Pura)',
  'Noshera Virkan M.C (Moh. Saman Abad)',
  'Noshera Virkan M.C (Moh. Shaheen Abad, Islamabad, Baath)',
  'Noshera Virkan M.C (Moh. Sheikhan wala)',
  'Noshera Virkan M.C (Moh. Shumali Masjid)',
  'Noshera Virkan M.C (Moh. Tatley Aali Road)',
  'NUR PUR',
  'PAGALA',
  'PALANG PUR',
  'PANJGRIAN',
  'PHAMA SARAI',
  'PHILOKI',
  'PHILOKI KALAN',
  'PHOKAR PUR',
  'PINDORIAN',
  'PIPLI GORAYA',
  'PIRTHI PUR (FAZIL ABAD)',
  'POOHLA',
  'PURAN PUR',
  'QAID ABAD',
  'QASIMPUR',
  'QILA BATH',
  'QILA BHAYYAN',
  'QILA DESU SINGH',
  'QILA DIWAN SINGH',
  'QILA JAGGO',
  'QILA MAJJA SINGH',
  'QILA MIAN SINGH',
  'QILA MUSTAFABAD',
  'RAKH MIRO',
  'RAKH SIRAN WALI',
  'RAM GAHR',
  'RANDHIAR',
  'RATTA DHUTAR',
  'RATTA GORAYA',
  'RATTOKI',
  'RUKHE',
  'SADHO GORAYA',
  'SADHOKE',
  'SAGO BHAGO',
  'SAHOKE',
  'SAPRAI',
  'SEICH',
  'SHAH',
  'SHAH PUR',
  'SHAMSA DHADDA',
  'SHARQI',
  'SURAT ABAD',
  'TARI WALA',
  'TATLE AALI',
  'TATLE HAKIM HAIDER ALI',
  'TATLEY MALI',
  'TAUNG KALAN',
  'TAUNG KHURD',
  'THABAL',
  'THATHA CHALWA',
  'THATHA PANJ HATHA',
  'Thatha Qutba',
  'THATTA MANAK',
  'THATTA RAJIAN',
  'THERI GILLAN',
  'TOOR',
  'TUNGANWALI',
  'UDHO WALI',
  'UJAN CHAK',
  'WADHAWAN',
  'WANDALA VIRKAN',
  'ZAFARABAD'
];

Future<void> storeNAResult(Map<String, dynamic> data) async {
  try {
    // Access Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a collection named "NA-Result"
    CollectionReference naResultCollection = firestore.collection('NA-Result');

    // Create a document with id "NA#79"
    DocumentReference naDocument = naResultCollection.doc('NA#79');

    // Get candidates list and party list
    List<String> candidates = data['Candidates'];
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
