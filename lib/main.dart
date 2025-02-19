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
    }
  }

  // 清除用户数据
  Future<void> clearUser() async {
    await SPUtils.remove('user');
    _user = User();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IndexProvider()),
        FutureProvider<ThemeProvider>(
          create: (_) async {
            final themeProvider = ThemeProvider();
            await themeProvider.loadTheme(); // 确保加载完成
            return themeProvider; // 返回加载后的实例
          },
          initialData: ThemeProvider(), // 提供初始值
        ),
        FutureProvider<UserProvider>(
          create: (_) async {
            final userProvider = UserProvider();
            await userProvider.loadUser(); // 确保加载完成
            return userProvider; // 返回加载后的实例
          },
          initialData: UserProvider(), // 提供初始值
        ),
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
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: (userProvider.user?.face.isEmpty ?? true)
              ? Text(userProvider.user?.nickname[0] ?? 'U',
                  style: TextStyle(fontSize: 25))
              : Image.network(userProvider.user!.face),
        ),
        title: Text(userProvider.user?.nickname ?? 'user'),
        subtitle: Text(
            '学号：${(userProvider.user?.sid ?? '').isEmpty ? '1234567890' : userProvider.user!.sid}'),
        onTap: () {
          Provider.of<IndexProvider>(context, listen: false)
              .updateSelectedIndex(2);
        },
      );
    });
  }
}

class UserListTileD extends StatelessWidget {
  const UserListTileD({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: (userProvider.user?.face.isEmpty ?? true)
              ? Text(userProvider.user?.nickname[0] ?? 'U',
                  style: TextStyle(fontSize: 25))
              : Image.network(userProvider.user!.face),
        ),
        title: Text(userProvider.user?.nickname ?? 'user'),
        subtitle: Text(
            '学号：${(userProvider.user?.sid ?? '').isEmpty ? '1234567890' : userProvider.user!.sid}'),
        onTap: () {
          Provider.of<IndexProvider>(context, listen: false)
              .updateSelectedIndex(2);
          Navigator.pop(context);
        },
      );
    });
  }
}
