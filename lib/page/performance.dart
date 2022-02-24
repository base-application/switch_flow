
import 'dart:convert';
import 'dart:typed_data';

import 'package:base_app/config/app_config.dart';
import 'package:base_app/config/input_formtter.dart';
import 'package:base_app/model/index_entity.dart';
import 'package:base_app/model/performance_form.dart';
import 'package:base_app/privider/auth_provider.dart';
import 'package:base_app/request/api.dart';
import 'package:base_app/util/request.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

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
              const SizedBox(height: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Performance Monitoring Comment:"),
                  const Text("if case"),
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
                          child:   Text("note"),
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
                  const Text("if case"),
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
                          child:   Text("note"),
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
                  Text(Provider.of<AuthProvider>(context,listen: false).authUserEntity.name??"")
                ],
              ),
              const SizedBox(height: 10,),
              const Text("Customer Acknowledge:"),
              Row(
                children: [
                  const Text("签名"),
                  Expanded(
                    child: Signature(
                      controller: _controller,
                      height: 150,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
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
                  const Text("Date"),
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
                        Request.toast("sing");
                        return;
                      }
                      for (var per in snapshot.data!) {
                        bool isEmpty = per.content?.child?.any((element) => element.operate !=AppConfig.operate0 &&  (element.value ==null || element.value!.isEmpty))??false;
                        if(isEmpty ){
                          Logger().i( per.content!.title! + "is empty");
                          Request.toast( per.content!.title!  + "is empty");
                          return;
                        }
                      }
                      extra['note1'] = _node1.text;
                      extra['note2'] = _node2.text;
                      extra['autograph_text'] = _autographText.text;
                      Uint8List? bytes =  await _controller.toPngBytes();
                      extra['autograph_img'] = base64Encode(bytes!);
                      Api.performanceSubmit(context, snapshot.data!,widget.indexSelect.id!,extra,widget.plant);
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

  Widget _switchOperate(Child c){
    if(c.operate == AppConfig.operate0){
      return Text(c.value??"");
    }if(c.operate == AppConfig.operate1){
      return TextFormField(
        onChanged: (v){
          c.value = v;
        },
      );
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
        child: Text(c.value ==null || c.value!.isEmpty ?  "Choose Date" :c.value!),
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
        onChanged: (v){
          c.value = v;
        },
      );
    }
    if(c.operate == AppConfig.operate7){
      return SizedBox(
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
    if(c.operate == AppConfig.operate8){
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
            Text("Customer ",style: Theme.of(context).textTheme.headline2!,),
            Text(customerName,style: Theme.of(context).textTheme.headline2!,),
          ],
        ),
        const SizedBox(height: 12,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("Plant",style:  Theme.of(context).textTheme.headline6!,),
                Text(plant,style:  Theme.of(context).textTheme.headline6!),
              ],
            ),
            Row(
              children: [
                Text("Date", style:Theme.of(context).textTheme.headline6!),
                Text(DateFormat().format(DateTime.now()), style:Theme.of(context).textTheme.headline6!),
              ],
            ),
          ],
        )
      ],
    ));
  }
}
