import 'package:base_app/config/app_config.dart';
import 'package:base_app/config/input_formtter.dart';
import 'package:base_app/model/index_entity.dart';
import 'package:base_app/model/performance_form.dart';
import 'package:base_app/model/preventive_form.dart';
import 'package:base_app/page/commen.dart';
import 'package:base_app/page/performance.dart';
import 'package:base_app/request/api.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart' hide Step;

class Preventive extends StatefulWidget {
  final IndexSelect indexSelect;
  final String plant;
  const Preventive({Key? key, required this.indexSelect, required this.plant}) : super(key: key);

  @override
  _PreventiveState createState() => _PreventiveState();
}

class _PreventiveState extends State<Preventive> {
  late Future<PreventiveForm?> _future;
  final List<String> _title = ['Pump','Dosing Pump','DAF System','pH Calibration','Front end check list'];

  @override
  void initState() {
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
              PageHeader(
                plant: widget.plant,
                customerName: widget.indexSelect.name ?? "",
              ),
              Text(snapshot.data!.toJson().keys.length.toString()),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.toJson().keys.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(_title[index]);
                  },
                ),
              ),
              Expanded(
                  child: PageView.builder(
                    itemCount: snapshot.data!.toJson().keys.length,
                    itemBuilder: (BuildContext context, int index) {
                      List<List<PerformanceForm>?> perfrom = [snapshot.data!.step1,snapshot.data!.step2,snapshot.data!.step3,snapshot.data!.step4];
                      List<Step>? step = snapshot.data!.step5;
                      if(index == 4){
                         return SingleChildScrollView(
                           padding: const EdgeInsets.all(16),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: step?.map((e) =>
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
                             ).toList() ??[const ErrorPage(error: "no Data",)],
                           ),
                         );
                      }else{
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: perfrom[index]?.map<Widget>((e) =>
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
                            ).toList()??[const ErrorPage(error: "no Data",)],
                          ),
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
}
