import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukkurl_2025/user/insertuser.dart';
import 'package:ukkurl_2025/user/updateuser.dart';
import 'package:ukkurl_2025/user/indexuser.dart';

class IndexUser extends StatefulWidget {
  const IndexUser({super.key});

  @override
  State<IndexUser> createState() => _IndexUserState();
}

class _IndexUserState extends State<IndexUser> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> deleteUser(int id) async {
    try {
      await Supabase.instance.client.from('user').delete().eq('userid', id);
      fetchUsers();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> fetchUsers() async {
    try {
      final response = await Supabase.instance.client.from('user').select();
      setState(() {
        users = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: users.isEmpty
          ? const Center(
              child: Text('Data user belum ditambahkan'),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Username: ${user['username'] ?? 'Tidak tersedia'}'),
                        Text('Password: ${user['password'] ?? 'Tidak tersedia'}'),
                        Text('Role: ${user['role'] ?? 'Tidak tersedia'}'),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  final userid = user['userid'];
                                  if (userid != null) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UpdateUser(userid: userid)));
                                  }
                                },
                                icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Hapus User'),
                                          content: const Text('Apakah Anda yakin menghapus user ini?'),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Batal')),
                                            ElevatedButton(
                                                onPressed: () {
                                                  deleteUser(user['userid']);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Hapus')),
                                          ],
                                        );
                                      });
                                },
                                icon: const Icon(Icons.delete)),
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
              context, MaterialPageRoute(builder: (context) => const Insertuser()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}