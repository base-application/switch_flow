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
          Text(widget.company.title??"",style: Theme.of(context).textTheme.headline4,),
          Text(widget.company.address??"",style: Theme.of(context).textTheme.headline6),
          Row(
            children: [
              Text(widget.company.phone??"",style: Theme.of(context).textTheme.bodyText1),
              Text(widget.company.fax??"",style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
          Row(
            children: [
              Text(widget.company.email??"",style: Theme.of(context).textTheme.bodyText1),
              Text(widget.company.site??"",style: Theme.of(context).textTheme.bodyText1),
            ],
          )
        ],
      ),
    );
  }
}
