class Prize {
  String type; // 几等奖
  String name; // 奖品名称
  int number; // 中奖人数
  String picture; // 奖品图片链接url
  String description; // 奖品描述

  // 默认构造函数
  Prize({
    this.type = '',
    this.name = '',
    this.number = 0,
    this.picture = '',
    this.description = '',
  });

  // 命名构造函数，从 JSON 创建 Prize 对象
  factory Prize.fromJson(Map<String, dynamic> json) {
    return Prize(
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      number: json['number'] ?? 0,
      picture: json['picture'] ?? '',
      description: json['description'] ?? '',
    );
  }

  // 将 Prize 对象转换为 JSON 格式
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      'number': number,
      'picture': picture,
      'description': description,
    };
  }

  // 获取 Prize 对象的字符串表示
  @override
  String toString() {
    return 'Prize{type: $type, name: $name, number: $number, picture: $picture, description: $description}';
  }
}
