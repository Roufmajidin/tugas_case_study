// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_case_study/controllers/controller_provider.dart';
import 'package:tugas_case_study/pages/navigation/navigation.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({super.key});

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  final _formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();
  bool isvisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ControllerProvider authProvider, child) {
          // TODO: implement listener
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Center(
              child: Icon(
                Icons.apple,
                size: 80,
                color: Colors.purple,
              ),
            ),

            // form widget
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: TextFormField(
                          controller: username,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "username is required";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Username',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: TextFormField(
                          controller: password,
                          obscureText: !isvisible,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isvisible = !isvisible;
                                    });
                                  },
                                  icon: Icon(isvisible
                                      ? Icons.visibility
                                      : Icons.visibility_off))),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.deepPurple),
                    child: TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await authProvider.loginProcess(
                              username.text,
                              password.text,
                            );

                            if (authProvider.loadingState ==
                                LoadingState.isSuccess) {
                              print('Login successful');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>NavigationView()),
                              );
                            } else if (authProvider.loadingState ==
                                LoadingState.isError) {
                              // Show error message
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Login failed')),
                              );
                            }
                          }
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ]),
              ),
            ),
          ]);
        },
      ),
    );
  }
}
