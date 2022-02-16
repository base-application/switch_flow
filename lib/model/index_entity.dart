class IndexSelect {
  int? id;
  String? name;
  List<String>? plant;
  List<String>? category;

  IndexSelect({this.id, this.name, this.plant, this.category});

  IndexSelect.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    plant = json['plant'].cast<String>();
    category = json['category'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['plant'] = plant;
    data['category'] = category;
    return data;
  }
}
