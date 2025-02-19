import 'package:flutter/material.dart';
import 'package:lottery/route/add_lottery_page.dart';
import 'package:lottery/route/lottery_page.dart';
import 'package:lottery/main.dart';
import 'package:lottery/route/myself_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    LotteryPage(),
    AddLotteryPage(),
    MyselfPage(),
  ];

  void _onItemTapped(int index) {
    debugPrint('BottombarIndex: $index');
    Provider.of<IndexProvider>(context, listen: false).updateSelectedIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppbar(),
      body:
          _pages[Provider.of<IndexProvider>(context, listen: true).selectedIndex],
      bottomNavigationBar: Consumer<IndexProvider>(
        builder: (context, state, child) {
          return BottomNavigationBar(
            backgroundColor: Colors.grey[100],
            currentIndex: state.selectedIndex,
            onTap: _onItemTapped,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Theme.of(context).primaryColor,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/抽卡.png',
                  width: 24,
                  height: 24,
                  color: state.selectedIndex == 0 ? Theme.of(context).colorScheme.primaryContainer : Colors.grey,
                ),
                label: '抽卡',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/发起抽卡.png',
                  width: 24,
                  height: 24,
                  color: state.selectedIndex == 1 ? Theme.of(context).colorScheme.primaryContainer : Colors.grey,
                ),
                label: '发起抽卡',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/我的.png',
                  width: 24,
                  height: 24,
                  color: state.selectedIndex == 2 ? Theme.of(context).colorScheme.primaryContainer : Colors.grey,
                ),
                label: '我的',
              ),
            ],
          );
        },
      ),
    );
  }
}
