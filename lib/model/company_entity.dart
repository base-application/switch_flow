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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['fax'] = this.fax;
    data['email'] = this.email;
    data['site'] = this.site;
    return data;
  }
}
