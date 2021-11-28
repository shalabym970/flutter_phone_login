import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:login_phone/home_screen.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OTPController extends StatefulWidget {
  final String phone;
  final String codeDigits;

   const OTPController(
      {Key? key, required this.phone, required this.codeDigits});

  @override
  _OTPControllerState createState() => _OTPControllerState();
}

class _OTPControllerState extends State<OTPController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinOTPController = TextEditingController();
  final FocusNode _pinOTPCodeFocus = FocusNode();
  String? verificationCode;
  final BoxDecoration _pinOTOCodeDecoration = BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey));

  @override
  void initState() {
    super.initState();
    verifyPhone();
  }
  void verifyPhone() async{
     await FirebaseAuth.instance.verifyPhoneNumber(
         phoneNumber: widget.codeDigits+widget.phone,
         verificationCompleted: (PhoneAuthCredential credential)async{
           await FirebaseAuth.instance.signInWithCredential(credential).then((value){
             if (value.user != null) {
               Navigator.of(context).push(MaterialPageRoute(
                   builder: (context) => HomeScreen()));
             }
           });
         }, verificationFailed: (FirebaseAuthException e){
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text(e.message.toString()  ),
           duration: const Duration(seconds: 3),
         ),
       );
     },
         codeSent: (String vID, int? resendToken){
           setState(() {
             verificationCode = vID;
           });
         },
         codeAutoRetrievalTimeout: (String vID){
           setState(() {
             verificationCode = vID;
           });
         },
       timeout: const Duration(
         seconds: 60,
       )
     );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('OTP verification'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/otp.png'),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  verifyPhone();
                },
                child: Text(
                  'Verifying : ${widget.codeDigits}--${widget.phone}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(40),
            child: PinPut(
              fieldsCount: 6,
              textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55,
              focusNode: _pinOTPCodeFocus,
              controller: _pinOTPController,
              submittedFieldDecoration: _pinOTOCodeDecoration,
              selectedFieldDecoration: _pinOTOCodeDecoration,
              followingFieldDecoration: _pinOTOCodeDecoration,
              pinAnimationType: PinAnimationType.rotation,
              onSubmit: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: verificationCode!, smsCode: pin))
                      .then((value) {
                    if (value.user != null) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HomeScreen()));
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid otp'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
