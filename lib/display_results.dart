import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/Models/candidate.dart';
import 'package:first/na_results_page.dart';
import 'package:flutter/material.dart';

import 'voting_results.dart';

class Displayresults extends StatefulWidget {
  final List<Map<String, dynamic>> ppData;

  const Displayresults({super.key, required this.ppData});

  @override
  State<Displayresults> createState() => _DisplayresultsState();
}

class _DisplayresultsState extends State<Displayresults> {
  bool isLoading = false;

  var eligibleNas = [
    "NA#79",
    "NA#80",
    "NA#81",
    "NA#82",
    "NA#83",
    "NA#84",
  ];
  var selectedNA = "NA#79";

  final List<Map<String, Candidate>> votingResult = [];

  final List<Map<String, Candidate>> topThreeCandidates = [];

  @override
  void initState() {
    fetchVotingResults();
    super.initState();
  }

  void fetchVotingResults() async {
    setState(() {
      isLoading = true;
    });
    for (var na in eligibleNas) {
      await FirebaseFirestore.instance
          .collection("NA-Result")
          .doc(na)
          .collection("Candidates")
          .get()
          .then(
            (value) => {
              for (var i in value.docs)
                {
                  // print(i.data()),
                  votingResult.add({na: Candidate.fromDocument(i.data())}),
                },
              //getTopThreeCandidates(votingResult, selectedNA),
              setState(() {
                isLoading = false;
              })
            },
          )
          .catchError((error) => {
                print("Error fetching voting results: $error"),
                setState(() {
                  isLoading = false;
                })
              });
    }

    print(votingResult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Election Winners'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 220,
            child: PollWidget(
                ppData: widget.ppData,
                title: "PP",
                displayTopCandidateOnly: true),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "National Assembly Results",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        onPressed: () {
                          fetchVotingResults();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.green,
                        ),
                      ),
                    )
                  ],
                ),
                // horizontal lis
                //t view to display chips
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: eligibleNas
                          .map(
                            (na) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedNA = na;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: selectedNA == na
                                      ? Colors.green
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  na,
                                  style: TextStyle(
                                    color: selectedNA == na
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: Colors.green,
                      ))
                    : Container(
                        margin: const EdgeInsets.only(left: 0, right: 0),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                "Voting Results for $selectedNA",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            //sort the data by the vote count descending
                            //and display the poll widget for all the candidates
                            NaPollWidget(
                              votingResult: votingResult,
                              selectedNA: selectedNA,
                              displayTopCandidateOnly: true,
                            ),
                          ],
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
