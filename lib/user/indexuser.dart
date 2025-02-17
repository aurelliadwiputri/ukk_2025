import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukkurl_2025/user/insertuser.dart';
import 'package:ukkurl_2025/user/updateuser.dart';

class Indexuser extends StatefulWidget {
  const Indexuser({super.key});

  @override
  State<Indexuser> createState() => _IndexuserState();
}

class _IndexuserState extends State<Indexuser> {
  List<Map<String, dynamic>> user = [];

  @override
  void initState() {
    super.initState();
    User();
  }

  Future<void> deleteuser(int id) async {
    try {
      await Supabase.instance.client.from('user').delete().eq('userid', id);
      User();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error $e')));
    }
  }

  Future<void> User() async {
    try {
      final response = await Supabase.instance.client.from('user').select();
      setState(() {
        user = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: user.isEmpty
          ? Center(
              child: Text('data user belum ditambahkan'),
            )
          : ListView.builder(
              itemCount: user.length,
              itemBuilder: (context, index) {
                final user = User[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'username: ${user['username'] ?? 'tidak tersedia'}'),
                        Text(
                            'password: ${user['password'] ?? 'tidak tersedia'}'),
                        Text('role: ${user['role'] ?? 'tidak tersedia'}'),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  final userid = user['userid'];
                                  if (userid != null && userid != 0) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Updateuser(userid: userid)));
                                  }
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext) {
                                        return AlertDialog(
                                          title: Text('hapus pelanggan'),
                                          content: Text(
                                              'apakah anda yakin menghapus user ini?'),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('batal')),
                                            ElevatedButton(
                                                onPressed: () {
                                                  deleteuser(user['userid']);
                                                  Navigator.pop(context);
                                                },
                                                child: Text('hapus')),
                                          ],
                                        );
                                      });
                                },
                                icon: Icon(Icons.delete)),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Insertuser()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
