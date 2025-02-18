import 'package:flutter/material.dart';
import 'package:lottery/route/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyProvider(), //bottombar的选择监听
      child: const MyApp(),
    ),
  );
}

class MyProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

class ThemeProvider extends ChangeNotifier {
  Color _seedColor = Colors.red;

  Color get seedColor => _seedColor;

  void switchTheme(Color themeColor) {
    _seedColor = themeColor;
    notifyListeners(); // 通知监听者更新
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white, // 设置全局背景色为纯白色
              colorScheme: ColorScheme.fromSeed(
                seedColor: themeProvider.seedColor,
                dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
              ),
            ),
            debugShowCheckedModeBanner: false,
            home: LoginPage(),
          );
        },
      ),
    );
  }
}

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

class GradientAppbar extends StatelessWidget implements PreferredSizeWidget {
  GradientAppbar({super.key});

  @override
  Size get preferredSize {
    final height = WidgetsBinding.instance.window.physicalSize.height;
    return Size.fromHeight(height * 0.05);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent, // AppBar背景色设置为透明
      elevation: 0, // 去掉阴影
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          // 使用渐变效果
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.0)
            ],
            begin: Alignment(0, 0.5),
            end: Alignment(0, 1.0),
          ),
        ),
      ),
    );
  }
}
