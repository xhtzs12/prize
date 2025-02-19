class User {
  int uid; // 用户ID
  String sid; // 学号
  String name; // 姓名
  String nickname; // 昵称
  String face; // 头像
  String password; // 密码
  String unionid; // 微信用户的唯一ID

  // 带默认值的构造函数
  User({
    this.uid = 0,
    this.sid = '222200200222',
    this.name = '张三',
    this.nickname = '张三',
    this.face = 'https://picurl.billadom.top/2025/02/19/67b59900ae4eb.jpg',
    this.password = '111',
    this.unionid = 'ZS1234567890',
  });

  // 从 Map 中解析 User 对象
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] ?? 0,
      sid: json['sid'] ?? '',
      name: json['name'] ?? '',
      nickname: json['nickname'] ?? '',
      face: json['face'] ?? '',
      password: json['password'] ?? '',
      unionid: json['unionid'] ?? '',
    );
  }

  // 将 User 对象转换为 Map
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'sid': sid,
      'name': name,
      'nickname': nickname,
      'face': face,
      'password': password,
      'unionid': unionid,
    };
  }

  // 重写 toString 方法，方便调试
  @override
  String toString() {
    return 'User{uid: $uid, sid: $sid, name: $name, nickname: $nickname, face: $face, unionid: $unionid}';
  }
}
