// import 'dart:html';

// import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first/Dashborad.dart';
import 'package:first/SplashScreen.dart';
import 'package:first/auth/Login_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'dart:js';

import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));

  // await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Client? httpClient;
  // Web3Client? ethClient;




  final LocalAuthentication auth = LocalAuthentication();
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  _SupportState _supportState = _SupportState.unknown;

  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   home: Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Plugin example app'),
    //     ),
    //     body: ListView(
    //       padding: const EdgeInsets.only(top: 30),
    //       children: <Widget>[
    //         Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             if (_supportState == _SupportState.unknown)
    //               const CircularProgressIndicator()
    //             else if (_supportState == _SupportState.supported)
    //               const Text('This device is supported')
    //             else
    //               const Text('This device is not supported'),
    //             const Divider(height: 100),
    //             Text('Can check biometrics: $_canCheckBiometrics\n'),
    //             ElevatedButton(
    //               onPressed: _checkBiometrics,
    //               child: const Text('Check biometrics'),
    //             ),
    //             const Divider(height: 100),
    //             Text('Available biometrics: $_availableBiometrics\n'),
    //             ElevatedButton(
    //               onPressed: _getAvailableBiometrics,
    //               child: const Text('Get available biometrics'),
    //             ),
    //             const Divider(height: 100),
    //             Text('Current State: $_authorized\n'),
    //             if (_isAuthenticating)
    //               ElevatedButton(
    //                 onPressed: _cancelAuthentication,
    //                 child: const Row(
    //                   mainAxisSize: MainAxisSize.min,
    //                   children: <Widget>[
    //                     Text('Cancel Authentication'),
    //                     Icon(Icons.cancel),
    //                   ],
    //                 ),
    //               )
    //             else
    //               Column(
    //                 children: <Widget>[
    //                   ElevatedButton(
    //                     onPressed: _authenticate,
    //                     child: const Row(
    //                       mainAxisSize: MainAxisSize.min,
    //                       children: <Widget>[
    //                         Text('Authenticate'),
    //                         Icon(Icons.perm_device_information),
    //                       ],
    //                     ),
    //                   ),
    //                   ElevatedButton(
    //                     onPressed: _authenticateWithBiometrics,
    //                     child: Row(
    //                       mainAxisSize: MainAxisSize.min,
    //                       children: <Widget>[
    //                         Text(_isAuthenticating
    //                             ? 'Cancel'
    //                             : 'Authenticate: biometrics only'),
    //                         const Icon(Icons.fingerprint),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    //FirebaseAuth.instance.signOut();
    final user = FirebaseAuth.instance.currentUser;
    return GetMaterialApp(
      // home: new LoginScreen(),
      debugShowCheckedModeBanner: false,
      home: user == null ? const LoginPage() : const LoginPage(),
    ); //MaterialApp
  }
}

class Web3Client {
}

// mixin Web3Client {
// }

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:local_auth/error_codes.dart' as error_code;
// import 'package:local_auth/local_auth.dart';
// import 'package:local_auth_android/local_auth_android.dart';
// import 'package:local_auth_ios/local_auth_ios.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       themeMode: ThemeMode.system,
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: Home(),
//     );
//   }
// }

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   bool isDeviceSupport = false;
//   bool authenticated = false;
//   List<BiometricType>? availableBiometrics;
//   LocalAuthentication? auth;

//   @override
//   void initState() {
//     super.initState();

//     auth = LocalAuthentication();

//     deviceCapability();
//     _getAvailableBiometrics();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: Colors.black45,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             if (isDeviceSupport)
//               Text(
//                 "Fingerprint Verified",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold),
//               ),
//             SizedBox(
//               height: h * 0.02,
//             ),
//             // Icon(Icons.fingerprint,size: 50,color: Colors.white,)
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _getAvailableBiometrics() async {
//     try {
//       availableBiometrics = await auth?.getAvailableBiometrics();
//       print("bioMetric: $availableBiometrics");

//       if (availableBiometrics!.contains(BiometricType.strong) ||
//           availableBiometrics!.contains(BiometricType.fingerprint)) {
//         authenticated = true;
//         final bool didAuthenticate = await auth!.authenticate(
//             localizedReason: 'Unlock with fingerprint',
//             options: const AuthenticationOptions(
//                 biometricOnly: true, stickyAuth: true),
//             authMessages: const <AuthMessages>[
//               AndroidAuthMessages(
//                 signInTitle: 'Fingerprint Verification',
//                 cancelButton: 'No thanks',
//               ),
//               IOSAuthMessages(
//                 cancelButton: 'No thanks',
//               ),
//             ]);
//         if (!didAuthenticate) {
//           exit(0);
//         }
//       } else if (availableBiometrics!.contains(BiometricType.weak) ||
//           availableBiometrics!.contains(BiometricType.face)) {
//         authenticated = true;
//         final bool didAuthenticate = await auth!.authenticate(
//             localizedReason: 'Unlock with Face lock',
//             options: const AuthenticationOptions(stickyAuth: true),
//             authMessages: const <AuthMessages>[
//               AndroidAuthMessages(
//                 signInTitle: 'Unlock Ideal Group',
//                 cancelButton: 'No thanks',
//               ),
//               IOSAuthMessages(
//                 cancelButton: 'No thanks',
//               ),
//             ]);
//         if (!didAuthenticate) {
//           exit(0);
//         }
//       }
//     } on PlatformException catch (e) {
//       // availableBiometrics = <BiometricType>[];
//       if (e.code == error_code.passcodeNotSet) {
//         exit(0);
//       }
//       print("error: $e");
//     }
//   }

//   void deviceCapability() async {
//     final bool isCapable = await auth!.canCheckBiometrics;
//     isDeviceSupport = isCapable || await auth!.isDeviceSupported();
//   }
// }

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
