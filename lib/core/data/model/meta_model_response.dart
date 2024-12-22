
class Meta {
  Meta({
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
  late final int? currentPage;
  late final int lastPage;
  late final int total;

  Meta.fromJson(Map<String, dynamic> json){
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['current_page'] = currentPage;
    _data['last_page'] = lastPage;
    _data['total'] = total;
    return _data;
  }
}

