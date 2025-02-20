import 'package:flutter/material.dart';
import 'package:lottery/main.dart';
import 'package:lottery/route/myself/information_page.dart';
import 'package:lottery/route/display_lottery_page.dart';
import 'package:lottery/route/myself/setting_page.dart';
import 'package:provider/provider.dart';

class MyselfPage extends StatelessWidget {
  const MyselfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Center(
                child: Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 44,
                          child: (userProvider.user?.face.isEmpty ?? true)
                              ? Text(userProvider.user!.nickname[0],
                                  style: TextStyle(fontSize: 35))
                              : ClipOval(
                                  child: FadeInImage(
                                    placeholder:
                                        AssetImage('assets/loading.gif'), // 占位图
                                    image:
                                        NetworkImage(userProvider.user!.face),
                                    fit: BoxFit.cover, // 确保图像填充整个圆形区域
                                    width: 88, // 设置图像的宽度为两倍半径
                                    height: 88, // 设置图像的高度为两倍半径
                                  ),
                                ),
                        ),
                        SizedBox(height: 5),
                        Text(userProvider.user!.nickname,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text('学号：${userProvider.user!.sid}',
                            style: TextStyle(fontSize: 18)),
                      ],
                    );
                  },
                ),
              ),
              Divider(color: Colors.grey),
              SizedBox(height: 10),
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  debugPrint('抽奖记录');
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> DisplayLotteryPage(lotteries: [],title: '已参加的抽奖')));
                },
                child: Card(
                  color: Theme.of(context).colorScheme.secondaryFixed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.access_time),
                        SizedBox(width: 5),
                        Text('抽奖记录'),
                        Expanded(child: SizedBox(height: 30)),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  debugPrint('个人信息');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InformationPage()));
                },
                child: Card(
                  color: Theme.of(context).colorScheme.secondaryFixed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 5),
                        Text('个人信息'),
                        Expanded(child: SizedBox(height: 30)),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  debugPrint('设置');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingPage()));
                },
                child: Card(
                  color: Theme.of(context).colorScheme.secondaryFixed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.access_time),
                        SizedBox(width: 5),
                        Text('设置'),
                        Expanded(child: SizedBox(height: 30)),
                        Icon(Icons.arrow_forward_ios)
                      ],
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
