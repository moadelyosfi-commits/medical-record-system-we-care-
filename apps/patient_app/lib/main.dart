import 'package:flutter/material.dart';

void main() {
  runApp(const ReleaseEntryPointFallbackApp());
}

class ReleaseEntryPointFallbackApp extends StatelessWidget {
  const ReleaseEntryPointFallbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 64, color: Colors.blueGrey),
                SizedBox(height: 16),
                Text(
                  'Production storage is not available in this build.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'التخزين الفعلي غير متوفر في هذه النسخة.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
