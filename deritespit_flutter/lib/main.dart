import 'package:flutter/material.dart';
import 'doc.dart';
import 'user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deri Hastalık Tespit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 145, 206, 204),
        actions: [
          IconButton(
            icon: IconWithShadow(
              icon: Icons.list,
              shadowColor: Colors.white,
            ),
            iconSize: 36.0,
            color: Color.fromARGB(255, 53, 134, 130),
            onPressed: () {},
          ),
        ],
        elevation: 0,
      ),
      backgroundColor: Color.fromARGB(255, 226, 244, 249),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DocPage(),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    height: 190,
                    width: 360,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color.fromARGB(255, 53, 134, 130),
                        width: 4.0,
                      ),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/doc1.jpg"),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  const Text(
                    "Doktor Giriş",
                    style: TextStyle(
                      color: Color.fromARGB(255, 53, 134, 130),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(1.5, 1.5),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserPage(),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    height: 190,
                    width: 360,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color.fromARGB(255, 53, 134, 130),
                        width: 4.0,
                      ),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/kul2.jpg"),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  const Text(
                    "Kullanıcı Giriş",
                    style: TextStyle(
                      color: Color.fromARGB(255, 53, 134, 130),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(2.5, 2.5),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: IconWithShadow(
                icon: Icons.settings,
                shadowColor: Colors.white,
              ),
              label: 'Ayarlar',
            ),
            BottomNavigationBarItem(
              icon: IconWithShadow(
                icon: Icons.favorite,
                shadowColor: Colors.white,
              ),
              label: 'İstekler',
            ),
            BottomNavigationBarItem(
              icon: IconWithShadow(
                icon: Icons.person,
                shadowColor: Colors.white,
              ),
              label: 'Profil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(255, 53, 134, 130),
          unselectedItemColor: Color.fromARGB(255, 53, 134, 130),
          backgroundColor: Colors.transparent,
          elevation: 0,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class IconWithShadow extends StatelessWidget {
  final IconData icon;
  final Color shadowColor;

  IconWithShadow({required this.icon, required this.shadowColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 2,
          left: 2,
          child: Icon(
            icon,
            color: shadowColor,
          ),
        ),
        Icon(
          icon,
          color: Color.fromARGB(255, 53, 134, 130),
        ),
      ],
    );
  }
}
