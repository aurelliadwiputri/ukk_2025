import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukkurl_2025/homepage.dart';

Future<void> deleteUser(int idUser, BuildContext context) async {
  final supabase = Supabase.instance.client;

  bool? confirmdelete = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        elevation: 40,
        backgroundColor: Colors.white,
        content: Container(
          height: 30,
          width: 40,
          child: Center(
            child: Text(
              'Anda yakin ingin menghapus produk ini? :|',
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(
              'Hapus',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 154, 134, 208),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 154, 134, 208),
            ),
          )
        ],
      );
    },
  );

  if (confirmdelete == true) {
    // Memastikan id_user sesuai dengan nama kolom di Supabase
    final response = await supabase.from('user').delete().eq('id_user', idUser);

    if (response.error != null) {
      print('Hapus error: ${response.error!.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.error!.message}')),
      );
    } else {
      // Berhasil, lakukan navigasi kembali ke halaman utama
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }
}
