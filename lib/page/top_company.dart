import 'package:base_app/privider/company_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopCompany extends StatefulWidget {
  const TopCompany({Key? key}) : super(key: key);

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
          Text(Provider.of<CompanyProvider>(context,listen: true).company?.title??"",style: Theme.of(context).textTheme.headline4,),
          const SizedBox(height: 12,),
          Text(Provider.of<CompanyProvider>(context,listen: true).company?.address??"",style: Theme.of(context).textTheme.headline6),
          const SizedBox(height: 10,),
          Row(
            children: [
              Text(Provider.of<CompanyProvider>(context,listen: true).company?.phone??"",style: Theme.of(context).textTheme.bodyText1),
              Text(Provider.of<CompanyProvider>(context,listen: true).company?.fax??"",style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              Text(Provider.of<CompanyProvider>(context,listen: true).company?.email??"",style: Theme.of(context).textTheme.bodyText1),
              Text(Provider.of<CompanyProvider>(context,listen: true).company?.site??"",style: Theme.of(context).textTheme.bodyText1),
            ],
          )
        ],
      ),
    );
  }
}
