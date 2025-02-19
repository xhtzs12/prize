import 'package:flutter/material.dart';
import 'package:lottery/main.dart';
import 'package:lottery/route/login_page.dart';
import 'package:lottery/route/myself/palette_page.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppbar(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserListTileD(),
            Divider(color: Colors.grey),
            SizedBox(height: 20),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                debugPrint('消息设置');
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
                      Icon(Icons.notifications),
                      SizedBox(width: 5),
                      Text('消息设置'),
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
                debugPrint('主题设置');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PalettePage()));
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
                      Icon(Icons.palette),
                      SizedBox(width: 5),
                      Text('主题设置'),
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
                debugPrint('登出');
                Provider.of<IndexProvider>(context, listen: false)
                    .updateSelectedIndex(0);
                Provider.of<UserProvider>(context, listen: false)
                    .clearUser();
                Navigator.pushAndRemoveUntil(
                  //跳转登录页并删除之前的路径
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
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
                      Icon(Icons.logout),
                      SizedBox(width: 5),
                      Text('登出'),
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
    );
  }
}
