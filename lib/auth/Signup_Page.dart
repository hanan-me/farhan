import 'package:cnic_scanner/cnic_scanner.dart';
import 'package:cnic_scanner/model/cnic_model.dart';
// import 'package:flutter/src/material/dropdown.dart';
import 'package:first/auth/validate.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'Login_Page.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final numberController = TextEditingController();
  final cnicController = TextEditingController();
  final nationalityController = TextEditingController(text: "Pakistani");
  final lastnameController = TextEditingController();
  final firstnameController = TextEditingController();
  String _selectedOption = 'Adsf';
  final _formKey = GlobalKey<FormState>();

  // List<String> cniccheck = [
  //   "12345",
  //   "54321",
  //   "24689",
  //   // Add more CNIC numbers as needed
  // ];

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());

    List images = ["g.png", "f.png"];
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    var _value = "-1";
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 0),
                  width: 250,
                  height: 150,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/log1.png"),
                          fit: BoxFit.cover)),
                ),
                Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Register your account",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          onPressed: () async {
                            // CnicModel _cnicModel = CnicModel();

                            // final result = await CnicScanner()
                            //     .scanImage(imageSource: ImageSource.gallery);

                            // firstnameController.text =
                            //     result.cnicHolderName.split(" ")[0];
                            // lastnameController.text =
                            //     result.cnicHolderName.split(" ")[1];
                            // cnicController.text = result.cnicNumber;

                            //show dialog to select image from gallery or camera
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Select Image"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        title: const Text("Camera"),
                                        onTap: () async {
                                          final result = await CnicScanner()
                                              .scanImage(
                                                  imageSource:
                                                      ImageSource.camera);

                                          firstnameController.text =
                                              result.cnicHolderName.split(" ")[0];
                                          lastnameController.text =
                                              result.cnicHolderName.split(" ")[1];
                                          cnicController.text = result.cnicNumber;

                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        title: const Text("Gallery"),
                                        onTap: () async {
                                          final result = await CnicScanner()
                                              .scanImage(
                                                  imageSource:
                                                      ImageSource.gallery);

                                          firstnameController.text =
                                              result.cnicHolderName.split(" ")[0];
                                          lastnameController.text =
                                              result.cnicHolderName.split(" ")[1];
                                          cnicController.text = result.cnicNumber;

                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: const Text("Scan CNIC")),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 7,
                              offset: const Offset(1, 1),
                              color: Colors.grey.withOpacity(0.4),
                            )
                          ]),
                      child: TextFormField(
                        controller: firstnameController,
                        decoration: InputDecoration(
                            hintText: "First Name ",
                            prefixIcon:
                            Icon(Icons.person, color: Colors.green[600]),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1.0))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "First Name is required";
                          } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                            return "First Name should contain only alphabets";
                          }
                          return null;
                        },
                      ),
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(30),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           blurRadius: 10,
                    //           spreadRadius: 7,
                    //           offset: const Offset(1, 1),
                    //           color: Colors.grey.withOpacity(0.4),
                    //         )
                    //       ]),
                    //   child: TextField(
                    //     controller: firstnameController,
                    //     decoration: InputDecoration(
                    //       hintText: "First Name ",
                    //       prefixIcon:
                    //           Icon(Icons.person, color: Colors.green[600]),
                    //       focusedBorder: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(30),
                    //           borderSide: const BorderSide(
                    //             color: Colors.white,
                    //             width: 1.0,
                    //           )),
                    //       enabledBorder: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(30),
                    //           borderSide: const BorderSide(
                    //               color: Colors.white, width: 1.0)),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 7,
                              offset: const Offset(1, 1),
                              color: Colors.grey.withOpacity(0.4),
                            )
                          ]),
                      child: TextFormField(
                        controller: lastnameController,
                        decoration: InputDecoration(
                          hintText: "Last Name",
                          prefixIcon:
                          Icon(Icons.person, color: Colors.green[600]),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Last Name is required";
                          } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                            return "First Name should contain only alphabets";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 7,
                              offset: const Offset(1, 1),
                              color: Colors.grey.withOpacity(0.4),
                            )
                          ]),
                      child: TextField(

                        controller: nationalityController,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "Nationality",
                          prefixIcon:
                              Icon(Icons.add_home, color: Colors.green[600]),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0)),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: h * 0.02,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 7,
                            offset: const Offset(1, 1),
                            color: Colors.grey.withOpacity(0.4),
                          )
                        ],
                      ),
                      child: TextFormField(
                        controller: cnicController,
                        decoration: InputDecoration(
                            hintText: "XXXXX-XXXXXXX-X",
                            prefixIcon: Icon(Icons.numbers_sharp,
                                color: Colors.green[600]),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1.0))),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(13),
                          CNICMaskTextInputFormatter(),
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Empty Field!";
                          }
                          if (!RegExp(r'^\d{5}-\d{7}-\d{1}$').hasMatch(value)) {
                            return "Invalid CNIC";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                spreadRadius: 7,
                                offset: const Offset(1, 1),
                                color: Colors.grey.withOpacity(0.4),
                              )
                            ]),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: "Your Email",
                            prefixIcon: Icon(Icons.email_outlined,
                                color: Colors.green[600]),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1.0)),
                          ),
                        )),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                spreadRadius: 7,
                                offset: const Offset(1, 1),
                                color: Colors.grey.withOpacity(0.4),
                              )
                            ]),
                        child: TextFormField(
                          controller: numberController,
                          decoration: InputDecoration(
                            hintText: "Phone Number",
                            prefixIcon: const Icon(Icons.phone, color: Colors.green),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                )
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 1.0
                                )
                            ),
                          ),
                          validator: (value){
                            if(value!.isEmpty ){
                              return "Empty Field";
                            }
                            if(!RegExp(r'^((\+92)?(0092)?(92)?(0)?)(3)([0-9]{9})$').hasMatch(value!)){
                              return "Enter correct Pakistani phone number!";
                            }else{
                              return null;
                            }
                          },
                        ),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                spreadRadius: 7,
                                offset: const Offset(1, 1),
                                color: Colors.grey.withOpacity(0.4),
                              )
                            ]),
                      child: TextField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: Icon(Icons.password, color: Colors.green[600]),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),),
                    SizedBox(
                      height: h * 0.02,
                    ),
                  ],
                ),


