
import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:base_app/config/app_config.dart';
import 'package:base_app/config/input_formtter.dart';
import 'package:base_app/model/index_entity.dart';
import 'package:base_app/model/performance_form.dart';
import 'package:base_app/privider/auth_provider.dart';
import 'package:base_app/request/api.dart';
import 'package:base_app/util/request.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

import '../util/cache_util.dart';
import 'commen.dart';

class Performance extends StatefulWidget {
  final IndexSelect indexSelect;
  final String plant;

  const Performance({Key? key, required this.indexSelect, required this.plant})
      : super(key: key);

  @override
  _PerformanceState createState() => _PerformanceState();
}

class _PerformanceState extends State<Performance> {
  late Future<List<PerformanceForm>?> _performanceForm;
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.red,
    exportBackgroundColor: Colors.blue,
  );
  final TextEditingController _node1 = TextEditingController();
  final TextEditingController _node2 = TextEditingController();
  final TextEditingController _autographText = TextEditingController();
  Map<String,dynamic> extra = {};
  List<String> level1 = ["Root cause","Corrective action","Case settle on same day?","Type of Upset Condition","Diagnosis of Cause of Upset Condition (Root Cause)","Any Non Compliance of Discharge Standard Occurred","Corrective Action Taken"];
  List<String> level3 = ["Expected settle date","Expected Conditions Returned to Normal"];
  List<String> level4 = ["Expected Conditions Returned to Normal"];
  late String cacheId;
  List<String> lineTow = ["Root cause","Corrective action"];


  @override
  void initState() {
    cacheId = Provider.of<AuthProvider>(context,listen: false).authUserEntity!.name!+CacheKey.performance.name + widget.indexSelect.id!.toString() + widget.plant;
    String cache = CacheUtil.get(cacheId);
    if(cache.isNotEmpty){
      List<PerformanceForm> _pp= jsonDecode(cache)?.map<PerformanceForm>((e)=> PerformanceForm.fromJson(e)).toList() ;
      _performanceForm = Future.value(_pp);
    }else{
      _performanceForm = Api.performanceForm(context, widget.indexSelect.id!,widget.plant);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: _performanceForm,
      builder: (BuildContext context,
          AsyncSnapshot<List<PerformanceForm>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }
        if (snapshot.hasError) {
          return ErrorPage(
            error: snapshot.error.toString(),
          );
        }
        if (!snapshot.hasData) {
          return const ErrorPage(
            error: "no Data",
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(
                plant: widget.plant,
                customerName: widget.indexSelect.name ?? "",
                save: (){
                  CacheUtil.save(cacheId, jsonEncode(snapshot.data));
                },
              ),
              ...snapshot.data!.map((e) => Container(
                            margin: const EdgeInsets.only(top: 20,),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                    Text(e.content!.first! + "." + e.content!.title!),
                                    const SizedBox(height: 10,),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.background,
                                          borderRadius: BorderRadius.circular(22)
                                      ),
                                      child: Column(
                                        children:  e.content!.child!
                                            .map<Widget>((c) {
                                              if(level1.contains(c.lable)){
                                                return Offstage(
                                                  offstage: e.actualReading != "No",
                                                  child:  Container(
                                                    padding: const EdgeInsets.only(top: 20),
                                                    alignment: Alignment.centerLeft,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 100,
                                                              child: Text(c.lable ?? ""),
                                                            ),
                                                            Expanded(child:  _switchOperate(c,e))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                              if(level3.contains(c.lable)){
                                                return Offstage(
                                                  offstage: e.settleSameDay == "No",
                                                  child:  Container(
                                                    padding: const EdgeInsets.only(top: 20),
                                                    alignment: Alignment.centerLeft,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 100,
                                                              child: Text(c.lable ?? ""),
                                                            ),
                                                            Expanded(child:  _switchOperate(c,e))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                              return  Container(
                                                padding: const EdgeInsets.only(top: 20),
                                                alignment: Alignment.centerLeft,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 100,
                                                          child: Text(c.lable ?? ""),
                                                        ),
                                                        Expanded(child:  _switchOperate(c,e))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );


                                        }).toList(),
                                      ),
                                    )
                                  ]

                            ),
                          )).toList(),
              const SizedBox(height: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Performance Monitoring Comment:"),
                  const Text("* if case are not able to settle on same day and need extra support. Write down here."),
                  const SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(22)
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 100,
                          child:   Text("Note"),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(10)
                            ),
                            maxLines: 5,
                            minLines: 3,
                            controller: _node1,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Costomer additional comments (if any):"),
                  const SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(22)
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 100,
                          child:   Text("Note"),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10)
                            ),
                            maxLines: 5,
                            minLines: 3,
                            controller: _node2,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const Text("Performance Monitoring Done By :"),
                  Text(Provider.of<AuthProvider>(context,listen: false).authUserEntity!.name??"")
                ],
              ),
              const SizedBox(height: 10,),
              const Text("Customer Acknowledge:"),
              Container(
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide())
                ),
                child: GestureDetector(
                  onDoubleTap: (){
                    _controller.clear();
                  },
                  child: Signature(
                    controller: _controller,
                    height: 150,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const Text("Acknowledged by :"),
                  Expanded(
                      child: TextFormField( controller: _autographText,)
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const Text("Date: "),
                  Text(DateFormat().format(DateTime.now())),
                ],
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () async {
                      if(_controller.isEmpty){
                        Request.toast("Please complete required information.");
                        return;
                      }
                      String? isEmpty;
                      for (var per in snapshot.data!) {
                        for(var element in per.content!.child!){
                          if(isEmpty != null ) break;
                          if(element.operate ==  AppConfig.operate0) continue;
                          if(level1.contains(element.lable)){
                            if(isEmpty != null ) break;
                            if(per.actualReading =="No" && (element.value == null || element.value?.isEmpty == true)){
                              isEmpty = per.content!.title! + " " +(element.lable??"") ;
                              break;
                            }
                            continue;
                          }

                          if(level3.contains(element.lable)){
                            if(per.settleSameDay =="No" && (element.value == null || element.value?.isEmpty == true)){
                              isEmpty = per.content!.title! + " " +(element.lable??"") ;
                              break;
                            }
                            continue;
                          }
                          if(element.value == null || element.value?.isEmpty == true){
                            isEmpty = per.content!.title! + " " +(element.lable??"") ;
                            break;
                          }
                        }

                      }
                      if(isEmpty!=null ){
                        Logger().d( isEmpty + " is empty");
                        Request.toast( isEmpty  + " is empty");
                        return;
                      }
                      extra['note1'] = _node1.text;
                      extra['note2'] = _node2.text;
                      extra['autograph_text'] = _autographText.text;
                      Uint8List? bytes =  await _controller.toPngBytes();
                      extra['autograph_img'] = base64Encode(bytes!);
                      EasyLoading.show();
                      bool? success =  await Api.performanceSubmit(context, snapshot.data!,widget.indexSelect.id!,extra,widget.plant);
                      if(success==true){
                        AutoRouter.of(context).pop();
                        EasyLoading.dismiss();
                      }
                    },
                    child: const Text("Save")
                ),
              )
            ],
          ),
        );
      },
    ));
  }

  Widget _switchOperate(Child c,PerformanceForm form){
    if(c.operate == AppConfig.operate0){
      return Text(c.value??"");
    }if(c.operate == AppConfig.operate1){
      return TextFormField(
        initialValue: c.value,
        onChanged: (v){
          c.value = v;
        },
        minLines: textLines(c),
        maxLines: textLines(c),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 12,bottom: 12,left: 12),
          suffixIcon: Container(
            constraints:  const BoxConstraints(
                maxWidth: 50,
                minWidth: 20
            ),
            padding: const EdgeInsets.only(right: 12,top: 12,bottom: 12),
            child: Text(c.unit??""),
          ),
          suffixIconConstraints: const BoxConstraints(
            maxWidth: 50,
            minWidth: 20
          )
        ),
      );
    }if(c.operate == AppConfig.operate2){
      return SizedBox(
        height: 40,
        child: DropdownSearch<String>(
            selectedItem: c.value,
            showAsSuffixIcons: true,
            mode: Mode.MENU,
            showSelectedItems: true,
            items:const ["Yes","No"],
            onChanged: (v){
              c.value = v;
              if(c.lable == "Within setting range"){
                form.actualReading = v;
                setState(() {});
              }
              if(c.lable == "Case settle on same day?"){
                form.settleSameDay = v;
                setState(() {});
              }
            },

        ),
      );
    }
    if(c.operate == AppConfig.operate3){
      return  GestureDetector(
        onTap: (){
          showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365000))
          ).then((value) {
            if(value!=null){
              c.value = DateFormat().format(value);
              setState(() {});
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(c.value ==null || c.value!.isEmpty ?  "Choose Date" :c.value!,style: Theme.of(context).textTheme.bodyText1,),
        ),
      );
    }
    if(c.operate == AppConfig.operate4){
      return SizedBox(
        height: 40,
        child: DropdownSearch<String>(
            selectedItem: c.value,
            showAsSuffixIcons: true,
            mode: Mode.MENU,
            showSelectedItems: true,
            items:const ["Done","Not Done"],
            onChanged: (v){
              c.value = v;
            }
        ),
      );
    }
    if(c.operate == AppConfig.operate5){
      return SizedBox(
        height: 40,
        child: DropdownSearch<String>(
            selectedItem: c.value,
            showAsSuffixIcons: true,
            mode: Mode.MENU,
            showSelectedItems: true,
            items:const ["Clear","Turbid"],
            onChanged: (v){
              c.value = v;
            }
        ),
      );
    }
    if(c.operate == AppConfig.operate6){
      return TextFormField(
        initialValue: c.value,
        inputFormatters: [
          XNumberTextInputFormatter(maxIntegerLength: null, maxDecimalLength: 1,isAllowDecimal: true),],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (v){
          c.value = v;
        },
      );
    }
    if(c.operate == AppConfig.operate7){
      return SizedBox(
        height: 40,
        child: DropdownSearch<String>(
            selectedItem: c.value,
            showAsSuffixIcons: true,
            mode: Mode.MENU,
            showSelectedItems: true,
            items:const ["Clean","Dirty"],
            onChanged: (v){
              c.value = v;
            }
        ),
      );
    }
    if(c.operate == AppConfig.operate8){
      return  SizedBox(
        height: 40,
        child: DropdownSearch<String>(
            selectedItem: c.value,
            showAsSuffixIcons: true,
            mode: Mode.MENU,
            showSelectedItems: true,
            items:const ["Acceptable","To be improve"],
            onChanged: (v){
              c.value = v;
            }
        ),
      );
    }
    if(c.operate == AppConfig.operate9){
      return  SizedBox(
        height: 40,
        child: DropdownSearch<String>(
            selectedItem: c.value,
            showAsSuffixIcons: true,
            mode: Mode.MENU,
            showSelectedItems: true,
            items:const ["Good","Bad"],
            onChanged: (v){
              c.value = v;
            }
        ),
      );
    }
    if(c.operate == AppConfig.operate10){
      return  SizedBox(
        height: 40,
        child: DropdownSearch<String>(
            selectedItem: c.value,
            showAsSuffixIcons: true,
            mode: Mode.MENU,
            showSelectedItems: true,
            items:const ["Carry over","No carryover "],
            onChanged: (v){
              c.value = v;
            }
        ),
      );
    }
    if(c.operate == AppConfig.operate11){
      return  SizedBox(
        height: 40,
        child: DropdownSearch<String>(
            selectedItem: c.value,
            showAsSuffixIcons: true,
            mode: Mode.MENU,
            showSelectedItems: true,
            items:const ["Clear","Turbid"],
            onChanged: (v){
              c.value = v;
            }
        ),
      );
    }
    return Container();
  }

  textLines(Child child){
    if(lineTow.contains(child.lable)){
      return 5;
    }
    return 1;
  }
}

class PageHeader extends StatelessWidget {
  final String customerName;
  final String plant;
  final Function? save;

  const PageHeader({Key? key, required this.customerName, required this.plant, this.save})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Row(
          children: [
            Expanded(child: Text("Customer"+ customerName,style: Theme.of(context).textTheme.headline2!,overflow: TextOverflow.fade,)),
            if(save!=null)TextButton(onPressed: (){
              save!();
            }, child: const Text("Save")),
          ],
        ),
        const SizedBox(height: 12,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("Plant: ",style:  Theme.of(context).textTheme.headline6!,),
                Text(plant,style:  Theme.of(context).textTheme.headline6!),
              ],
            ),
            Row(
              children: [
                Text("Date: ", style:Theme.of(context).textTheme.headline6!),
                Text(DateFormat().format(DateTime.now()), style:Theme.of(context).textTheme.headline6!),
              ],
            ),
          ],
        )
      ],
    ));
  }
}
