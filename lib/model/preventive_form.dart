import 'package:base_app/model/performance_form.dart';

class PreventiveForm {
  List<PerformanceForm>? step1;
  List<PerformanceForm>? step2;
  List<PerformanceForm>? step3;
  List<PerformanceForm>? step4;
  List<Step>? step5;

  PreventiveForm({this.step1, this.step2, this.step3, this.step4, this.step5});

  PreventiveForm.fromJson(Map<String, dynamic> json) {
    if (json['step1'] != null && json['step1'].isNotEmpty) {
      step1 = <PerformanceForm>[];
      json['step1'].forEach((v) {
        step1!.add(PerformanceForm.fromJson(v));
      });
    }
    if (json['step2'] != null && json['step2'].isNotEmpty) {
      step2 = <PerformanceForm>[];
      json['step2'].forEach((v) {
        step2!.add(PerformanceForm.fromJson(v));
      });
    }
    if (json['step3'] != null && json['step3'].isNotEmpty) {
      step3 = <PerformanceForm>[];
      json['step3'].forEach((v) {
        step3!.add(PerformanceForm.fromJson(v));
      });
    }
    if (json['step4'] != null && json['step4'].isNotEmpty) {
      step4 = <PerformanceForm>[];
      json['step4'].forEach((v) {
        step4!.add(PerformanceForm.fromJson(v));
      });
    }
    if (json['step5'] != null && json['step5'].isNotEmpty) {
      step5 = <Step>[];
      json['step5'].forEach((v) {
        step5!.add(Step.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['step1'] = step1?.map((v) => v.toJson()).toList();
    data['step2'] = step2?.map((v) => v.toJson()).toList();
    data['step3'] = step3?.map((v) => v.toJson()).toList();
    data['step4'] = step4?.map((v) => v.toJson()).toList();
    data['step5'] = step5?.map((v) => v.toJson()).toList();
    return data;
  }
}

class Step {
  int? id;
  int? cid;
  List<Content>? content;
  String? category;
  int? createTime;
  int? step;
  int? type;

  Step(
      {this.id,
        this.cid,
        this.content,
        this.category,
        this.createTime,
        this.step,
        this.type});

  Step.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cid = json['cid'];
    if (json['content'] != null && json['content'].isNotEmpty) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(Content.fromJson(v));
      });
    }
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
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    data['category'] = category;
    data['create_time'] = createTime;
    data['step'] = step;
    data['type'] = type;
    return data;
  }
}

class Content {
  String? num;
  String? desc;
  String? status;

  Content({this.num, this.desc, this.status});

  Content.fromJson(Map<String, dynamic> json) {
    num = json['num'];
    desc = json['desc'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['num'] = num;
    data['desc'] = desc;
    data['status'] = status;
    return data;
  }
}
