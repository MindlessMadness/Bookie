import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './start_scr.dart';

import '../providers/auth.dart';

// ignore: use_key_in_widget_constructors
class SignUpScr extends StatefulWidget {
  @override
  State<SignUpScr> createState() => _SignUpScrState();
}

class _SignUpScrState extends State<SignUpScr> {
  final _email = TextEditingController();

  final _password = TextEditingController();
  final _rePassword = TextEditingController();

  var _showPass = false;
  var _showPass2 = false;
  var _passMatch = true;
  var _doing = false;

  var _signUp = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final signUp = Provider.of<Auth>(context, listen: false).signUp;
    final signIn = Provider.of<Auth>(context, listen: false).logIn;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 224, 201, 166),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.150,
            ),
            SizedBox(
              height: size.height * 0.10,
              child: Text("Bookie",style: TextStyle(fontSize: 64, fontFamily: "Veteran"),), 
            ),
            SizedBox(
              height: size.height * 0.10,
            ),
            Center(
              child: SizedBox(
                width: size.width * 0.9,
                child: TextField(
                  controller: _email,
                  cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.black, fontSize: 20 ),
                  decoration: const InputDecoration(
                    label: Text(
                      "Email Id ",
                      style: TextStyle(color: Colors.black),
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Center(
              child: SizedBox(
                width: size.width * 0.90,
                child: TextField(
                  controller: _password,
                  obscureText: _showPass ? false : true,
                  cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(
                    
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _showPass = !_showPass;
                          });
                        },
                        icon: Icon(
                          _showPass ? Icons.visibility_off : Icons.visibility,
                          color: Colors.black,
                        )),
                    label: const Text(
                      "Password",
                      style: TextStyle(color: Colors.black),
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              curve: Curves.linear,
              height: _signUp ? 80 : 0,
              constraints: BoxConstraints(minHeight: _signUp ? 80 : 0),
              child: Center(
                child: SizedBox(
                  width: size.width * 0.90,
                  child: TextField(
                    enabled: _signUp,
                    controller: _rePassword,
                    obscureText: _showPass2 ? false : true,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    onChanged: (_) {
                      if (!_passMatch && _password.text == _rePassword.text) {
                        setState(() {
                          _passMatch = true;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      suffixIcon: !_signUp
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  _showPass2 = !_showPass2;
                                });
                              },
                              icon: Icon(
                                _showPass2
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black,
                              )),
                      errorText: _passMatch ? null : "Passwords must match",
                      label: const Text(
                        "Re-enter Password",
                        style: TextStyle(color: Colors.black),
                      ),
                      focusedErrorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none, 
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            _doing
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  )
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _doing = true;
                      });

                      if (_signUp) {
                        if (_password.text != _rePassword.text) {
                          setState(() {
                            _passMatch = false;
                            _doing = false;
                          });
                          return;
                        }
                        signUp(_email.text.trim(), _password.text)
                            .then((_) => Navigator.of(context)
                                .pushReplacementNamed(Start.route))
                            .onError((error, stackTrace) {
                          if (error.toString() ==
                              "This email address is already in use") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Email exists. Signing you in!")));
                            Provider.of<Auth>(context, listen: false)
                                .logIn(_email.text.trim(), _password.text)
                                .then((_) => Navigator.of(context)
                                    .pushReplacementNamed(Start.route))
                                .onError((error, stackTrace) {
                              setState(() {
                                _doing = false;
                              });
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              return ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Couldn't Sign You in: ${error.toString()}")));
                            });
                            return null;
                          } else {
                            setState(() {
                              _doing = false;
                            });
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Couldn't Sign Up"),
                                    content: Text(error.toString()),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("OK"))
                                    ],
                                  );
                                });
                          }
                        });
                      } else {
                        signIn(_email.text.trim(), _password.text)
                            .then((_) => Navigator.of(context)
                                .pushReplacementNamed(Start.route))
                            .onError((error, stackTrace) {
                          setState(() {
                            _doing = false;
                          });
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Couldn't Sign In"),
                                  content: Text(error.toString()),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("OK"))
                                  ],
                                );
                              });
                        });
                      }
                    },
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Color.fromRGBO(240, 238, 228, 1)),
                        foregroundColor:
                            MaterialStatePropertyAll<Color>(Colors.black)),
                    child: Text(_signUp ? "Sign Up!" : "Sign In!")),
            TextButton(
              onPressed: () {
                setState(() {
                  _signUp = !_signUp;
                  _rePassword.text = '';
                });
              },
              child: Text(
                _signUp ? "Already a User?" : "New here?",
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
