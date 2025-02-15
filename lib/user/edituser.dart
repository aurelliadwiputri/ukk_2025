import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukkurl_2025/homepage.dart';

class EditUser extends StatefulWidget {
  final Map<String, dynamic> user;

  EditUser({required this.user});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void iniState() {
    super.initState();
    _username.text =
        widget.user['username']; //2 kode berikut yang akan muncul pertama kali
    _password.text = widget.user['password'];
  }

  //fungsi untuk memperbarui user di supabase
  Future<void> updateUser() async {
    final response = await Supabase.instance.client
        .from('user')
        .update({
          'username': _username.text,
          'password': _password.text,
        })
        .eq('id', widget.user['id'])
        .select();

    //jika kode diatas muncul error maka munculkan pesan
    if (response.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('gagal memperbarui')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('berhasil diperbarui')),
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage())
          );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('edit'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Column(
              children: [
                TextFormField(
                  controller: _username,
                  decoration: InputDecoration(
                    labelText: 'username',
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _password,
                  decoration: InputDecoration(
                    labelText: 'password',
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: updateUser, child: Text('perbarui user'),
                )
              ],
            ),
        ),
      ),
    );
  }
}
