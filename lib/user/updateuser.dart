import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukkurl_2025/user/indexuser.dart';
import 'package:ukkurl_2025/user/insertuser.dart';
import 'package:ukkurl_2025/user/updateuser.dart';

class UpdateUser extends StatefulWidget {
  final int userid;

  const UpdateUser({super.key, required this.userid});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
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
    try {
      final user = await Supabase.instance.client
          .from('user')
          .select()
          .eq('userid', widget.userid)
          .single();
      setState(() {
        _username.text = user['username'] ?? '';
        _password.text = user['password'] ?? '';
        _role.text = user['role'] ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data user: $e')),
      );
    }
  }

  Future<void> updateuser() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Supabase.instance.client.from('user').update({
          'username': _username.text.trim(),
          'password': _password.text.trim(),
          'role': _role.text.trim(),
        }).eq('userid', widget.userid);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User berhasil diperbarui')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui user: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update User')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _username,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _role,
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Role tidak boleh kosong';
                  }
                  if (value != 'petugas' && value != 'admin') {
                    return 'Hanya boleh role admin dan petugas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: updateuser,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
