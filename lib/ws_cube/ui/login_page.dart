import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _fromKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  sign(String email, String pass) async {
    UserCredential? userCredential;
    try {
      userCredential =  await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _fromKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTextFormField(_emailController, (p0) {
                if (p0!.isEmpty) {
                  return "Enter email";
                }
              }),
              const SizedBox(
                height: 10,
              ),
              buildTextFormField(_passController, (p0) {
                if (p0!.isEmpty) {
                  return "Enter password";
                }
              }),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                    onPressed: () {
                      if (_fromKey.currentState!.validate()) {
                        sign(_emailController.text, _passController.text);
                        const AlertDialog(
                          title: Text("Login"),
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Success")));
                      }
                    },
                    child: const Text("Login")),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField(TextEditingController controller,
          String? Function(String?)? validator) =>
      TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      );
}
