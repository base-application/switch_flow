import 'package:base_app/model/company_entity.dart';
import 'package:flutter/material.dart';

class TopCompany extends StatefulWidget {
  final Company company;
  const TopCompany({Key? key, required this.company}) : super(key: key);

  @override
  _TopCompanyState createState() => _TopCompanyState();
}

class _TopCompanyState extends State<TopCompany> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(widget.company.title??""),
          Text(widget.company.address??""),
          Row(
            children: [
              Text(widget.company.phone??""),
              Text(widget.company.fax??""),
            ],
          ),
          Row(
            children: [
              Text(widget.company.email??""),
              Text(widget.company.site??""),
            ],
          )
        ],
      ),
    );
  }
}
