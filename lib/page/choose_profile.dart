import 'package:base_app/model/company_entity.dart';
import 'package:base_app/model/index_entity.dart';
import 'package:base_app/page/top_company.dart';
import 'package:base_app/request/api.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChooseProfile extends StatefulWidget {
  const ChooseProfile({Key? key}) : super(key: key);

  @override
  _ChooseProfileState createState() => _ChooseProfileState();
}

class _ChooseProfileState extends State<ChooseProfile> {
  late Future<Company?> _company;

  ///选择的公司
  IndexSelect? _indexSelect;
  List<String>? _plants;
  List<String>? _categories;
  String? _plant;
  String? _category;
  final GlobalKey<DropdownSearchState> _plantKey = GlobalKey();
  final GlobalKey<DropdownSearchState> _categoryKey = GlobalKey();
  @override
  void initState() {
    _company = Api.company(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _company,
      builder: (BuildContext context, AsyncSnapshot<Company?> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Material(
            child: Center(
              child: Text("加载中"),
            ),
          );
        }
        if(snapshot.hasError){
          return  Material(
            child: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        }
        if(snapshot.hasData){
          Company company = snapshot.data!;
          return Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TopCompany(company: company,),

                  const Divider(),
                  const Text("preventive_maintenance_checklist"),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("name"),
                        Text("NAME"),
                        Text("Customer"),
                        DropdownSearch<IndexSelect>(
                            mode: Mode.MENU,
                            showSelectedItems: false,
                            items: company.indexSelect!.map((e) => e).toList(),
                            itemAsString: (e) => e!.name??'',
                            onChanged: (v){
                              if(v?.id != _indexSelect?.id){
                                _indexSelect = v;
                                _categories = v?.category??[];
                                _plants = v?.plant??[];
                                _plantKey.currentState?.clear();
                                _categoryKey.currentState?.clear();
                                setState(() {});
                              }
                            }
                        ),
                        Text("Type Of Check List"),
                        DropdownSearch<String>(
                            key: _categoryKey,
                            mode: Mode.MENU,
                            showSelectedItems: true,
                            items: _categories?.map((e) => e).toList()??[],
                            onChanged: (v){

                            }
                        ),
                        Text("Plant"),
                        DropdownSearch<String>(
                            key: _plantKey,
                            mode: Mode.MENU,
                            showSelectedItems: true,
                            items: _plants?.map((e) => e).toList()??[],
                            onChanged: (v){

                            }
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: (){},
                      child: const Text("ENTER")
                  ),
                  Text(DateFormat().format(DateTime.now()))
                ],
              ),
            ),
          );
        }
        return  const Material(
          child: Center(
            child: Text("no Data"),
          ),
        );
      },);
  }
}
