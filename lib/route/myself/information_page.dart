import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottery/data/User.dart';
import 'package:lottery/main.dart';
import 'package:lottery/util/HttpUtils.dart';
import 'package:provider/provider.dart';

class InformationPage extends StatefulWidget {
  InformationPage({super.key});

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  TextEditingController _nicknameController = TextEditingController();

  Future<void> updateUserNickname(String nickname) async {
    debugPrint("上传用户昵称");
    HttpUtils httpUtils = HttpUtils();
    User u = Provider.of<UserProvider>(context, listen: false).user!;
    final params = {'uid': u.uid, 'nickname': nickname};
    debugPrint('请求参数: $params ');
    try {
      Response response = await httpUtils.get(
          'http://drawlots.billadom.top/updateUserNickname',
          params: params);
      debugPrint('响应数据: ${response.data}');
      if (response.data['code'] == 200) {
        debugPrint("上传用户昵称成功");
      } else {
        debugPrint("上传用户昵称失败: ${response.data['message']}");
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          debugPrint('个人信息页面返回');
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios),
                      ),
                      Spacer(flex: 8),
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          debugPrint('更换头像');
                          showImagePickerSheet(context);
                        },
                        child: CircleAvatar(
                          radius: 40,
                          child: (userProvider.user!.face.isEmpty)
                              ? Text(userProvider.user!.nickname[0],
                                  style: TextStyle(fontSize: 30))
                              : ClipOval(
                                  child: FadeInImage(
                                    placeholder:
                                        AssetImage('assets/loading.gif'), // 占位图
                                    image:
                                        NetworkImage(userProvider.user!.face),
                                    fit: BoxFit.cover, // 确保图像填充整个圆形区域
                                    width: 80, // 设置图像的宽度为两倍半径
                                    height: 80, // 设置图像的高度为两倍半径
                                  ),
                                ),
                        ),
                      ),
                      Spacer(flex: 9),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(color: Colors.grey),
                  SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    color: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('用户信息',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                        Divider(color: Colors.grey, height: 1),
                        _buildUnchangingItem('学号', userProvider.user!.sid),
                        Divider(color: Colors.grey, height: 1),
                        _buildUnchangingItem('姓名', userProvider.user!.name),
                        Divider(color: Colors.grey, height: 1),
                        _buildChangingItem('昵称', userProvider.user!.nickname,
                            _nicknameController),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void showImagePickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    '拍照',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _openCamera();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    '从相册选择',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _openGallery();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 上传图片
  Future<void> _uploadImage(imageFile) async {
    if (imageFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('请先选择图片')));
      return;
    }
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile!.path,
            filename: 'image.jpg'),
      });

      Response response = await Dio().post(
        'http://pic.billadom.top/api/v1/upload',
        data: formData,
      );
      debugPrint('响应数据: ${response.data}');
      if (response.data['status']) {
        debugPrint("上传用户头像成功");
        User u = Provider.of<UserProvider>(context, listen: false).user!;
        u.face = response.data['data']['links']['url'];
        Provider.of<UserProvider>(context, listen: false).saveUser(u);
        debugPrint(u.face);
      } else {
        debugPrint("上传用户头像失败: ${response.data['message']}");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('上传成功')),
      );
    } on DioException catch (e) {
      debugPrint('请求错误: ${e.message}');
      if (e.response != null) {
        debugPrint('状态码: ${e.response!.statusCode}');
        debugPrint('响应数据: ${e.response!.data}');
      } else {
        debugPrint('请求未发送或未收到响应');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('上传失败')),
      );
    }
  }

  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      // 处理图片
      debugPrint('上传图片');
      final File file = File(image.path);
      _uploadImage(file);
    } else {
      debugPrint('未选择图片');
    }
  }

  Future<void> _openGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // 处理图片
      debugPrint('上传图片');
      final File file = File(image.path);
      _uploadImage(file);
    } else {
      debugPrint('未选择图片');
    }
  }

  Widget _buildUnchangingItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 25)),
          Spacer(),
          Text(value, style: TextStyle(fontSize: 25)),
        ],
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('新昵称不能为空'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      Navigator.pop(context);
                      return;
                    }
                    String changedNickName = controller.text;
                    debugPrint('确定修改$label:$controller.text');
                    final userProvider =
                        Provider.of<UserProvider>(context, listen: false);
                    User user = userProvider.user!;
                    user.nickname = changedNickName;
                    userProvider.saveUser(user);
                    updateUserNickname(changedNickName);
                    controller.clear();
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
