import 'package:flutter/material.dart';
import 'package:http/retry.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/dto/view_device_value_dto.dart';
import 'package:robo_lab_web/requests/device_jobs_requests.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../global.dart';

class TempCompletedJobDetailsPage extends StatefulWidget {
  const TempCompletedJobDetailsPage({Key? key}) : super(key: key);

  @override
  _TempCompletedJobDetailsPageState createState() =>
      _TempCompletedJobDetailsPageState();
}

class _TempCompletedJobDetailsPageState
    extends State<TempCompletedJobDetailsPage> {
  late Future<List<ViewDeviceValueDto>> _futureDeviceJobValues;
  static late List<ViewDeviceValueDto> _deviceJobValues = [];
  static List<PropName> _propNameList = [];
  static List<List<ViewDeviceValueDto>> _propNameValueList = [];

  @override
  void initState() {
    _futureDeviceJobValues =
        DeviceJobsRequests.getDeviceJobValues(Global.deviceJob.id);
    _futureDeviceJobValues.then((value) {
      setState(() => value.forEach((item) => _deviceJobValues.add(item)));
      _propNameList = PropName.GetPropNames();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(flex: 1, child: _buildTitle(context)),
        Flexible(flex: 5, child: _buildCheckBoxList(context))
      ],
    );
  }

  void itemChange(bool val, int index) {
    setState(() {
      _propNameList[index].isCheck = val;
    });
  }

  void fetchPropertyNameValue() {
    List<ViewDeviceValueDto> tempList = [];

    _propNameList.forEach((property) {
      tempList = _deviceJobValues
          .where((element) => element.propertyName == property.name)
          .toList();
      if (property.isCheck) {
        //sprawdz czy dane zostały juz dodane
        //jak nie to dodaj
        //nie wyobrazam sobie innego przypadku w ktorym wartosc z danym id mialaby sie powtorzyc
        if (tempList.isNotEmpty &&
            !_propNameValueList
                .any((element) => element.contains(tempList[0]))) {
          _propNameValueList.add(tempList);
        }
      } else {
        //jak dane istnieja to usun
        //jak nie istnieja to nic nie rob
        if (tempList.isNotEmpty &&
            _propNameValueList
                .any((element) => element.contains(tempList[0]))) {
          _propNameValueList.removeWhere((list) =>
              list.any((element) => element.propertyName == property.name));
        }
      }
    });
  }

  Widget _buildCheckBoxList(BuildContext context) {
    fetchPropertyNameValue();
    print('fetchPropertyNameValue():');
    _propNameValueList.forEach((element) {
      print(' list:');
      element.forEach((e) {
        print(e.value);
      });
    });
    print('-------------');

    return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: lightBlueGrey.withOpacity(.6),
              width: 1.5,
            ),
            bottom: BorderSide(
              color: lightBlueGrey.withOpacity(.6),
              width: 1.5,
            ),
          ),
        ),
        child: ListView.builder(
          itemCount: _propNameList.length,
          itemBuilder: (context, index) {
            return Container(
                child: Column(
              children: [
                new CheckboxListTile(
                    activeColor: Colors.pink[300],
                    dense: true,
                    //font change
                    title: new Text(
                      _propNameList[index].name,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5),
                    ),
                    value: _propNameList[index].isCheck,
                    onChanged: (bool? val) {
                      itemChange(val!, index);
                    })
              ],
            ));
          },
        ));
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.fromLTRB(10, 40, 30, 40),
        child: ListView(children: [
          Text(
            'Select chart data',
            style: TextStyle(
              fontFamily: 'Segoe UI',
              color: darkerSteelBlue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
        ]));
  }
}

class PropName {
  PropName({this.isCheck = false, required this.name});
  bool isCheck;
  String name;

  static List<PropName> GetPropNames() {
    List<String> tempList = [];
    List<String> tempUniqueList = [];
    List<PropName> finalList = [];
    _TempCompletedJobDetailsPageState._deviceJobValues
        .forEach((f) => tempList.add(f.propertyName));
    tempUniqueList = new Set<String>.from(tempList).toList();
    tempUniqueList.forEach((element) {
      finalList.add(new PropName(name: element));
    });
    return finalList;
  }
}
