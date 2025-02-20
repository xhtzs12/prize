import 'package:flutter/material.dart';
import 'package:lottery/data/LotteryResponse.dart';
import 'package:lottery/main.dart';

class DisplayLotteryPage extends StatefulWidget {
  final List<LotteryResponse> lotteries; // 抽奖信息列表
  final String title; // 页面标题

  // 构造函数，接收数据和标题
  const DisplayLotteryPage(
      {required this.lotteries, required this.title, super.key});

  @override
  State<DisplayLotteryPage> createState() => _DisplayLotteryPageState();
}

class _DisplayLotteryPageState extends State<DisplayLotteryPage> {
  late List<LotteryResponse> lotteryResponseList;
  late String title;

  @override
  void initState() {
    super.initState();
    // 初始化数据
    lotteryResponseList = widget.lotteries;
    title = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserListTileD(),
              Divider(color: Colors.grey, height: 1),
              SizedBox(height: 10),
              Card(
                elevation: 4,
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    _buildTitle(title),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            _buildIfNothing(),
                            _buildListView()
                          ],
                        )),
                  ],
                ),
              ),
              _buildListView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      shrinkWrap: true, // 允许 ListView 根据内容动态调整高度
      physics: NeverScrollableScrollPhysics(), // 禁止滚动
      separatorBuilder: (context, index) =>
          Divider(color: Colors.grey, height: 1),
      itemCount: lotteryResponseList.length,
      itemBuilder: (context, index) {
        LotteryResponse lotteryResponse = lotteryResponseList[index];
        String startTime =
            DateTime.fromMillisecondsSinceEpoch(lotteryResponse.start)
                .toLocal()
                .toString()
                .split('.')[0];
        String endTime =
            DateTime.fromMillisecondsSinceEpoch(lotteryResponse.end)
                .toLocal()
                .toString()
                .split('.')[0];
        return InkWell(
          onTap: () {
            debugPrint('抽奖$index详细信息');
          },
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Center(
                  child: (lotteryResponse.picture.isEmpty)
                      ? Icon(Icons.image, size: 50)
                      : Image.network(
                          lotteryResponse.picture,
                          fit: BoxFit.fill,
                        ),
                ),
                _buildItem('发布时间', startTime),
                _buildItem('截止时间', endTime),
                _buildItem('参加人数', lotteryResponse.number.toString())
              ],
            ),
          ),
        );
      },
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

  Widget _buildItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 24)),
          Spacer(),
          Text(value, style: TextStyle(fontSize: 15)),
          SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget _buildIfNothing() {
    if (lotteryResponseList.isEmpty) {
      return Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                '什么都没有哦。',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
          ),
        ],
      );
    } else {
      return SizedBox(height: 10);
    }
  }
}
