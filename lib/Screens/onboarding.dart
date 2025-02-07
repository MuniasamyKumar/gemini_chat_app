import 'package:flutter/material.dart';

import 'home_page.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  "You AI Assistant",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Using this software, you can ask you questions and receive articles using artificial intelligence assistant",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
            SizedBox(
              height: 32,
            ),
            Image.asset("assets/onboarding.png"),
            SizedBox(
              height: 32,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.blue[800],
                    padding:
                        EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Continue",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
