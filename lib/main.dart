import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Initial image path
  String imageSource = "images/question-mark.jpg";

  void handleLogin() {
    String password = passwordController.text;

    setState(() {
      if (password == 'QWERTY123') {
        imageSource = 'images/idea.jpg';
      } else {
        imageSource = 'images/stop.jpg';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: loginController,
              decoration: InputDecoration(
                labelText: 'Login name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: handleLogin,
              child: Text('Login'),
            ),
            SizedBox(height: 24),
            Image.asset(
              imageSource,
              width: 300,
              height: 300,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
