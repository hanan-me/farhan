import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/Models/candidate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NaResultsPage extends StatefulWidget {
  const NaResultsPage({super.key});

  @override
  State<NaResultsPage> createState() => _NaResultsPageState();
}

class _NaResultsPageState extends State<NaResultsPage> {
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
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
                                displayTopCandidateOnly: false),
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

  Widget nationalAssemblyWidget(List<Map<String, dynamic>> naData, String title,
      bool displayTopCandidateOnly) {
    // Sort the data by the number of votes for each NA#
    naData.forEach((data) {
      data['candidates'].sort((a, b) => b['votes'].compareTo(a['votes']));
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.withOpacity(.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Voting Results for $title",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            // Loop through the NA# data and display the votes for each candidate
            for (var na in naData)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "NA#${na['naNumber']}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  // Display only the top candidate for each NA# if the flag is true
                  displayTopCandidateOnly
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          na['candidates'][0]["party"],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          na['candidates'][0]["name"],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                        "${na['candidates'][0]['votes']} Votes"),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                LinearProgressIndicator(
                                  value: na['candidates'][0]['votes'] / 100,
                                  backgroundColor: Colors.green.withOpacity(.2),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.green),
                                ),
                              ],
                            ),
                          ),
                        )
                      // Display all candidates for each NA# if the flag is false
                      : Column(
                          children: [
                            for (var candidate in na['candidates'])
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                candidate["party"],
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              Text(
                                                candidate["name"],
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Text("${candidate['votes']} Votes"),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      LinearProgressIndicator(
                                        value: candidate['votes'] / 100,
                                        backgroundColor:
                                            Colors.green.withOpacity(.2),
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class NaPollWidget extends StatelessWidget {
  const NaPollWidget({
    super.key,
    required this.votingResult,
    required this.selectedNA,
    required this.displayTopCandidateOnly,
  });

  final List<Map<String, Candidate>> votingResult;
  final String selectedNA;
  final bool displayTopCandidateOnly;

  @override
  Widget build(BuildContext context) {
    final currNAList = [];
    for (var i in votingResult) {
      if (i.containsKey(selectedNA)) {
        currNAList.add(i);
      }
    }

    //sort the data by the vote count descending
    //and display the poll widget for all the candidates
    currNAList.sort(
        (a, b) => b.values.first.voteCount.compareTo(a.values.first.voteCount));

    int numCandidates = displayTopCandidateOnly ? 1 : currNAList.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: Container(
        padding: const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[100],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //loop through the data and display the votes for each candidate
            //display the name of the candidate, thier party name and the number of votes they have
            for (var i = 0; i < numCandidates; i++)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currNAList[i].values.first.party,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                currNAList[i].values.first.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              Text(
                                "Position: ${i + 1}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.purple,
                                ),
                              ),
                              Text(
                                "Votes: ${currNAList[i].values.first.voteCount}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: currNAList[i].values.first.voteCount / 100,
                        backgroundColor: Colors.green.withOpacity(.2),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
