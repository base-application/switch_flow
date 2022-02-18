import 'package:base_app/config/app_config.dart';
import 'package:base_app/config/input_formtter.dart';
import 'package:base_app/model/index_entity.dart';
import 'package:base_app/model/performance_form.dart';
import 'package:base_app/request/api.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    _performanceForm = Api.performanceForm(context, widget.indexSelect.id!);
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
              ),
              ...snapshot.data!.map((e) => Container(
                            margin: const EdgeInsets.only(top: 20,),
                            child: Column(
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
                                            .map<Widget>((c) =>
                                            Container(
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
                          )).toList(),
              const Text("Performance Monitoring Done By :"),
              const Text("Customer Acknowledge:"),
              const Text("签名")
            ],
          ),
        );
      },
    ));
  }

  Widget _switchOperate(Child c){
    if(c.operate == AppConfig.operate0){
      return Text(c.value??"");
    }if(c.operate == AppConfig.operate1){
      return Text(c.value??"");
    }if(c.operate == AppConfig.operate2){
      return SizedBox(
        height: 40,
        child: DropdownSearch<String>(
            mode: Mode.MENU,
            showSelectedItems: true,
            items:const ["Yes","No"],
            onChanged: (v){
              c.value = v;
            }
        ),
      );
    }
    if(c.operate == AppConfig.operate3){
      return  GestureDetector(
        onTap: (){
          showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now()
          ).then((value) {
            if(value!=null){
              c.value = DateFormat().format(value);
              setState(() {});
            }
          });
        },
        child: Text(c.value ?? "Choose Date"),
      );
    }
    if(c.operate == AppConfig.operate4){
      return SizedBox(
        height: 40,
        child: DropdownSearch<String>(
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
        inputFormatters: [
          XNumberTextInputFormatter(maxIntegerLength: null, maxDecimalLength: 1,isAllowDecimal: true),],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      );
    }
    if(c.operate == AppConfig.operate7){
      SizedBox(
        height: 40,
        child: DropdownSearch<String>(
            mode: Mode.MENU,
            showSelectedItems: true,
            items:const ["Clean","Dirty"],
            onChanged: (v){
              c.value = v;
            }
        ),
      );
    }
    if(c.operate == AppConfig.operate8){}
    else{
      return  SizedBox(
        height: 40,
        child: DropdownSearch<String>(
            mode: Mode.MENU,
            showSelectedItems: true,
            items:const ["Acceptable","To be improve"],
            onChanged: (v){
              c.value = v;
            }
        ),
      );
    }
    return Container();
  }
}

class PageHeader extends StatelessWidget {
  final String customerName;
  final String plant;

  const PageHeader({Key? key, required this.customerName, required this.plant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Row(
          children: [
            const Text("Customer"),
            Text(customerName),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text("Plant"),
                Text(plant),
              ],
            ),
            Row(
              children: [
                const Text("Date"),
                Text(DateFormat().format(DateTime.now())),
              ],
            ),
          ],
        )
      ],
    ));
  }
}