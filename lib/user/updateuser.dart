import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukkurl_2025/homepage.dart';

class Updateuser extends StatefulWidget {
  final int userid;

  const Updateuser({super.key, required this.userid});

  @override
  State<Updateuser> createState() => _UpdateuserState();
}

class _UpdateuserState extends State<Updateuser> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _role = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    tampiluser();
  }

  Future<void> tampiluser() async {
    final user = await Supabase.instance.client
        .from('user')
        .select()
        .eq('user id', widget.userid)
        .single();
    setState(() {
      final username = _username.text.trim();
      final password = _password.text.trim();
      final role = _role.text.trim();
    });
  }

  Future<void> updateuser() async {
    if (_formKey.currentState!.validate()) {}
    await Supabase.instance.client.from('user').update({
      'username': _username.text.trim(),
      'password': _password.text.trim(),
      'role': _role.text.trim(),
    }).eq('userid', widget.userid);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('update user'),
    ),
    body: Container(
      padding: EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _username,
              decoration: InputDecoration(
                  labelText: 'username',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'username tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _password,
              decoration: InputDecoration(
                  labelText: 'password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'password tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _role,
              decoration: InputDecoration(
                  labelText: 'role',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'username tidak boleh kosong';
                }
                if (value != 'petugas' && value != 'admin') {
                  return 'hanya boleh role admin dan petugas';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  updateuser();
                },
                child: Text('update')),
          ],
        ),
      ),
    ),
  );
}
