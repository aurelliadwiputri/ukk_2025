import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'homepage.dart';
import 'login.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://iwpixeuosumshiesrlet.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml3cGl4ZXVvc3Vtc2hpZXNybGV0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY5OTMwNjQsImV4cCI6MjA1MjU2OTA2NH0.GkKqrZjS3cxKCZlYAaVTVMpXu510OgZQx8IkaiIXwzE',
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/login': (context) => LoginPage(),
      '/homepage': (context) => HomePage(),
    },
  ));
}
