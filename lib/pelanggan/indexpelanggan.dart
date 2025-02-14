import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukkurl_2025/pelanggan/insertpelanggan.dart';
import 'package:ukkurl_2025/pelanggan/updatepelanggan.dart';


class pelangganTab extends StatefulWidget {
  @override
  _pelangganTabState createState() => _pelangganTabState();
}

class _pelangganTabState extends State<pelangganTab> {
  List<Map<String, dynamic>> pelanggan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchpelanggan();
  }

  Future<void> fetchpelanggan() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('pelanggan').select();
      setState(() {
        pelanggan = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching pelanggan: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deletepelanggan(int id) async {
    try {
      final response = await Supabase.instance.client
          .from('pelanggan')
          .delete()
          .eq('pelangganid', id)
          .select();
          
      fetchpelanggan();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('pelanggan berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error saat menghapus pelanggan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : pelanggan.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada pelanggan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  padding: EdgeInsets.all(3),
                  itemCount: pelanggan.length,
                  itemBuilder: (context, index) {
                    final langgan = pelanggan[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: SizedBox(
                        height: 150,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                langgan['namapelanggan']?.toString() ??
                                    'Nama pelanggan tidak tersedia',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                langgan['alamat']?.toString() ??
                                    'alamat tidak tersedia',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(height: 8),
                              Text(
                                langgan['nomor telepon']?.toString() ??
                                    'nomor telepon tidak tersedia',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Colors.blueAccent),
                                    onPressed: () {
                                      final pelangganid =
                                          langgan['pelangganid'] ?? 0;
                                      if (pelangganid != 0) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Editpelanggan(pelangganid: pelangganid)
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'id pelanggan tidak valid'),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Hapus pelanggan'),
                                            content: Text(
                                                'Apakah Anda yakin ingin menghapus pelanggan ini?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('Batal'),
                                              ),
                                              TextButton(
                                              onPressed: () {
                                                deletepelanggan(
                                                    langgan['pelangganid']);
                                                Navigator.pop(context);
                                              },
                                              child: Text('Hapus'),
                                            ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Addpelanggan()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}