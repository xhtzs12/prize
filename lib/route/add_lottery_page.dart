import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottery/data/LotteryResponse.dart';
import 'package:lottery/main.dart';
import 'package:lottery/route/addLottery/common_lottery_page.dart';
import 'package:lottery/route/addLottery/instant_lottery_page.dart';
import 'package:lottery/route/display_lottery_page.dart';
import 'package:lottery/util/HttpUtils.dart';
import 'package:provider/provider.dart';

class AddLotteryPage extends StatelessWidget {
  const AddLotteryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final secondaryFixed = Theme.of(context).cardColor;

    Future<void> getLotteryList(int uid, String url) async {
      debugPrint("查询抽奖");
      HttpUtils httpUtils = HttpUtils();
      final params = {'uid': uid};
      try {
        Response response = await httpUtils
            .get('http://drawlots.billadom.top/lots$url', params: params);
        debugPrint('响应数据: ${response.data}');
        if (response.data['code'] == 200) {
          String lotteryList = response.data['data'];

          List<LotteryResponse> lotteryResponseList =
              httpUtils.parseLotteryResponse(lotteryList);

          Provider.of<LotteryResponseListProvider>(context, listen: false)
              .update(lotteryResponseList);
          debugPrint("查询抽奖成功");
        } else {
          debugPrint("查询抽奖失败");
        }
      } on DioException catch (e) {
        debugPrint('请求错误: ${e.message}');
        if (e.response != null) {
          debugPrint('状态码: ${e.response!.statusCode}');
          debugPrint('响应数据: ${e.response!.data}');
        } else {
          debugPrint('请求未发送或未收到响应');
        }
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserListTile(),
              Divider(color: Colors.grey),
              SizedBox(height: 20),
              Center(
                child: Card(
                  color: Colors.grey[100],
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.25,
                    child: Column(
                      children: [
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).colorScheme.primaryFixed,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16))),
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text('创建抽奖',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)))),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            debugPrint('通用抽奖');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommonLotteryPage()));
                          },
                          child: Container(
                            width: screenWidth * 0.6,
                            decoration: BoxDecoration(
                                color: secondaryFixed,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child:
                                  Text('通用抽奖', style: TextStyle(fontSize: 28)),
                            ),
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            debugPrint('随机数生成');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        InstantLotteryPage()));
                          },
                          child: Container(
                            width: screenWidth * 0.6,
                            decoration: BoxDecoration(
                                color: secondaryFixed,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child:
                                  Text('随机数生成', style: TextStyle(fontSize: 28)),
                            ),
                          ),
                        ),
                        Spacer()
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Card(
                  color: Colors.grey[100],
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.1,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Spacer(),
                          InkWell(
                            onTap: () {
                              debugPrint('已发布的抽奖');
                              int uid = Provider.of<UserProvider>(context,
                                      listen: false)
                                  .user!
                                  .uid;
                              Provider.of<LotteryResponseListProvider>(context,listen: false).clear();
                              getLotteryList(uid, '/created');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DisplayLotteryPage(title: '已发布抽奖')));
                            },
                            child: Container(
                              width: screenWidth * 0.6,
                              decoration: BoxDecoration(
                                  color: secondaryFixed,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text('已发布的抽奖',
                                    style: TextStyle(fontSize: 28)),
                              ),
                            ),
                          ),
                          Spacer()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
