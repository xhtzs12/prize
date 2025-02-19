import 'package:flutter/material.dart';
import 'package:lottery/main.dart';
import 'package:lottery/route/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isAgree = false;
  TextEditingController _unameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 1),
            Card(
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8, // 设置宽度
                height: MediaQuery.of(context).size.height * 0.1, // 设置高度
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // 垂直居中
                  children: [
                    Text(
                      '今天你抽卡了吗',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.secondaryFixedDim),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(flex: 1),
            TextField(
              decoration: InputDecoration(
                labelText: '请输入账号',
                border: OutlineInputBorder(),
              ),
              controller: _unameController,
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: '请输入密码',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              controller: _pwdController,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // 登录按钮的处理逻辑
                if (_isAgree) {
                  if (_unameController.text == '' ||
                      _pwdController.text == '') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('请输入用户名和密码'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    debugPrint(_unameController.text);
                    debugPrint(_pwdController.text);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('请同意下方协议'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: const Text('登录'),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: _isAgree,
                  shape: CircleBorder(),
                  onChanged: (value) {
                    setState(() {
                      _isAgree = value!;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    '我已阅读并同意《隐私政策》及《账号声明》',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}