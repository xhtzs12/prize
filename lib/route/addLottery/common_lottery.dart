import 'package:flutter/material.dart';
import 'package:lottery/main.dart';
import 'package:provider/provider.dart';

class CommonLottery extends StatefulWidget {
  const CommonLottery({super.key});

  @override
  _CommonLotteryState createState() => _CommonLotteryState();
}

class _CommonLotteryState extends State<CommonLottery> {
  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.now();
    int timestamp = time.millisecondsSinceEpoch;
    return Scaffold(
      appBar: GradientAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserListTileD(),
            Divider(color: Colors.grey, height: 1),
            SizedBox(height: 10),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Center(
                heightFactor: 2,
                child: Text(
                  '通用抽奖',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Card(
              elevation: 4,
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryFixed,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16))),
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '开奖时间',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey),
                  Divider(color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
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
