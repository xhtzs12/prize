import 'package:flutter/material.dart';
import 'package:lottery/main.dart';
import 'package:provider/provider.dart';

class PalettePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios),
                ),
                Expanded(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Text('张', style: TextStyle(fontSize: 25)),
                    ),
                    title: Text('张三'),
                    subtitle: Text('学号：12345676890'),
                    onTap: () {
                      Provider.of<MyProvider>(context, listen: false)
                          .updateSelectedIndex(2);
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
            Divider(color: Colors.grey),
            Spacer(),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                debugPrint('主题设置-红色');
                Provider.of<ThemeProvider>(context,listen: false).switchTheme(Colors.red);
              },
              child: Card(
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        '红色',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Expanded(child: SizedBox(height: 40)),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                debugPrint('主题设置-蓝色');
                Provider.of<ThemeProvider>(context,listen: false).switchTheme(Colors.blue);
              },
              child: Card(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        '蓝色',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Expanded(child: SizedBox(height: 40)),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                debugPrint('主题设置-粉色');
                Provider.of<ThemeProvider>(context,listen: false).switchTheme(Colors.pink);
              },
              child: Card(
                color: Colors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        '粉色',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Expanded(child: SizedBox(height: 40)),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                debugPrint('主题设置-紫色');
                Provider.of<ThemeProvider>(context,listen: false).switchTheme(Colors.purple);
              },
              child: Card(
                color: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        '紫色',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Expanded(child: SizedBox(height: 40)),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              ),
            ),
            Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
