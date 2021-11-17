import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sign_up/screen/login/login.dart';
import 'package:firebase_sign_up/screen/login/new_password.dart';
import 'package:firebase_sign_up/service/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  User? user = FirebaseAuth.instance.currentUser!;

  verifyEmail() async {
    if (user != null && !user!.emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Doğrulama Emailiniz Yollanmıştır.")));
    }
  }

  @override
  Widget build(BuildContext context) {

    final pr = context.watch<ServiceProvider>();

    return Scaffold(
      body: _buildProfile(
          context, pr.loggedInUser.userName!, pr.loggedInUser.imageUrl!),
    );
  }

  DefaultTabController _buildProfile(
      BuildContext context, String userName, String imageUrl) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              actions: [
                IconButton(
                    onPressed: () async {
                      await context.read<ServiceProvider>().logout();
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Colors.white,
                    )),
              ],
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                  background: Container(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                        radius: 45,
                        child: ClipRRect(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        )),
                  )),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  labelColor: Colors.black87,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: "Profil"),
                    Tab(text: "Gönderiler"),
                  ],
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          children: [
            Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.email,
                    color: Colors.amber,
                  ),
                  title: Text(user!.email!),
                  trailing: IconButton(
                      onPressed: () {
                        verifyEmail();
                      },
                      icon: Icon(
                        Icons.verified,
                        color: user!.emailVerified
                            ? Colors.amber
                            : Colors.grey[200],
                      )),
                ),
                ListTile(
                  leading: Icon(
                    Icons.password,
                    color: Colors.amber,
                  ),
                  title: Text("******"),
                  trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewPassword()));
                      },
                      icon: Icon(
                        Icons.change_circle,
                      )),
                ),
              ],
            ),
            Container(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
