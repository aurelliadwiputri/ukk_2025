import 'package:flutter/material.dart';
import 'package:ukkurl_2025/login.dart';
import 'package:ukkurl_2025/main.dart';
import 'package:ukkurl_2025/pelanggan/indexpelanggan.dart';
import 'package:ukkurl_2025/produk/indexproduk.dart';

class HomePage extends StatefulWidget {
  //membuat GlobalKey untuk Sfaffold

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Memastikan untuk membuka drawer menggunakan GlobalKey
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.dashboard), text: 'Detail penjual'),
              Tab(icon: Icon(Icons.person), text: 'Pelanggan'),
              Tab(icon: Icon(Icons.shopping_bag_sharp), text: 'Produk'),
              Tab(icon: Icon(Icons.dashboard), text: 'Penjualan'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue, // Warna latar belakang DrawerHeader
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40, color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Aurellia DwiPutri',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Text(
                      'aurellia.xpplg1@gmail.com',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context); // Menutup drawer
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Home selected')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  Navigator.pop(context); // Menutup drawer
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logout selected')),
                  );
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Detail Penjual Content')),
            PelangganTab(),
            ProdukTab(),
            Center(child: Text('Penjual Content')),
          ],
        ),
      ),
    );
  }
}
