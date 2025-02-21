import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery/data/User.dart';
import 'package:lottery/main.dart';
import 'package:lottery/route/home_page.dart';
import 'package:lottery/util/HttpUtils.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isAgree = false;
  TextEditingController _unameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  Future<void> loginSDU(Map<String, dynamic> userMap) async {
    HttpUtils httpUtils = HttpUtils();
    final formData = FormData.fromMap(userMap);

    try {
      Response response = await httpUtils
          .post('http://drawlots.billadom.top/SDULogin', data: formData);
      debugPrint('响应数据: ${response.data}');
      if (response.data == '') {
        debugPrint('账号密码错误');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('请检查用户名和密码是否正确'),
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        User u = User.fromJson(response.data);
        Provider.of<UserProvider>(context, listen: false).saveUser(u);
        debugPrint(u.toString());
        Provider.of<IndexProvider>(context, listen: false)
            .updateSelectedIndex(0);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    } on DioException catch (e) {
      debugPrint('请求错误: ${e.message}');
      if (e.response != null) {
        debugPrint('状态码: ${e.response!.statusCode}');
        debugPrint('响应数据: ${e.response!.data}');
      } else {
        debugPrint('请求未发送或未收到响应');
      }
      String errorMessage =
          '请求错误 ${e.response?.statusCode} ${e.response?.data['error'] ?? 'Unknown error'}';
      debugPrint(errorMessage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

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
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
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
                String sid = _unameController.text;
                String password = _pwdController.text;
                if (_isAgree) {
                  if (sid.length != 12 || password == '') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('请检查用户名和密码是否正确'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  } else {
                    debugPrint(sid);
                    debugPrint(password);
                    Map<String, String> userNP = {
                      'sid': sid,
                      'password': password
                    };
                    loginSDU(userNP);
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => HomePage()));
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
