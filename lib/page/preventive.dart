
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:base_app/config/app_config.dart';
import 'package:base_app/config/input_formtter.dart';
import 'package:base_app/model/index_entity.dart';
import 'package:base_app/model/performance_form.dart' ;
import 'package:base_app/model/preventive_form.dart'  hide Content;
import 'package:base_app/page/commen.dart';
import 'package:base_app/page/performance.dart';
import 'package:base_app/privider/auth_provider.dart';
import 'package:base_app/request/api.dart';
import 'package:base_app/util/cache_util.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart' hide Step;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:collection/collection.dart';

import '../util/request.dart';

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
  );
  final TextEditingController _node2 = TextEditingController();
  final TextEditingController _autographText = TextEditingController();
  int pageIndex = 0;

  int lastIndex = 0;


  String calibratedVolume = "Calibrated volume (ml)";
  String calibratedTime = "Calibration time (sec)";
  String calibratedTime10 = "Calibration Time";

  late String cacheId ;

  @override
  void initState() {
    cacheId = Provider.of<AuthProvider>(context,listen: false).authUserEntity!.name!+CacheKey.preventive.name + widget.indexSelect.id!.toString() + widget.plant;
    String cache = CacheUtil.get(cacheId);
    if(cache.isNotEmpty){
      PreventiveForm _pp= PreventiveForm.fromJson(jsonDecode(cache));
      _future = Future.value(_pp);
    }else{
      _future = Api.preventiveForm(context, widget.indexSelect.id!,widget.plant);
    }
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
                  save: (){
                    CacheUtil.save(cacheId, jsonEncode(snapshot.data!.toJson()));
                  },
                ),
              ),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.toJson().keys.length,
                  padding: const EdgeInsets.only(right: 12),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        pageIndex = index;
                        _controller.jumpToPage(index);
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(left: 12,bottom: 12,top: 12),
                        decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).colorScheme.background),
                            borderRadius: BorderRadius.circular(12),
                            color: pageIndex == index ? const Color(0xffccddff) : Colors.white
                        ),
                        child: Row(
                          children: [
                            Text(_title[index]),
                            const SizedBox(width: 8,),
                            Icon(Icons.check_circle_outline,color: index < lastIndex ? Colors.greenAccent : Colors.grey,)
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: PageView.builder(
                  allowImplicitScrolling: true,
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (i){
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
                            children: step.map<Widget>((s) =>
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: s.content?.map((e) => Container(
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
                                          if(e.fill == true) SizedBox(
                                            height: 40,
                                            width: 100,
                                            child: DropdownSearch<String>(
                                                showAsSuffixIcons: true,
                                                mode: Mode.MENU,
                                                showSelectedItems: true,
                                                selectedItem: e.status,
                                                items:const ["Done","Not Done"],
                                                onChanged: (v){
                                                  e.status = v;
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
                                      const SizedBox(height: 12,),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(22)
                                        ),
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
                                  const SizedBox(height: 12,),
                                  Row(
                                    children: [
                                      const Text("Performance Monitoring Done By :"),
                                      Text(Provider.of<AuthProvider>(context,listen: false).authUserEntity!.name??"")
                                    ],
                                  ),
                                  const SizedBox(height: 12,),
                                  const Text("Customer Acknowledge:"),
                                  Container(
                                    decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide())
                                    ),
                                    child: GestureDetector(
                                      onDoubleTap: (){
                                        _signatureController.clear();
                                      },
                                      child: Signature(
                                        controller: _signatureController,
                                        height: 150,
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12,),
                                  Row(
                                    children: [
                                      const Text("Acknowledged by :"),
                                      Expanded(
                                          child: TextFormField( controller: _autographText,)
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 12,),
                                  Row(
                                    children: [
                                      const Text("Date"),
                                      Text(DateFormat().format(DateTime.now())),
                                    ],
                                  ),
                                  const SizedBox(height: 12,),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: ElevatedButton(
                                          onPressed: (){
                                            _pre();
                                          },
                                          child: const Text("Back")
                                          )
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(child:  ElevatedButton(
                                          onPressed: (){
                                            _save(snapshot.data!);
                                          },
                                          child: const Text("Save")
                                      ))
                                    ],
                                  )
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
                                      if(e.content!.title != "Comments")Text("Location:" + e.content!.location!),
                                      if(e.content!.title != "Comments")Text((e.content!.num?.toString()??'') + "." + e.content!.machine!),
                                      if(e.content!.title != "Comments") const SizedBox(height: 10,),
                                      Container(
                                        padding: const EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 20),
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
                                                          child: Text(HtmlCharacterEntities.decode(c.lable ?? "")),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                          child:  Text(c.letter??""),
                                                        ),
                                                        Expanded(child:  _switchOperate(c,e.content!))
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
                                const SizedBox(height: 12,),
                                Row(
                                  children: [
                                    if(pageIndex>0) Expanded(
                                        child: ElevatedButton(
                                            onPressed: (){
                                              _pre();
                                            },
                                            child: const Text("Back")
                                        )
                                    ),
                                    if(pageIndex>0) const SizedBox(width: 12,),
                                    Expanded(child:  ElevatedButton(
                                        onPressed: (){
                                          _save(snapshot.data!);
                                        },
                                        child: const Text("Next")
                                    ))
                                  ],
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

  Widget _switchOperate(Child c,Content p){
    if(c.operate == AppConfig.preOperate0){
      return Text(c.value??"");
    }if(c.operate == AppConfig.preOperate1){
      return TextFormField(
        initialValue: c.value,
        onChanged: (v){
          c.value = v;
        },
        decoration: InputDecoration(
            suffixIcon: Container(
              constraints:  const BoxConstraints(
                  maxWidth: 50,
                  minWidth: 20
              ),
              padding: const EdgeInsets.only(right: 12),
              child: Text(c.unit??""),
            ),
            suffixIconConstraints: const BoxConstraints(
                maxWidth: 50,
                minWidth: 20
            )
        ),
      );
    }if(c.operate == AppConfig.preOperate2){
      return TextFormField(
        initialValue: c.value,
        inputFormatters: [
          XNumberTextInputFormatter(maxIntegerLength: null, maxDecimalLength: 1,isAllowDecimal: true),],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (v){
          c.value = v;
          setState(() {});
        },
      );
    }
    if(c.operate == AppConfig.preOperate3){
      return  SizedBox(
        height: 40,
        child: DropdownSearch<String>(
            showAsSuffixIcons: true,
            mode: Mode.MENU,
            showSelectedItems: true,
            selectedItem: c.value,
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
            showAsSuffixIcons: true,
            mode: Mode.MENU,
            showSelectedItems: true,
            selectedItem: c.value,
            items:const ["To be improve","Acceptable"],
            onChanged: (v){
              c.value = v;
            }
        ),
      );
    }
    if(c.operate == AppConfig.preOperate5){
      return TextFormField(
        initialValue: c.value,
        inputFormatters: [
          XNumberTextInputFormatter(maxIntegerLength: null, maxDecimalLength: 2,isAllowDecimal: true),],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (v){
          c.value = v;
          setState(() {});
        },
      );
    }
    if(c.operate == AppConfig.preOperate6){
      return SizedBox(
        height: 40,
        child: DropdownSearch<String>(
            showAsSuffixIcons: true,
            mode: Mode.MENU,
            showSelectedItems: true,
            items:const ["Have white buble","Don’t have white bubble"],
            selectedItem: c.value,
            onChanged: (v){
              c.value = v;
            }
        ),
      );
    }
    if(c.operate == AppConfig.preOperate7){
      return TextFormField(
        initialValue: c.value,
        inputFormatters: [
          XNumberTextInputFormatter(maxIntegerLength: null, maxDecimalLength: 2,isAllowDecimal: true),
          MaxMinTextInputFormatter(14.00,0.00)
        ],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (v){
          c.value = v;
          setState(() {});
        },
      );
    }
    if(c.operate == AppConfig.preOperate8){
      return SizedBox(
        height: 40,
        child: DropdownSearch<String>(
            showAsSuffixIcons: true,
            mode: Mode.MENU,
            showSelectedItems: true,
            selectedItem: c.value,
            items:const ["Bad condition","Good condition","Unable to calibrate","No pH probe onsite"],
            onChanged: (v){
              c.value = v;
            }
        ),
      );
    }
    if(c.operate == AppConfig.preOperate9){
      return Text(_valueOper9(p));
    }
    if(c.operate == AppConfig.preOperate10){
      return Text(_valueOper10(p));
    }
    if(c.operate == AppConfig.preOperate8){
      return SizedBox(
        height: 40,
        child: DropdownSearch<String>(
            showAsSuffixIcons: true,
            mode: Mode.MENU,
            showSelectedItems: true,
            selectedItem: c.value,
            items:const ["Bad condition","Good condition","Unable to calibrate","No pH probe onsite"],
            onChanged: (v){
              c.value = v;
            }
        ),
      );
    }
    else{
      return  SizedBox(
        height: 40,
        child: DropdownSearch<String>(
            selectedItem: c.value,
            showAsSuffixIcons: true,
            mode: Mode.MENU,
            showSelectedItems: true,
            items:const ["Bad condition","Good condition","Unable to calibrate","No pH probe onsite"],
            onChanged: (v){
              c.value = v;
            }
        ),
      );
    }
  }

  _save(PreventiveForm preventive) async {
    CacheUtil.save(cacheId, jsonEncode(preventive.toJson()));
    if(pageIndex <4 ){
      _controller.jumpToPage(pageIndex+1);
      pageIndex = _controller.page!.toInt();
      if(pageIndex>lastIndex){
        lastIndex = pageIndex;
      }
    }else{
      if(_signatureController.isEmpty){
        Request.toast("Please complete required information.");
        return;
      }
      extra['note1'] = _node2.text;
      extra['autograph_text'] = _autographText.text;
      Uint8List? bytes =  await _signatureController.toPngBytes();
      if(bytes!=null){
        extra['autograph_img'] = base64Encode(bytes);
      }
      EasyLoading.show();
      bool? success = await Api.preventiveSubmit(context,preventive,widget.indexSelect.id!,extra,widget.plant);
      if(success==true){
        CacheUtil.remove(cacheId);
        AutoRouter.of(context).pop();
      }
      EasyLoading.dismiss();
    }
  }

  _pre(){
    if(pageIndex>0){
      _controller.jumpToPage(pageIndex-1);
    }
  }

  String _valueOper9(Content p) {
    Child? a = p.child!.firstWhereOrNull((element) => element.lable == calibratedVolume);
    Child? b = p.child!.firstWhereOrNull((element) => element.lable == calibratedTime);
    if(a!=null  && b!=null&& a.value!.isNotEmpty && b.value!.isNotEmpty){

      return ((((double.parse(a.value!)) / (double.parse(b.value!)) ) *3600) /1000).toStringAsFixed(2);
    }
    return "";
  }
  String _valueOper10(Content p) {
    Child? b = p.child!.firstWhereOrNull((element) => element.lable == calibratedTime10);
    if( b!=null&& b.value!.isNotEmpty){

      return (((20 / (int.parse(b.value!)) ) *3600) /1000).toStringAsFixed(2);
    }
    return "";
  }
}
