import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottery/data/LotteryResponse.dart';
import 'package:lottery/data/Prize.dart';
import 'package:lottery/main.dart';
import 'package:lottery/route/display_prize_page.dart';
import 'package:lottery/util/HttpUtils.dart';
import 'package:provider/provider.dart';

class DisplayLotteryPage extends StatefulWidget {
  final String title; // 页面标题

  // 构造函数，接收数据和标题
  const DisplayLotteryPage({required this.title, super.key});

  @override
  State<DisplayLotteryPage> createState() => _DisplayLotteryPageState();
}

class _DisplayLotteryPageState extends State<DisplayLotteryPage> {
  late String title;

  @override
  void initState() {
    super.initState();
    // 初始化数据
    title = widget.title;
  }

  Future<void> _getlink(int uid, int lotteryId) async {
    debugPrint("生成分享链接");
    HttpUtils httpUtils = HttpUtils();
    final params = {'id': lotteryId, 'uid': uid};
    try {
      Response response = await httpUtils
          .get('http://drawlots.billadom.top/lots/glink', params: params);
      debugPrint('响应数据: ${response.data}');
      if (response.data != '') {
        String lotteryLink = response.data['data'];
        copyToClipboard(lotteryLink, context);
        debugPrint("生成分享链接成功");
      } else {
        debugPrint("生成分享链接失败");
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

  Future<void> getPrizeList(int id) async {
    debugPrint("查询奖品");
    HttpUtils httpUtils = HttpUtils();
    final params = {'id': id};
    try {
      Response response = await httpUtils.get(
          'http://drawlots.billadom.top/lots/detailedinfo',
          params: params);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppbar(),
      body: Consumer<LotteryResponseListProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
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
                              _buildIfNothing(provider.lotteryResponseList),
                              _buildListView(provider.lotteryResponseList)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView(List<LotteryResponse> lList) {
    int uid = Provider.of<UserProvider>(context).user!.uid;
    return ListView.separated(
      shrinkWrap: true, // 允许 ListView 根据内容动态调整高度
      physics: NeverScrollableScrollPhysics(), // 禁止滚动
      separatorBuilder: (context, index) =>
          Divider(color: Colors.grey, height: 1),
      itemCount: lList.length,
      itemBuilder: (context, index) {
        LotteryResponse lotteryResponse = lList[index];

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
            Provider.of<DataProvider>(context, listen: false).clear();
            getPrizeList(lotteryResponse.id);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DisplayPrizePage(title: '奖品详情')));
          },
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        (index + 1).toString(),
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryFixedDim),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          debugPrint('分享抽奖${lotteryResponse.id}');
                          _getlink(uid, lotteryResponse.id);
                        },
                        child: Icon(
                          Icons.share,
                          size: 35,
                        ),
                      )
                    ],
                  ),
                ),
                Center(
                  child: FadeInImage(
                    width: 160,
                    height: 120,
                    placeholder: AssetImage('assets/loading.gif'), // 加载中的占位图
                    image: NetworkImage(lotteryResponse.picture),
                    fit: BoxFit.fill,
                    imageErrorBuilder: (context, error, stackTrace) {
                      // 图片加载失败时的占位图
                      return Column(
                        children: [
                          Icon(Icons.image, size: 50),
                          Text('图片加载错误', style: TextStyle(fontSize: 20)),
                        ],
                      );
                    },
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

  Widget _buildIfNothing(List<LotteryResponse> lList) {
    if (lList.isEmpty) {
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
      return SizedBox();
    }
  }
}
