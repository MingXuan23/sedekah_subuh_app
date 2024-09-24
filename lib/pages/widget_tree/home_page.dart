import 'package:flutter/material.dart';
import 'package:prim_derma_app/pages/derma/derma_page.dart';
import 'package:prim_derma_app/pages/info/code_info_page.dart';
import 'package:prim_derma_app/pages/info/info_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static int selectedTab = 0;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
       
        index: HomePage.selectedTab,
         children:  [DermaPage(), InfoPage()],
      ),
      bottomNavigationBar:  BottomNavigationBar(
        items: const [
           BottomNavigationBarItem(
              icon:  Icon(Icons.favorite_rounded), label: 'Derma'),
          BottomNavigationBarItem(icon:  Icon(Icons.info_rounded), label: 'Info')
        ],
        currentIndex:  HomePage.selectedTab,
        onTap: (value) {
           HomePage.selectedTab = value;
          setState(() {});
        },
      ),
    );
  }
}
