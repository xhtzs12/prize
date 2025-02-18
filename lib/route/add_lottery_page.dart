import 'package:flutter/material.dart';
import 'package:lottery/main.dart';
import 'package:lottery/route/addLottery/instant_lottery_page.dart';
import 'package:provider/provider.dart';

class AddLotteryPage extends StatelessWidget {
  const AddLotteryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final secondaryFixed = Theme.of(context).colorScheme.secondaryFixed;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Text('张', style: TextStyle(fontSize: 25)),
                ),
                title: Text('张三'),
                subtitle: Text('学号：12345676890'),
                onTap: () {
                  Provider.of<MyProvider>(context, listen: false)
                      .updateSelectedIndex(2);
                },
              ),
              Divider(color: Colors.grey),
              SizedBox(height: 20),
              Center(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.25,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text('创建抽奖', style: TextStyle(fontSize: 22)),
                          Divider(color: Colors.grey),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              debugPrint('通用抽奖');
                            },
                            child: Container(
                              width: screenWidth * 0.6,
                              decoration: BoxDecoration(
                                  color: secondaryFixed,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text('通用抽奖',
                                    style: TextStyle(fontSize: 28)),
                              ),
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              debugPrint('即抽即开');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          InstantLotteryPage()));
                            },
                            child: Container(
                              width: screenWidth * 0.6,
                              decoration: BoxDecoration(
                                  color: secondaryFixed,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text('即抽即开',
                                    style: TextStyle(fontSize: 28)),
                              ),
                            ),
                          ),
                          Spacer()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.1,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Spacer(),
                          InkWell(
                            onTap: () {
                              debugPrint('已发布的抽奖');
                            },
                            child: Container(
                              width: screenWidth * 0.6,
                              decoration: BoxDecoration(
                                  color: secondaryFixed,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text('已发布的抽奖',
                                    style: TextStyle(fontSize: 28)),
                              ),
                            ),
                          ),
                          Spacer()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
