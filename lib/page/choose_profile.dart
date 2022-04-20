import 'package:auto_route/auto_route.dart';
import 'package:base_app/config/app_config.dart';
import 'package:base_app/model/index_entity.dart';
import 'package:base_app/page/commen.dart';
import 'package:base_app/page/top_company.dart';
import 'package:base_app/request/api.dart';
import 'package:base_app/router/app_router.gr.dart';
import 'package:base_app/util/cache_util.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChooseProfile extends StatefulWidget {
  const ChooseProfile({Key? key}) : super(key: key);

  @override
  _ChooseProfileState createState() => _ChooseProfileState();
}

class _ChooseProfileState extends State<ChooseProfile> {
  late Future<List<IndexSelect>> _company;

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
    _company = Api.index(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _company,
      builder: (BuildContext context, AsyncSnapshot<List<IndexSelect>> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Loading();
        }
        if(snapshot.hasError){
          return ErrorPage(error: snapshot.error.toString(),);
        }
        if(snapshot.hasData){
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const TopCompany(),
                    const SizedBox(height: 30,),
                    Text("Preventive Maintenance & Performance Monitoring",style: Theme.of(context).textTheme.headline6!,),
                    const SizedBox(height: 12,),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Text("name"),
                          // const Text("NAME"),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text("Customer",style: Theme.of(context).textTheme.headline6),
                          ),
                          SizedBox(
                            height: 50,
                            child: DropdownSearch<IndexSelect>(
                                mode: Mode.MENU,
                                showSelectedItems: false,
                                items: snapshot.data!.map((e) => e).toList(),
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
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12,top: 12),
                            child: Text("Type Of Check List",style: Theme.of(context).textTheme.headline6),),
                          SizedBox(
                            height: 50,
                            child: DropdownSearch<String>(
                                key: _categoryKey,
                                mode: Mode.MENU,
                                showSelectedItems: true,
                                items: _categories?.map((e) => e).toList()??[],
                                onChanged: (v){
                                  _category = v;
                                }
                            ),
                          ),
                          const SizedBox(height: 12,),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12,top: 12),
                            child: Text("Plant: ",style: Theme.of(context).textTheme.headline6,),),
                          SizedBox(
                            height: 50,
                            child:  DropdownSearch<String>(
                                key: _plantKey,
                                mode: Mode.MENU,
                                showSelectedItems: true,
                                items: _plants?.map((e) => e).toList()??[],
                                onChanged: (v){
                                  _plant = v;
                                }
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12,bottom: 12),
                      child: Text(DateFormat().format(DateTime.now())),
                    ),
                    ElevatedButton(
                        onPressed: (){
                          if(_category?.toLowerCase() == Category.performance.name){
                            AutoRouter.of(context).push(PerformanceRoute(indexSelect: _indexSelect!, plant: _plant!));
                          }
                          if(_category?.toLowerCase() == Category.preventive.name){
                            AutoRouter.of(context).push(PreventiveRoute(indexSelect: _indexSelect!, plant: _plant!));
                          }
                        },
                        child: const Text("ENTER")
                    ),
                    const SizedBox(height: 22,),
                    ElevatedButton(
                        onPressed: (){
                          CacheUtil.clear();
                          AutoRouter.of(context).replaceAll([ const LoginRoute()]);
                        },
                        child: const Text("Login Out")
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return  const ErrorPage(error: "no Data",);
      },);
  }
}
