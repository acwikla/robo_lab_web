import 'package:flutter/material.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/dto/view_device_value_dto.dart';
import 'package:robo_lab_web/requests/device_jobs_requests.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../global.dart';

class MultiSeriesChartJobDetailsPage extends StatefulWidget {
  const MultiSeriesChartJobDetailsPage({Key? key}) : super(key: key);

  @override
  _MultiSeriesChartJobDetailsPageState createState() =>
      _MultiSeriesChartJobDetailsPageState();
}

class _MultiSeriesChartJobDetailsPageState
    extends State<MultiSeriesChartJobDetailsPage> {
  late Future<List<ViewDeviceValueDto>> _futureDeviceJobValues;
  static late List<ViewDeviceValueDto> _deviceJobValues = [];
  static List<PropName> _propNameList = [];
  static List<List<ViewDeviceValueDto>> _propNameValueList = [];
  late List<charts.Series<LinearPropertyValue, int>> _seriesList = [];
  static List<List<LinearPropertyValue>> _seriesListData = [];

  @override
  void initState() {
    _futureDeviceJobValues =
        //DeviceJobsRequests.getDeviceJobValues(Global.deviceJob.id);
        DeviceJobsRequests.getDeviceJobValues(67);
    _futureDeviceJobValues.then((value) {
      setState(() => value.forEach((item) => _deviceJobValues.add(item)));
      _propNameList = PropName.getPropNames();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 1, child: _buildTitle(context)),
        Expanded(flex: 1, child: _buildCheckBoxList(context)),
        Expanded(flex: 5, child: _buildMultiSeriesChartData(context)),
        //Expanded(flex: 5, child: _buildChartData(context)),
      ],
    );
  }

  void itemChange(bool val, int index) {
    setState(() {
      _propNameList[index].isCheck = val;
    });
  }

  void fetchPropertyNameValue() {
    _seriesList.clear();
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

  //charts.Series<LinearPropertyValue, DateTime>
  void createChartSeries(List<List<ViewDeviceValueDto>> dataList) {
    List<LinearPropertyValue> linearData = [];
    List<LinearPropertyValue> tempData = [];
    int i = 0;
    print('dataList:');
    dataList.forEach((element) {
      print(' list:');
      element.forEach((e) {
        print(e.value);
      });
    });
    print('-------------');

    dataList.forEach((list) {
      list.forEach((element) {
        tempData.add(new LinearPropertyValue(
            value: double.parse(element.value), dateTime: element.dateTime));
      });
      print('tempData:');
      tempData.forEach((element) {
        print(element.value);
      });

      _seriesListData.add(tempData);
      _seriesList.add(
        new charts.Series<LinearPropertyValue, int>(
            id: list[0].propertyName,
            domainFn: (LinearPropertyValue propertyValue, _) =>
                propertyValue.dateTime.second,
            measureFn: (LinearPropertyValue propertyValue, _) =>
                propertyValue.value.toInt(),
            data: _seriesListData[i],
            seriesCategory: 'buuu',
            overlaySeries: true,
            displayName: list[0].propertyName),
      );
      tempData = [];
      i++;
    });
  }

  Widget _buildCheckBoxList(BuildContext context) {
    fetchPropertyNameValue();
    createChartSeries(_propNameValueList);

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

  Widget _buildMultiSeriesChartData(BuildContext context) {
    return SfCartesianChart(
        backgroundColor: Colors.transparent,
        title: ChartTitle(
          text: 'Results of the completed job: ${Global.deviceJob.id}',
          alignment: ChartAlignment.far,
          borderColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          textStyle: TextStyle(
            color: darkerSteelBlue,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            decorationColor: lightBlueGrey,
            decorationThickness: 2,
            decorationStyle: TextDecorationStyle.solid,
          ),
        ),
        margin: EdgeInsets.fromLTRB(10, 40, 10, 40),
        //palette
        plotAreaBackgroundColor: superLightBlueGrey,
        legend: Legend(
            isVisible: true,
            position: LegendPosition.top,
            alignment: ChartAlignment.center,
            //borderColor: lighterPeachPuff,
            //borderWidth: 2,
            //offset: Offset(40, 40),
            //overflowMode: LegendItemOverflowMode.wrap,
            title: LegendTitle(
                text: 'Data',
                textStyle: TextStyle(
                  color: darkerSteelBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ))),
        //tooltipBehavior: _tooltipBehavior,
        plotAreaBorderColor: Colors.transparent,
        series: <ChartSeries>[
          for (int i = 0; i < _propNameValueList.length; i++)
            LineSeries<ViewDeviceValueDto, DateTime>(
                width: 2,
                name: _propNameList[i].name,
                color: leftMenuColor,
                dataSource: _propNameValueList[i],
                xValueMapper: (ViewDeviceValueDto deviceValueDto, _) =>
                    deviceValueDto.dateTime,
                yValueMapper: (ViewDeviceValueDto deviceValueDto, _) =>
                    double.parse(deviceValueDto.value),
                dataLabelSettings: DataLabelSettings(
                    textStyle:
                        TextStyle(fontSize: 14, color: Colors.blueGrey[800]),
                    isVisible: true),
                enableTooltip: true),
        ],
        primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          //dateFormat: DateFormat.Hms(),
          labelStyle: TextStyle(color: Colors.black87, fontSize: 13),
          //rangePadding: ,
          axisLine: AxisLine(color: lightBlueGrey),
          title: AxisTitle(
              text: 'Time',
              textStyle: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
        ),
        primaryYAxis: NumericAxis(
            axisLine: AxisLine(color: lightBlueGrey),
            //decimalPlaces: 4,
            labelFormat: '{value}',
            labelStyle: TextStyle(color: Colors.black87, fontSize: 13)));
  }

  Widget _buildChartData(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 50, 30, 50),
      child: new charts.LineChart(_seriesList,
          //layoutConfig: charts.LayoutConfig(),
          animate: true,
          defaultRenderer:
              new charts.LineRendererConfig(includeArea: true, stacked: true)),
    );
  }
}

class PropName {
  PropName({this.isCheck = false, required this.name});
  bool isCheck;
  String name;

  static List<PropName> getPropNames() {
    List<String> tempList = [];
    List<String> tempUniqueList = [];
    List<PropName> finalList = [];
    _MultiSeriesChartJobDetailsPageState._deviceJobValues
        .forEach((f) => tempList.add(f.propertyName));
    tempUniqueList = new Set<String>.from(tempList).toList();
    tempUniqueList.forEach((element) {
      finalList.add(new PropName(name: element));
    });
    return finalList;
  }
}

class LinearPropertyValue {
  LinearPropertyValue({required this.value, required this.dateTime});

  double value;
  DateTime dateTime;
}
