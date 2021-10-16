import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hhotel/provider/auth_bloc.dart';
import 'package:hhotel/screens/menu.dart';
import 'package:hhotel/services/firebase_api.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _signInKey = GlobalKey<FormState>();
  final pass = new TextEditingController();
  final email = new TextEditingController();
  bool _newPasswordVisible = true;
  bool initialized = false;

  checkLogin(_auth) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseApi _firebaseApi = FirebaseApi();

    List<String>? creds = prefs.getStringList("creds");
    if (mounted) {
      if (creds != null) {
        _auth.loading = true;
        _firebaseApi.login(creds[0], creds[1]).then((value) {
          if (value == "Login Successful!") {
            _auth.isLogged = true;
            Fluttertoast.showToast(
                msg: value,
                backgroundColor: Colors.green,
                gravity: ToastGravity.BOTTOM);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Menu()));
          } else {
            _auth.isLogged = false;
            Fluttertoast.showToast(
                msg: value,
                backgroundColor: Colors.red,
                gravity: ToastGravity.BOTTOM);
          }
        }).whenComplete(() {
          _auth.loading = false;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AuthBloc _auth = Provider.of<AuthBloc>(context);
    if (!initialized) {
      setState(() {
        initialized = true;
      });
      checkLogin(_auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthBloc _auth = Provider.of<AuthBloc>(context);

    var formFontStyle = const TextStyle(
      fontSize: 16,
      letterSpacing: 1,
      color: Colors.black,
      // fontWeight: FontWeight.w700
    );

    return FocusWatcher(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/hotel.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.orange.withOpacity(0.2),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 5.5),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.4,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          )),
                      child: Form(
                        key: _signInKey,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 50),
                              child: const Text(
                                'Smart Room Service',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    fontFamily: "cursive"),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 60),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: TextFormField(
                                        maxLines: 1,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'This field cannot be empty';
                                          }
                                          return null;
                                        },
                                        controller: email,
                                        style: formFontStyle,
                                        keyboardType: TextInputType.text,
                                        textAlign: TextAlign.left,
                                        decoration: InputDecoration(
                                          errorStyle: const TextStyle(
                                              fontSize: 10, height: 0.3),
                                          helperText: ' ',
                                          isDense: true,
                                          contentPadding: const EdgeInsets.only(
                                              left: 11,
                                              right: 3,
                                              top: 14,
                                              bottom: 14),
                                          hintText: "Room Number",
                                          hintStyle: formFontStyle,
                                          prefixIcon:
                                              const Icon(Icons.home_filled),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                        enableSuggestions: true,
                                        autocorrect: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field cannot be empty';
                                  }
                                  return null;
                                },
                                style: formFontStyle,
                                controller: pass,
                                obscureText: _newPasswordVisible,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                  errorStyle: const TextStyle(
                                      fontSize: 10,
                                      height: 0.3,
                                      color: Colors.red),
                                  helperText: ' ',
                                  isDense: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 11, right: 3, top: 14, bottom: 14),
                                  hintText: 'Password',
                                  hintStyle: formFontStyle,
                                  prefixIcon: Icon(Icons.vpn_key_rounded),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _newPasswordVisible == false
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _newPasswordVisible =
                                            !_newPasswordVisible;
                                      });
                                    },
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                enableSuggestions: false,
                                autocorrect: false,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (_signInKey.currentState!.validate()) {
                                  _auth.loading = true;
                                  FirebaseApi _firebaseApi = FirebaseApi();
                                  _firebaseApi
                                      .login(
                                          email.text.trim(), pass.text.trim())
                                      .then((value) {
                                    if (value == "Login Successful!") {
                                      _auth.isLogged = true;
                                      Fluttertoast.showToast(
                                          msg: value,
                                          backgroundColor: Colors.green,
                                          gravity: ToastGravity.BOTTOM);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Menu()));
                                    } else {
                                      _auth.isLogged = false;
                                      Fluttertoast.showToast(
                                          msg: value,
                                          backgroundColor: Colors.red,
                                          gravity: ToastGravity.BOTTOM);
                                    }
                                  }).whenComplete(() {
                                    _auth.loading = false;
                                  });
                                }
                              },
                              child: _auth.loading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Login",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blueGrey[600],
                                  onPrimary: Colors.white,
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 80, vertical: 10)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
