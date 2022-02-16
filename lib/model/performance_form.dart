class PerformanceForm {
  int? id;
  int? cid;
  Content? content;
  String? category;
  int? createTime;
  int? step;
  int? type;

  PerformanceForm(
      {this.id,
        this.cid,
        this.content,
        this.category,
        this.createTime,
        this.step,
        this.type});

  PerformanceForm.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cid = json['cid'];
    content =
    json['content'] != null ? Content.fromJson(json['content']) : null;
    category = json['category'];
    createTime = json['create_time'];
    step = json['step'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cid'] = cid;
    if (content != null) {
      data['content'] = content!.toJson();
    }
    data['category'] = category;
    data['create_time'] = createTime;
    data['step'] = step;
    data['type'] = type;
    return data;
  }
}

class Content {
  String? title;
  String? first;
  List<Child>? child;

  Content({this.title, this.first, this.child});

  Content.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    first = json['first'];
    if (json['child'] != null) {
      child = <Child>[];
      json['child'].forEach((v) {
        child!.add(Child.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['first'] = first;
    if (child != null) {
      data['child'] = child!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Child {
  String? operate;
  String? value;
  String? lable;

  Child({this.operate, this.value, this.lable});

  Child.fromJson(Map<String, dynamic> json) {
    operate = json['operate'];
    value = json['value'];
    lable = json['lable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['operate'] = operate;
    data['value'] = value;
    data['lable'] = lable;
    return data;
  }
}
