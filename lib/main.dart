import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottery/Util/SPUtil.dart';
import 'package:lottery/data/User.dart';
import 'package:lottery/route/login_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SPUtils.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IndexProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..loadTheme()),
        ChangeNotifierProvider(create: (_) => UserProvider()..loadUser()),
        // 纯纯依托答辩，用了这俩Provider就跟废了样，更新不及时，这就是Future、async、和await啊。
        // 批斗时讲讲，哥。
        // FutureProvider<ThemeProvider>(
        //   create: (_) async {
        //     final themeProvider = ThemeProvider();
        //     await themeProvider.loadTheme(); // 确保加载完成
        //     return themeProvider; // 返回加载后的实例
        //   },
        //   initialData: ThemeProvider(), // 提供初始值
        // ),
        // FutureProvider<UserProvider>(
        //   create: (_) async {
        //     final userProvider = UserProvider();
        //     await userProvider.loadUser(); // 确保加载完成
        //     return userProvider; // 返回加载后的实例
        //   },
        //   initialData: UserProvider(), // 提供初始值
        // ),
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

class IndexProvider extends ChangeNotifier {
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
    saveTheme();
    notifyListeners(); // 通知监听者更新
  }

  // 加载主题设置
  Future<void> loadTheme() async {
    int? colorValue = SPUtils.getInt('seedColor');
    if (colorValue != null) {
      _seedColor = Color(colorValue);
    }
  }

  // 保存主题设置
  Future<void> saveTheme() async {
    await SPUtils.setInt('seedColor', _seedColor.value);
  }
}

class UserProvider with ChangeNotifier {
  User _user = User();

  User? get user => _user;

  // 保存用户数据到 SharedPreferences
  Future<void> saveUser(User user) async {
    try {
      await SPUtils.setString('user', jsonEncode(user.toJson()));
      _user = user;
      notifyListeners();
      debugPrint("保存用户信息");
    } catch (e) {
      debugPrint('Failed to save user: $e');
    }
  }

  // 从 SharedPreferences 加载用户数据
  Future<void> loadUser() async {
    final String? userJson = await SPUtils.getString('user');
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      _user = User.fromJson(userMap);
      notifyListeners();
      debugPrint("加载用户信息");
    }
  }

  // 清除用户数据
  Future<void> clearUser() async {
    await SPUtils.remove('user');
    _user = User();
    notifyListeners();
    debugPrint("清除用户信息");
  }
}

class GradientAppbar extends StatelessWidget implements PreferredSizeWidget {
  GradientAppbar({super.key});

  @override
  Size get preferredSize {
    final height = WidgetsBinding
        .instance.platformDispatcher.views.first.physicalSize.height;
    return Size.fromHeight(height * 0.03);
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

class UserListTile extends StatelessWidget {
  const UserListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<UserProvider, User?>(
      selector: (_, userProvider) => userProvider.user,
      builder: (context, user, child) {
        return ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: (user?.face.isEmpty ?? true)
                ? Text(user!.nickname[0], style: TextStyle(fontSize: 25))
                : ClipOval(
                    child: FadeInImage(
                      placeholder:
                          AssetImage('assets/loading.gif'), // 占位图
                      image: NetworkImage(user!.face),
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ),
                  ),
          ),
          title: Text(user.nickname),
          subtitle: Text('学号：${user.sid}'),
          onTap: () {
            Provider.of<IndexProvider>(context, listen: false)
                .updateSelectedIndex(2);
          },
        );
      },
    );
  }
}

class UserListTileD extends StatelessWidget {
  const UserListTileD({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<UserProvider, User?>(
      selector: (_, userProvider) => userProvider.user,
      builder: (context, user, child) {
        return ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: (user?.face.isEmpty ?? true)
                ? Text(user!.nickname[0], style: TextStyle(fontSize: 25))
                : ClipOval(
                    child: FadeInImage(
                      placeholder:
                          AssetImage('assets/loading.gif'), // 占位图
                      image: NetworkImage(user!.face),
                      fit: BoxFit.cover, // 确保图像填充整个圆形区域
                      width: 60, // 设置图像的宽度为两倍半径
                      height: 60, // 设置图像的高度为两倍半径
                    ),
                  ),
          ),
          title: Text(user.nickname),
          subtitle: Text('学号：${user.sid}'),
          onTap: () {
            Provider.of<IndexProvider>(context, listen: false)
                .updateSelectedIndex(2);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
