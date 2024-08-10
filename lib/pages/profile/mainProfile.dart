import 'package:flutter/material.dart';
import 'package:movie/helpers/appColor.dart';
import 'package:movie/pages/favorite/mainFav.dart';
import 'package:movie/pages/watchlist/mainWatchList.dart';

class MainProfile extends StatefulWidget {
  const MainProfile({ Key? key }) : super(key: key);

  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2, // Jumlah tab
        child: SafeArea(
          child: Scaffold(
            backgroundColor: AppColor.primary,
            appBar:TabBar(
              indicatorColor: Colors.white,
                tabs: [
                  Tab(icon: Icon(Icons.bookmark), text: "WatchList"),
                  Tab(icon: Icon(Icons.favorite), text: "Favorites"),
                ],
            ),
            body: TabBarView(
              children: [
                MainWatchList(),
                MainFav()
              ],
            ),
          ),
        ),
      ),
    );
  }
}