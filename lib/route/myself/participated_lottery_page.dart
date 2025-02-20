import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottery/data/LotteryResponse.dart';
import 'package:lottery/main.dart';

class ParticipatedLotteryPage extends StatefulWidget {
  const ParticipatedLotteryPage({super.key});

  @override
  State<ParticipatedLotteryPage> createState() =>
      _ParticipatedLotteryPageState();
}

class _ParticipatedLotteryPageState extends State<ParticipatedLotteryPage> {
  List<LotteryResponse> lotteryResponseList = [];

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
              _buildIfNothing(),
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
          SizedBox(height: 10),
          Center(
            child: Text(
              '什么都没有哦。',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ),
        ],
      );
    } else {
      return SizedBox(height: 10);
    }
  }
}
