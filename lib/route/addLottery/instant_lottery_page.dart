import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery/main.dart';

class InstantLotteryPage extends StatefulWidget {
  InstantLotteryPage({super.key});

  @override
  _InstantLotteryPageState createState() => _InstantLotteryPageState();
}

class _InstantLotteryPageState extends State<InstantLotteryPage> {
  final TextEditingController _maxController = TextEditingController();
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _countController = TextEditingController();

  final Random _random = Random(); // 创建 Random 实例
  List<int> _randomNumbers = [];
  int min = 0;
  int max = 0;
  int count = 0;

  // 方法：生成随机数
  void generateRandomNumbers(BuildContext context) {
    if (_countController.text == '' ||
        _maxController.text == '' ||
        _minController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请补全数据')),
      );
      return;
    } else {
      count = int.parse(_countController.text);
      min = int.parse(_minController.text);
      max = int.parse(_maxController.text);
    }

    if (min > max) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('上下限错误')),
      );
      return;
    }

    if (count <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('个数不能小于零')),
      );
      return;
    }

    _randomNumbers.clear();

    for (int i = 0; i < count; i++) {
      int randomNumber = _random.nextInt(max - min + 1) + min;
      _randomNumbers.add(randomNumber);
    }

    int length = _randomNumbers.length;

    debugPrint(length.toString());
    String result = '';
    for (var num in _randomNumbers) {
      result += '$num ';
    }
    debugPrint(_randomNumbers.toString());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      '结果',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Divider(color: Colors.grey),
                    Text(result, style: TextStyle(fontSize: 18)),
                    Divider(color: Colors.grey),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('确定'))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserListTileD(),
              Divider(color: Colors.grey),
              SizedBox(height: 10),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Center(
                  heightFactor: 2,
                  child: Text(
                    '随机数生成',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 20),
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
                      child: Center(
                        child: Text(
                          '抽奖设置',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _maxController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, // 只允许输入数字
                        ],
                        decoration: InputDecoration(
                          labelText: '输入随机数上限',
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _minController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, // 只允许输入数字
                        ],
                        decoration: InputDecoration(
                          labelText: '输入随机数下限',
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _countController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, // 只允许输入数字
                        ],
                        decoration: InputDecoration(
                          labelText: '生成随机数个数',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => generateRandomNumbers(context),
                  child: Text('生成随机数'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
