import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
import 'getStarted.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: h*0.33,),
          Center(
            child: Container(
              // margin: const EdgeInsets.symmetric(vertical: 10),
              width: w*0.9,
              height: h*0.29,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/log1.png"
                    ),
                    fit: BoxFit.cover,
                  )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: w*0.65,top: h*0.2),
            child: GestureDetector(
              onTap: (){
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => GetStarted()));
              },
              child: Container(
                  width: w*0.18,
                  height: h*0.035,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Skip>>",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
