import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'otp_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String dialCodeCountry = '+20';
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 28, top: 28),
              child: Image.asset('images/login.jpg'),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: const Center(
                child: Text(
                  'Phone (otp) Authentication',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 400,
              height: 60,
              child: CountryCodePicker(
                onChanged: (country) {
                  setState(() {
                    dialCodeCountry = country.dialCode!;
                  });
                },
                initialSelection: 'EG',
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                favorite: const ['+1', 'US', '+92', 'Pak', '+20', 'EG'],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, left: 10),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Phone',
                    prefix: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(dialCodeCountry),
                    )),
                maxLength: 12,
                keyboardType: TextInputType.number,
                controller: _controller,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => OTPController(
                        phone : _controller.text,
                         codeDigits: dialCodeCountry,
                      )));
                },
                child: const Text(
                  'Next',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
