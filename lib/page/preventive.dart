
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:base_app/config/app_config.dart';
import 'package:base_app/config/input_formtter.dart';
import 'package:base_app/model/index_entity.dart';
import 'package:base_app/model/performance_form.dart';
import 'package:base_app/model/preventive_form.dart';
import 'package:base_app/page/commen.dart';
import 'package:base_app/page/performance.dart';
import 'package:base_app/privider/auth_provider.dart';
import 'package:base_app/request/api.dart';
import 'package:base_app/util/cache_util.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart' hide Step;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

class Preventive extends StatefulWidget {
  final IndexSelect indexSelect;
  final String plant;
  const Preventive({Key? key, required this.indexSelect, required this.plant}) : super(key: key);

  @override
  _PreventiveState createState() => _PreventiveState();
}

class _PreventiveState extends State<Preventive> {
  Map<String,dynamic> extra = {};
  late Future<PreventiveForm?> _future;
  final List<String> _title = ['Pump','Dosing Pump','DAF System','pH Calibration','Front end check list'];
  final PageController _controller = PageController();
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.red,
    exportBackgroundColor: Colors.blue,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );
  final TextEditingController _node2 = TextEditingController();
  final TextEditingController _autographText = TextEditingController();
  int pageIndex = 0;

  int lastIndex = 0;

  @override
  void initState() {
    String cache = CacheUtil.get(CacheKey.preventive.name + widget.indexSelect.id!.toString() + widget.plant);
    if(cache.isNotEmpty){
      _future = Future.value(PreventiveForm.fromJson(jsonDecode(cache)));
    }
    _future = Api.preventiveForm(context, widget.indexSelect.id!);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<PreventiveForm?> snapshot) {
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
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: PageHeader(
                  plant: widget.plant,
                  customerName: widget.indexSelect.name ?? "",
                ),
              ),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.toJson().keys.length,
                  padding: const EdgeInsets.only(right: 12),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(left: 12,bottom: 12,top: 12),
                      decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).colorScheme.background),
                          borderRadius: BorderRadius.circular(12),
                          color: pageIndex == index ? Theme.of(context).colorScheme.background : Colors.white
                      ),
                      child: Row(
                        children: [
                          Text(_title[index]),
                          const SizedBox(width: 8,),
                          Icon(Icons.check_circle_outline,color: index < lastIndex ? Colors.greenAccent : Colors.grey,)
                        ],
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (i){
                    pageIndex = i;
                    if(i<lastIndex){
                      lastIndex = i;
                    }
                    setState(() {});
                  },
                  itemCount: snapshot.data!.toJson().keys.length,
                  itemBuilder: (BuildContext context, int index) {
                    List<List<PerformanceForm>?> perfrom = [snapshot.data!.step1,snapshot.data!.step2,snapshot.data!.step3,snapshot.data!.step4];
                    List<Step>? step = snapshot.data!.step5;
                    if(index == 4){
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: step!=null && step.isNotEmpty ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: step.map<Widget>((e) =>
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: e.content?.map((e) => Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 30,
                                            child:  Text(e.num??""),
                                          ),
                                          Expanded(child: Text(e.desc??"")),
                                          SizedBox(
                                            height: 40,
                                            width: 100,
                                            child: DropdownSearch<String>(
                                                mode: Mode.MENU,
                                                showSelectedItems: true,
                                                items:const ["Done","Not Done"],
                                                onChanged: (v){

                                                }
                                            ),
                                          )
                                        ],
                                      ),
                                    )).toList()??[const ErrorPage(error: "no Data",)],
                                  ),
                                )
                            ).toList()+
                                [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Comments:"),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.background,
                                            borderRadius: BorderRadius.circular(22)
                                        ),
                                        child: Row(
                                          children: [
                                            const Text("note"),
                                            Expanded(
                                              child: TextFormField(
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
                                  Row(
                                    children: [
                                      const Text("Performance Monitoring Done By :"),
                                      Text(Provider.of<AuthProvider>(context,listen: false).authUserEntity.name??"")
                                    ],
                                  ),
                                  const Text("Customer Acknowledge:"),
                                  Row(
                                    children: [
                                      const Text("签名"),
                                      Expanded(
                                        child: Signature(
                                          controller: _signatureController,
                                          height: 150,
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Acknowledged by :"),
                                      Expanded(
                                          child: TextFormField( controller: _autographText,)
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Date"),
                                      Text(DateFormat().format(DateTime.now())),
                                    ],
                                  ),
                                  ElevatedButton(onPressed: (){_save(snapshot.data!);}, child: const Text("Save"))
                                ]
                        ) : const ErrorPage(error: "no Data",),
                      );
                    }else{
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: perfrom[index]!=null && perfrom[index]!.isNotEmpty ?  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: perfrom[index]!.map<Widget>((e) =>
                              Container(
                                margin: const EdgeInsets.only(top: 20,),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Location:" + e.content!.location!),
                                      Text(e.content!.first! + "." + e.content!.machine!),
                                      const SizedBox(height: 10,),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.background,
                                            borderRadius: BorderRadius.circular(22)
                                        ),
                                        child: Column(
                                          children:  e.content!.child!
                                              .map<Widget>((c) =>
                                              Container(
                                                padding: const EdgeInsets.only(top: 20),
                                                alignment: Alignment.centerLeft,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                          width: 100,
                                                          child: Text(c.lable ?? ""),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                          child:  Text(c.letter??""),
                                                        ),
                                                        Expanded(child:  _switchOperate(c))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ))
                                              .toList(),
                                        ),
                                      )
                                    ]

                                ),
                              )
                          ).toList() +
                              [
                                ElevatedButton(
                                    onPressed: (){
                                      _save(snapshot.data!);
                                    },
                                    child: const Text("Save")
                                )
                              ],
                        ) : const ErrorPage(error: "no Data",),
                      );
                    }
                  },),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _switchOperate(Child c){
    if(c.operate == AppConfig.preOperate0){
      return Text(c.value??"");
    }if(c.operate == AppConfig.preOperate1){
      return TextFormField(
        onChanged: (v){
          c.value = v;
        },
      );
    }if(c.operate == AppConfig.preOperate2){
      return TextFormField(
        inputFormatters: [
          XNumberTextInputFormatter(maxIntegerLength: null, maxDecimalLength: 1,isAllowDecimal: true),],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (v){
          c.value = v;
        },
      );
    }
    if(c.operate == AppConfig.preOperate3){
      return  SizedBox(
        height: 40,
        child: DropdownSearch<String>(
            mode: Mode.MENU,
            showSelectedItems: true,
            items:const ["Poor condition","Good condition","No equipment at side"],
            onChanged: (v){
              c.value = v;
            }
        ),
      );
    }
    if(c.operate == AppConfig.preOperate4){
      return SizedBox(
        height: 40,
        child: DropdownSearch<String>(
            mode: Mode.MENU,
            showSelectedItems: true,
            items:const ["To be improve","Acceptable"],
            onChanged: (v){
              c.value = v;
            }
        ),
      );
    }
    if(c.operate == AppConfig.preOperate5){
      return TextFormField(
        inputFormatters: [
          XNumberTextInputFormatter(maxIntegerLength: null, maxDecimalLength: 2,isAllowDecimal: true),],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (v){
          c.value = v;
        },
      );
    }
    if(c.operate == AppConfig.preOperate6){
      return SizedBox(
        height: 40,
        child: DropdownSearch<String>(
            mode: Mode.MENU,
            showSelectedItems: true,
            items:const ["Have white buble","Don’t have white bubble"],
            onChanged: (v){
              c.value = v;
            }
        ),
      );
    }
    if(c.operate == AppConfig.preOperate7){
      return TextFormField(
        inputFormatters: [
          XNumberTextInputFormatter(maxIntegerLength: null, maxDecimalLength: 2,isAllowDecimal: true),
          MaxMinTextInputFormatter(14.00,0.00)
        ],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (v){
          c.value = v;
        },
      );
    }
    if(c.operate == AppConfig.preOperate8){}
    else{
      return  SizedBox(
        height: 40,
        child: DropdownSearch<String>(
            mode: Mode.MENU,
            showSelectedItems: true,
            items:const ["Bad condition","Good condition","Unable to calibrate","No pH probe onsite"],
            onChanged: (v){
              c.value = v;
            }
        ),
      );
    }
    return Container();
  }

  _save(PreventiveForm preventive) async {
    CacheUtil.save(CacheKey.preventive.name + widget.indexSelect.id!.toString() + widget.plant, jsonEncode(preventive.toJson()));
    if(pageIndex <4 ){
      _controller.jumpToPage(pageIndex+1);
    }else{
      extra['note1'] = _node2.text;
      extra['autograph_text'] = _autographText.text;
      Uint8List? bytes =  await _signatureController.toPngBytes();
      extra['autograph_img'] = base64Encode(bytes!);
      extra['autograph_img'] = _signatureController;
      Api.preventiveSubmit(context,preventive,widget.indexSelect.id!,extra,widget.plant);
    }
  }
}
