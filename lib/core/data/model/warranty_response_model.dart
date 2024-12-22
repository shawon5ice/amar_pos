class Warranty {
  Warranty({
    required this.id,
    required this.name,
    required this.type,
    required this.count,
  });
  late final int id;
  late final String name;
  late final int type;
  late final int count;

  Warranty.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    type = json['type'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['type'] = type;
    _data['count'] = count;
    return _data;
  }
}