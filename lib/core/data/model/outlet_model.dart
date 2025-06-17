class OutletModel {
  OutletModel({
    required this.id,
    required this.name,
  });

  late final int id;
  late final String name;

  OutletModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is OutletModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
