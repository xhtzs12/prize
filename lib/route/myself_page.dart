import 'package:flutter/material.dart';
import 'package:lottery/route/myself/setting_page.dart';

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
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      child: Text('张', style: TextStyle(fontSize: 35)),
                      //backgroundImage: NetworkImage('assets/我的.png'),
                    ),
                    SizedBox(height: 5),
                    Text('张三',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text('学号：1234567890', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              Divider(color: Colors.grey),
              SizedBox(height: 10),
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  debugPrint('抽奖记录');
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
                  debugPrint('个人信息设置');
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
                        Text('个人信息设置'),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingPage()));
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
