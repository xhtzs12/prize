import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery/data/Prize.dart';
import 'package:lottery/main.dart';

class CommonLotteryPage extends StatefulWidget {
  CommonLotteryPage({super.key});

  @override
  _CommonLotteryPageState createState() => _CommonLotteryPageState();
}

class _CommonLotteryPageState extends State<CommonLotteryPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? time;
  int? timestamp;
  int? joinMethod;
  int joinLimit = 0;
  String? textNotice;
  String? imageNotice;

  List<Prize> prizeList = [];

  TextEditingController _joinLimitController = TextEditingController();
  TextEditingController _prizeTypeController = TextEditingController();
  TextEditingController _prizeNameController = TextEditingController();
  TextEditingController _prizeNumberController = TextEditingController();
  TextEditingController _prizeDescriptionController = TextEditingController();

  void showDateTimePicker() async {
    debugPrint('选择时间');
    if (!mounted) return;
    // Step 1: Show Date Picker
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().add(Duration(minutes: 1)),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Step 2: Show Time Picker
      debugPrint('pickedDate:$pickedDate');
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        selectedDate = pickedDate;
        selectedTime = pickedTime;

        DateTime prizeTime = DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          selectedTime!.hour,
          selectedTime!.minute,
          //其余默认为零
        );
        setState(() {
          time = prizeTime.toLocal().toString().split('.')[0];
          debugPrint(time);
        });
        timestamp = prizeTime.microsecondsSinceEpoch;
        debugPrint("$timestamp");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
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
              SizedBox(height: 10),
              //开奖设置
              Card(
                elevation: 4,
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    _buildTitle('开奖时间'),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          debugPrint('时间');
                          showDateTimePicker();
                        },
                        child: _buildItem('时间', time == null ? '' : time!),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              //参与人员设置
              Card(
                elevation: 4,
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    _buildTitle('参与人员'),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          debugPrint('参与人数');
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('设置参与人数',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min, // 确保内容只占用必要空间
                                  children: [
                                    TextField(
                                      controller: _joinLimitController,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      if (_joinLimitController.text == '') {
                                        Navigator.pop(context);
                                        return;
                                      } else {
                                        joinLimit = int.parse(
                                            _joinLimitController.text);
                                        setState(() {});
                                        debugPrint('确定修改参与人数$joinLimit');
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('确定'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      debugPrint('取消修改');
                                      Navigator.pop(context);
                                    },
                                    child: Text('取消'),
                                  )
                                ],
                              );
                            },
                          );
                        },
                        child: _buildItem('参与人数', '$joinLimit'),
                      ),
                    ),
                    Divider(color: Colors.grey),
                    RadioListTile<int>(
                      title: Text('仅限发起者分享参与'),
                      value: 1,
                      groupValue: joinMethod,
                      onChanged: (int? value) {
                        setState(() {
                          joinMethod = value;
                        });
                        debugPrint('joinMethod:$joinMethod');
                      },
                    ),
                    RadioListTile<int>(
                      title: Text('仅限群成员可参与'),
                      value: 2,
                      groupValue: joinMethod,
                      onChanged: (int? value) {
                        setState(() {
                          joinMethod = value;
                        });
                        debugPrint('joinMethod:$joinMethod');
                      },
                    ),
                    RadioListTile<int>(
                      title: Text('无限制'),
                      value: 3,
                      groupValue: joinMethod,
                      onChanged: (int? value) {
                        setState(() {
                          joinMethod = value;
                        });
                        debugPrint('joinMethod:$joinMethod');
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              //抽奖说明设置

              Card(
                elevation: 4,
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    _buildTitle('抽奖说明'),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          debugPrint('抽奖说明');
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('设置抽奖说明',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min, // 确保内容只占用必要空间
                                  children: [
                                    TextField(
                                      controller: _joinLimitController,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      if (_joinLimitController.text == '') {
                                        Navigator.pop(context);
                                        return;
                                      } else {
                                        joinLimit = int.parse(
                                            _joinLimitController.text);
                                        setState(() {});
                                        debugPrint('确定修改参与人数$joinLimit');
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('确定'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      debugPrint('取消修改');
                                      Navigator.pop(context);
                                    },
                                    child: Text('取消'),
                                  )
                                ],
                              );
                            },
                          );
                        },
                        child: _buildItem('抽奖说明', ''),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              //奖品设置

              Card(
                elevation: 4,
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    _buildTitle('奖品信息'),
                    Padding(
                        padding: EdgeInsets.all(8.0), child: _buildListView()),
                    Center(
                      child: InkWell(
                        onTap: () {
                          debugPrint('添加奖品');
                          _showPrizeDialog('添加');
                        },
                        child: SizedBox(height: 50, child: Icon(Icons.add)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              //发起抽奖

              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  debugPrint('发起抽奖');
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('确认发起抽奖吗？',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          actions: [
                            TextButton(
                              onPressed: () {

                                Navigator.pop(context);
                                debugPrint('确定');
                              },
                              child: Text('确定'),
                            ),
                            TextButton(
                              onPressed: () {
                                
                                Navigator.pop(context);
                                debugPrint('取消');
                              },
                              child: Text('取消'),
                            )
                          ],
                        );
                      });
                },
                child: Center(
                  heightFactor: 2,
                  child: Text(
                    '发起抽奖',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 24)),
          Spacer(),
          Text(value, style: TextStyle(fontSize: 15)),
          SizedBox(width: 5),
          Icon(Icons.arrow_forward_ios)
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryFixed,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      padding: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        controller: controller,
      ),
    );
  }

  void _showPrizeDialog(String lable) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$lable奖品',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min, // 确保内容只占用必要空间
            children: [
              _buildTextField('奖品等级（必填）', _prizeTypeController),
              _buildTextField('奖品名（必填）', _prizeNameController),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: '奖品名（必填）',
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // 只允许输入数字
                  ],
                  controller: _prizeNumberController,
                ),
              ),
              _buildTextField('奖品描述（可选）', _prizeDescriptionController)
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_prizeTypeController.text == '' ||
                    _prizeNameController.text == '' ||
                    _prizeNumberController.text == '') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('必填项不能为空'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                  return;
                } else {
                  Prize addedPrize = Prize(
                      type: _prizeTypeController.text,
                      name: _prizeNameController.text,
                      number: int.parse(_prizeNumberController.text),
                      description: _prizeDescriptionController.text);
                  prizeList.add(addedPrize);
                  setState(() {});
                  _prizeDescriptionController.clear();
                  _prizeNameController.clear();
                  _prizeNumberController.clear();
                  _prizeTypeController.clear();
                  Navigator.pop(context);
                  debugPrint('确定$lable奖品');
                }
              },
              child: Text('确定'),
            ),
            TextButton(
              onPressed: () {
                _prizeDescriptionController.clear();
                _prizeNameController.clear();
                _prizeNumberController.clear();
                _prizeTypeController.clear();
                Navigator.pop(context);
                debugPrint('取消$lable');
              },
              child: Text('取消'),
            )
          ],
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      shrinkWrap: true, // 允许 ListView 根据内容动态调整高度
      physics: NeverScrollableScrollPhysics(), // 禁止滚动
      separatorBuilder: (context, index) =>
          Divider(color: Colors.grey, height: 1),
      itemCount: prizeList.length,
      itemBuilder: (context, index) {
        Prize indexPrize = prizeList[index];
        return InkWell(
          onTap: () {
            _prizeDescriptionController.text = indexPrize.description;
            _prizeNameController.text = indexPrize.name;
            _prizeNumberController.text = indexPrize.number.toString();
            _prizeTypeController.text = indexPrize.type;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('修改奖品',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min, // 确保内容只占用必要空间
                    children: [
                      _buildTextField('奖品等级（必填）', _prizeTypeController),
                      _buildTextField('奖品名（必填）', _prizeNameController),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: '奖品名（必填）',
                            border: OutlineInputBorder(),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly, // 只允许输入数字
                          ],
                          controller: _prizeNumberController,
                        ),
                      ),
                      _buildTextField('奖品描述（可选）', _prizeDescriptionController)
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        if (_prizeTypeController.text == '' ||
                            _prizeNameController.text == '' ||
                            _prizeNumberController.text == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('必填项不能为空'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                          return;
                        } else {
                          Prize changedPrize = Prize(
                              type: _prizeTypeController.text,
                              name: _prizeNameController.text,
                              number: int.parse(_prizeNumberController.text),
                              description: _prizeDescriptionController.text);
                          prizeList[index] = changedPrize;
                          setState(() {});
                          _prizeDescriptionController.clear();
                          _prizeNameController.clear();
                          _prizeNumberController.clear();
                          _prizeTypeController.clear();
                          Navigator.pop(context);
                          debugPrint('确定修改奖品');
                        }
                      },
                      child: Text('确定'),
                    ),
                    TextButton(
                      onPressed: () {
                        _prizeDescriptionController.clear();
                        _prizeNameController.clear();
                        _prizeNumberController.clear();
                        _prizeTypeController.clear();
                        Navigator.pop(context);
                        debugPrint('取消修改');
                      },
                      child: Text('取消'),
                    )
                  ],
                );
              },
            );
          },
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      indexPrize.type,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.secondaryFixedDim),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        prizeList.removeAt(index);
                        setState(() {});
                      },
                      child: Icon(Icons.delete),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Center(
                  child: (indexPrize.picture.isEmpty)
                      ? Icon(Icons.image, size: 50)
                      : Image.network(
                          indexPrize.picture,
                          fit: BoxFit.fill,
                        ),
                ),
                _buildItem('奖品名称', indexPrize.name),
                _buildItem('奖品数量', indexPrize.number.toString())
              ],
            ),
          ),
        );
      },
    );
  }
}
