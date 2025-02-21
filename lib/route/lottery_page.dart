import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottery/main.dart';
import 'package:lottery/route/joining_lottery_page.dart';
import 'package:lottery/util/HttpUtils.dart';
import 'package:provider/provider.dart';

class LotteryPage extends StatelessWidget {
  const LotteryPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _urlController = TextEditingController();

    Future<void> getJoiningLotteryInfo(String url) async {
      debugPrint("查询抽奖");
      HttpUtils httpUtils = HttpUtils();
      try {
        Response response = await httpUtils.get(url);
        debugPrint('响应数据: ${response.data}');
        if (response.data['code'] == 200) {
          String data = response.data['data'];
          Map<String, dynamic> responseMap = httpUtils.parsePrizeResponse(data);
          debugPrint("查询奖品成功");
          debugPrint(responseMap.toString());
          List<dynamic> dynamicList = responseMap['prizes'];
          dynamic info = responseMap['info'];
          debugPrint(info.toString());
          Provider.of<DataProvider>(context, listen: false)
              .update(dynamicList, info);
          int lotteryId = int.parse(url.split('=')[1]);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => JoiningLotteryPage(lotteryId: lotteryId)));
        } else {
          debugPrint("查询奖品失败");
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

    Future<void> getLotteryFromURL(String url) async {
      debugPrint("由链接参与抽奖");
      HttpUtils httpUtils = HttpUtils();
      try {
        Response response = await httpUtils.get(url);
        debugPrint('响应数据: ${response.data}');
        if (response.data != '' && response.data['code'] == 200) {
          String lotteryLink = response.data['data'];
          getJoiningLotteryInfo(lotteryLink);
          debugPrint("由链接参与抽奖成功");
          debugPrint(lotteryLink);
        } else {
          debugPrint("由链接参与抽奖失败");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('请检查链接是否正确'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      } on DioException catch (e) {
        debugPrint('请求错误: ${e.message}');
        if (e.response != null) {
          debugPrint('状态码: ${e.response!.statusCode}');
          debugPrint('响应数据: ${e.response!.data}');
        } else {
          debugPrint('请求未发送或未收到响应');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('请检查链接是否正确'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserListTile(),
            Divider(color: Colors.grey),
            Spacer(flex: 2),
            Center(
              child: Column(
                children: [
                  TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      labelText: '请输入链接或是参与码',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: InkWell(
                      onTap: () {
                        debugPrint('参与抽奖');
                        String url = _urlController.text;
                        Provider.of<DataProvider>(context, listen: false)
                            .clear();
                        getLotteryFromURL(url);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.secondaryFixed,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.width * 0.35,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryFixedDim,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          Text(
                            '参与抽奖',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.07,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
