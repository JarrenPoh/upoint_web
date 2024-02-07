import 'package:flutter/material.dart';
import 'package:upoint_web/firebase/auth_methods.dart';

class LoginPage extends StatefulWidget {
  final String role;
  const LoginPage({
    super.key,
    required this.role,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String res;
        res = await AuthMethods().signInWithGoogle(widget.role);
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[100],
        ),
        child: Image.asset(
          "assets/google.png",
          height: 200,
        ),
      ),
    );
  }
}
