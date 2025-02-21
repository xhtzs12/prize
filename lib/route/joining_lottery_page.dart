import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottery/main.dart';
import 'package:lottery/util/HttpUtils.dart';
import 'package:provider/provider.dart';

class JoiningLotteryPage extends StatefulWidget {
  final int lotteryId;

  // 构造函数，接收数据和标题
  const JoiningLotteryPage({required this.lotteryId, super.key});

  @override
  State<JoiningLotteryPage> createState() => _JoiningLotteryPageState();
}

class _JoiningLotteryPageState extends State<JoiningLotteryPage> {
  late int lotteryId;

  @override
  void initState() {
    super.initState();
    // 初始化数据
    lotteryId = widget.lotteryId;
  }

  Future<void> confrimJoinLottery(Map<String, dynamic> userMap) async {
    HttpUtils httpUtils = HttpUtils();
    final formData = FormData.fromMap(userMap);

    try {
      Response response = await httpUtils
          .post('http://drawlots.billadom.top/lots/join', data: formData);
      debugPrint('响应数据: ${response.data}');
      if (response.data != '' && response.data['code'] == 200) {
        debugPrint('确认参与成功');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('参与成功'),
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        debugPrint('确认参与失败');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('参与失败'),
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
      debugPrint('确认参与失败');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('参与失败'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppbar(),
      body: Consumer<DataProvider>(
        builder: (context, provider, child) {
          dynamic data = provider.data;
          String startTime = '';
          String endTime = '';
          String jionNumber = '';
          String jionMethod = '';
          String type = '';
          // 检查 data 是否为空或不为map
          if (data != null && data is Map && data.containsKey('time')) {
            switch (data['join']['method']) {
              case 1:
                jionMethod = '仅限发起者分享参与';
                break;
              case 2:
                jionMethod = '仅限群成员可参与';
                break;
              case 3:
                jionMethod = '无限制';
                break;
              default:
                break;
            }

            switch (data['type']) {
              case 1:
                type = '按时间开奖';
                jionNumber = '无限制';
                break;
              case 2:
                type = '按人数开奖';
                jionNumber = data['join']['number'];
                break;
              case 3:
                type = '即开即抽';
                jionNumber = '无限制';
                break;
              default:
                break;
            }
            startTime =
                DateTime.fromMillisecondsSinceEpoch(data['time']['start'])
                    .toLocal()
                    .toString()
                    .split('.')[0];
            endTime = DateTime.fromMillisecondsSinceEpoch(data['time']['end'])
                .toLocal()
                .toString()
                .split('.')[0];
          } else {
            debugPrint("data 为空或不包含 'time' 键");
          }

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
                        _buildTitle('抽奖信息'),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              _buildItem('发布时间', startTime),
                              _buildItem('截止时间', endTime),
                              _buildItem('抽奖类型', type),
                              _buildItem('参与方式', jionMethod),
                              _buildItem('可参与人数', jionNumber),
                            ],
                          ),
                        ),
                      ],
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
                        _buildTitle('奖品详情'),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              _buildIfNothing(provider.dynamicList),
                              _buildListView(provider.dynamicList)
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

      // 添加一个浮动按钮
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // 按钮点击事件
          debugPrint('确认参与');
          int id = lotteryId;
          int uid = Provider.of<UserProvider>(context, listen: false).user!.uid;
          confrimJoinLottery({'id': id, 'uid': uid});
        },
        isExtended: true, // 设置为 true 使按钮更宽
        backgroundColor:
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.6),
        label: Text(
          '确认参与',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildListView(List<dynamic> dynamicList) {
    return ListView.separated(
      shrinkWrap: true, // 允许 ListView 根据内容动态调整高度
      physics: NeverScrollableScrollPhysics(), // 禁止滚动
      separatorBuilder: (context, index) =>
          Divider(color: Colors.grey, height: 1),
      itemCount: dynamicList.length,
      itemBuilder: (context, index) {
        dynamic item = dynamicList[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              debugPrint('奖品$index');
            },
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Center(
                    child: FadeInImage(
                      width: 160,
                      height: 120,
                      placeholder: AssetImage('assets/loading.gif'), // 加载中的占位图
                      image: NetworkImage(item['picture']),
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
                  _buildItem('奖品名称', item['name']),
                  _buildItem('奖品数量', item['number'].toString())
                ],
              ),
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
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
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

  Widget _buildIfNothing(List<dynamic> dynamicList) {
    if (dynamicList.isEmpty) {
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
