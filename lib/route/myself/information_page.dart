import 'package:flutter/material.dart';
import 'package:lottery/main.dart';
import 'package:provider/provider.dart';

class InformationPage extends StatefulWidget {
  InformationPage({super.key});

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  TextEditingController _nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppbar(),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Consumer<UserProvider>(builder: (context, userProvider, child) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios),
                      ),
                      Spacer(flex: 4),
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          debugPrint('更换头像');
                        },
                        child: CircleAvatar(
                          radius: 40,
                          child: (userProvider.user?.face.isEmpty ?? true)
                              ? Text(userProvider.user!.nickname[0],
                                  style: TextStyle(fontSize: 30))
                              : Image.network(userProvider.user!.face),
                        ),
                      ),
                      Spacer(flex: 5),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(color: Colors.grey),
                  SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    color: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('用户信息',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                        Divider(color: Colors.grey, height: 1),
                        _buildUnchangingItem('学号', userProvider.user!.sid),
                        Divider(color: Colors.grey, height: 1),
                        _buildUnchangingItem('姓名', userProvider.user!.name),
                        Divider(color: Colors.grey, height: 1),
                        _buildChangingItem('昵称', userProvider.user!.nickname,
                            _nicknameController),
                      ],
                    ),
                  ),
                ],
              );
            })),
      ),
    );
  }

  Widget _buildUnchangingItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 25)),
          Spacer(),
          Text(value, style: TextStyle(fontSize: 25)),
        ],
      ),
    );
  }

  Widget _buildChangingItem(
      String label, String value, TextEditingController controller) {
    return InkWell(
      onTap: () {
        debugPrint('修改$label');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('修改$label',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min, // 确保内容只占用必要空间
                children: [
                  TextField(
                    controller: controller,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (controller.text == '') {
                      Navigator.pop(context);
                      return;
                    }

                    debugPrint('确定修改$label:$controller.text');
                    final userProvider =
                        Provider.of<UserProvider>(context, listen: false);
                    if (userProvider.user != null) {
                      userProvider.user!.nickname = controller.text;
                      userProvider.saveUser(userProvider.user!);
                    }
                    controller.clear();
                    Navigator.pop(context);
                  },
                  child: Text('确定'),
                ),
                TextButton(
                  onPressed: () {
                    debugPrint('取消修改$label');
                    Navigator.pop(context);
                  },
                  child: Text('取消'),
                )
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Text(label, style: TextStyle(fontSize: 25)),
            Spacer(),
            Text(value, style: TextStyle(fontSize: 25)),
            SizedBox(width: 5),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }
}
