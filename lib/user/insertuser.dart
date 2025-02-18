import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukkurl_2025/homepage.dart';
import 'package:ukkurl_2025/user/indexuser.dart';
import 'package:ukkurl_2025/user/updateuser.dart';
import 'package:ukkurl_2025/user/insertuser.dart';

class Insertuser extends StatefulWidget {
  const Insertuser({super.key});

  @override
  State<Insertuser> createState() => _InsertuserState();
}

class _InsertuserState extends State<Insertuser> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _role = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> user() async {
    if (_formKey.currentState!.validate()) {
      final username = _username.text.trim();
      final password = _password.text.trim();
      final role = _role.text.trim();

      try {
        final response = await Supabase.instance.client.from('user').insert({
          'username': username,
          'password': password,
          'role': role,
        });

        if (response.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('tidak berhasil menambahkan user')));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      } catch (e) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tambah user'),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                        borderRadius: BorderRadius.circular(8))),
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
                        borderRadius: BorderRadius.circular(8))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'role tidak boleh kosong';
                  }
                  if (value != 'petugas' && value != 'admin') {
                    return 'hanya bisa menambahkan petugas dan admin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: user, child: Text('tambah')),
            ],
          ),
        ),
      ),
    );
  }
}
