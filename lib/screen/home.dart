import 'package:firebase_sign_up/screen/profile.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anasayfa"),
        actions: [
          IconButton(
            onPressed: () async {
              //  context.read<ServiceProvider>().logout();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Profil()));
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text("Hoşgeldiniz !")),
          Image.asset('assets/images/userAvatar.png'),
        ],
      ),
    );
  }
}