// Then in your build method, use this variable in your DropdownButton
          // Set to a default value
        //
        // DropdownButton<String>(
        //   value: _selectedOption,
        //   onChanged: (newValue) {
        //     setState(() {
        //       _selectedOption = newValue!;
        //     });
        //   },
        //   items: [
        //     'Adsf',
        //     'sdf',
        //     'sdhfjksd',
        //     'gdfg'
        //   ].map((String value) {
        //     return DropdownMenuItem<String>(
        //       value: value, // Ensure each value is unique
        //       child: Text(value),
        //     );
        //   }).toList(),
        // ),


        SizedBox(
                  height: h * 0.03,
                ),
                GestureDetector(
                  onTap: () {
                    if (false) {
                      print("CNIC not Found");
                      // Display a Snackbar with an error message
                      Get.snackbar(
                        "About User",
                        "Invalid CNIC",
                        backgroundColor: Colors.redAccent,
                        snackPosition: SnackPosition.BOTTOM,
                        titleText: const Text(
                          "Account creation failed",
                          style: TextStyle(color: Colors.white),
                        ),
                        messageText: const Text(
                          "Invalid CNIC!",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else {
                      // CNIC matches, proceed with registration
                      if(_formKey.currentState!.validate()) {
                        AuthController.instance.register(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                          firstnameController.text.trim(),
                          lastnameController.text.trim(),
                          nationalityController.text.trim(),
                          numberController.text.trim(),
                          cnicController.text.trim(),
                        );
                      }
                    }
                  },
                  child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      // width: w * 0.1,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.green[600],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      )),
                ),
                SizedBox(
                  height: w * 0.04,
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account?",
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Login',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.to(
                                  () => const LoginPage(),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Center(
                //   child: RichText(
                //       text: TextSpan(
                //     text: "Sign up using the following method",
                //     style: TextStyle(color: Colors.grey[500], fontSize: 16),
                //   )),
                // ),
                // // SizedBox(height: w*0.01,),
                // Center(
                //   child: Wrap(
                //     children: List<Widget>.generate(2, (index) {
                //       return Padding(
                //         padding: const EdgeInsets.all(5.0),
                //         child: CircleAvatar(
                //           backgroundColor: Colors.white,
                //           radius: 30,
                //           child: CircleAvatar(
                //             backgroundColor: Colors.white,
                //             radius: 25,
                //             backgroundImage:
                //                 AssetImage("assets/" + images[index]),
                //           ),
                //         ),
                //       );
                //     }),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
