// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'SeeAll.dart';
// import '/widgets/text_widget.dart';
// // import 'Profile.dart';

// class Chat extends StatefulWidget {
//   final AssetImage image;
//   final String name;
//   final String specialist;

//   const Chat({
//     Key? key,
//     required this.image,
//     required this.name,
//     required this.specialist,
//   }) : super(key: key);

//   @override
//   State<Chat> createState() => _ChatState();
// }

// class _ChatState extends State<Chat> {
//   late Size size;
//   var animate = false;
//   var opacity = 0.0;

//   animator() {
//     if (opacity == 0.0) {
//       opacity = 1.0;
//       animate = true;
//     } else {
//       opacity = 0.0;
//       animate = false;
//     }
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       animator();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: AnimatedOpacity(
//           opacity: opacity,
//           duration: const Duration(milliseconds: 400),
//           child: IconButton(
//             icon: Icon(
//               Icons.arrow_back_ios_rounded,
//               color: Colors.black,
//             ),
//             onPressed: () {
//               animator();
//               Timer(const Duration(milliseconds: 600), () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SeeAll(
//                       votingEnabled: true,
//                     ),
//                   ),
//                 );
//               });
//             },
//           ),
//         ),
//         title: AnimatedOpacity(
//           opacity: opacity,
//           duration: const Duration(milliseconds: 400),
//           child: TextWidget("Candidates", 25, Colors.black, FontWeight.bold),
//         ),
//         actions: [
//           AnimatedOpacity(
//             opacity: opacity,
//             duration: const Duration(milliseconds: 400),
//             child: IconButton(
//               icon: Icon(
//                 Icons.search,
//                 color: Colors.black,
//                 size: 25,
//               ),
//               onPressed: () {
//                 // Perform search action here
//               },
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: 20),
//             CircleAvatar(
//               backgroundImage: widget.image,
//               radius: 50,
//             ),
//             SizedBox(height: 20),
//             Text(
//               widget.name,
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text(
//               widget.specialist,
//               style: TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//             SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                 'I am a highly motivated and skilled software engineer with a passion for creating innovative and efficient solutions. With several years of experience in mobile app development, I specialize in Flutter and have successfully delivered complex projects for clients across various industries. My strong problem-solving skills and dedication to continuous learning make me a valuable asset to any development team. In my free time, I enjoy exploring new technologies and contributing to open-source projects.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//             SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () {
//                 _showConfirmationDialog();
//                 // Perform the vote confirmation action here
//               },
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.green, // Set background color to green
//               ),
//               child: Text(
//                 'Confirm Vote',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showConfirmationDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Confirm Vote'),
//           content: Text('Are you sure you want to confirm your vote?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close the dialog
//               },
//               child: Text('No'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Perform the vote confirmation action here
//                 Navigator.pop(context); // Close the dialog
//               },
//               child: Text('Yes'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
