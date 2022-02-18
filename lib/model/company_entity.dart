import 'package:base_app/model/index_entity.dart';

class Company {
  String? title;
  String? address;
  String? phone;
  String? fax;
  String? email;
  String? site;
  List<IndexSelect>? indexSelect;

  Company(
      {this.title, this.address, this.phone, this.fax, this.email, this.site,this.indexSelect});

  Company.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    address = json['address'];
    phone = json['phone'];
    fax = json['fax'];
    email = json['email'];
    site = json['site'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['address'] = address;
    data['phone'] = phone;
    data['fax'] = fax;
    data['email'] = email;
    data['site'] = site;
    return data;
  }
}
