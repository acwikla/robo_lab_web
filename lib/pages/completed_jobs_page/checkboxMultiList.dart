import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/dto/view_device_value_dto.dart';
import 'package:robo_lab_web/requests/device_jobs_requests.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../global.dart';
import 'dart:async';
import 'dart:html' as html;

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
  static List<List<LinearPropertyValue>> _seriesListData = [];
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _futureDeviceJobValues =
        DeviceJobsRequests.getDeviceJobValues(Global.deviceJob.id);
    _futureDeviceJobValues.then((value) {
      setState(() => value.forEach((item) => _deviceJobValues.add(item)));
      _propNameList = PropName.getPropNames();
    });

    _tooltipBehavior = TooltipBehavior(
      enable: true,
      duration: 5,
      color: lightBlueGrey,
      elevation: 10,
      shadowColor: topPanelColor,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: _buildSelectChartDataArea(context)),
        Expanded(flex: 3, child: _buildMultiSeriesChartData(context)),
      ],
    );
  }

  void itemChange(bool val, int index) {
    setState(() {
      _propNameList[index].isCheck = val;
    });
  }

  void fetchPropertyNameValue() {
    //_seriesList.clear();
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

  void createChartSeries(List<List<ViewDeviceValueDto>> dataList) {
    List<LinearPropertyValue> tempData = [];
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
      /* _seriesList.add(
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
      );*/
      tempData = [];
    });
  }

  Future getExelFile() async {
    html.window.open(
        Uri.encodeFull(
            'http://51.158.163.165/api/device-jobs/${Global.deviceJob.id}/export-all-job-values'),
        'open');
  }

  Widget _buildSelectChartDataArea(BuildContext context) {
    fetchPropertyNameValue();
    createChartSeries(_propNameValueList);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(20, 40, 10, 10),
          child: Text(
            'Select chart data',
            style: TextStyle(
              fontFamily: 'Segoe UI',
              color: darkerSteelBlue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: _buildCheckBoxList(context),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 40, 10, 30),
          child: _buildDownloadExcelButton(context),
        )
      ],
    );
  }

  Widget _buildCheckBoxList(BuildContext context) {
    return ListView.builder(
      itemCount: _propNameList.length,
      itemBuilder: (context, index) {
        return Container(
            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: lightBlueGrey.withOpacity(.6),
                  width: 1.5,
                ),
              ),
            ),
            child: Column(
              children: [
                new CheckboxListTile(
                    activeColor: peachPuff,
                    dense: true,
                    title: new Text(
                      _propNameList[index].name,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Segoe UI',
                        //fontFamily: GoogleFonts.ptSansTextTheme.toString(),
                        fontWeight: FontWeight.normal,
                        //letterSpacing: 0.5
                      ),
                    ),
                    value: _propNameList[index].isCheck,
                    onChanged: (bool? val) {
                      itemChange(val!, index);
                    })
              ],
            ));
      },
    );
  }

  Widget _buildDownloadExcelButton(BuildContext context) {
    return Column(
      children: [
        Text(
          'Click button to download excel file with all the results.',
          //'Download excel file with all the results.',
          style: TextStyle(
            color: darkerSteelBlue,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: FloatingActionButton(
            mini: true, //??
            onPressed: () {
              getExelFile();
            },
            child: Icon(
              Icons.download_sharp,
              size: 22,
            ),
            backgroundColor: peachPuff,
            hoverColor: lightBlueGrey,
            elevation: 5,
            tooltip: 'Download excel file',
          ),
        )
      ],
    );
  }

  Widget _buildMultiSeriesChartData(BuildContext context) {
    return SfCartesianChart(
        backgroundColor: Colors.transparent,
        title: ChartTitle(
          text: 'Results of the completed job: ${Global.deviceJob.id}',
          alignment: ChartAlignment.far,
          textStyle: TextStyle(
            color: darkerSteelBlue,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            decorationColor: lightBlueGrey,
            decorationThickness: 2.85,
            decorationStyle: TextDecorationStyle.solid,
          ),
        ),
        margin: EdgeInsets.fromLTRB(30, 40, 10, 40),
        plotAreaBackgroundColor: superLightBlueGrey,
        borderWidth: 2,
        legend: Legend(
            isVisible: true,
            position: LegendPosition.top,
            alignment: ChartAlignment.center,
            //offset: Offset(40, 40),
            backgroundColor: Colors.white,
            overflowMode: LegendItemOverflowMode.wrap,
            title: LegendTitle(
                text: 'Data',
                textStyle: TextStyle(
                  color: darkerSteelBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ))),
        tooltipBehavior: _tooltipBehavior,
        plotAreaBorderColor: Colors.transparent,
        series: <ChartSeries>[
          for (int i = 0; i < _propNameValueList.length; i++)
            LineSeries<ViewDeviceValueDto, DateTime>(
                width: 2,
                name: _propNameValueList[i][0].propertyName,
                color: Colors.teal[400 + (i * 200)],
                //.blueGrey[400 + (i * 200)], //leftMenuColor,
                dataSource: _propNameValueList[i],
                xValueMapper: (ViewDeviceValueDto deviceValueDto, _) =>
                    deviceValueDto.dateTime,
                yValueMapper: (ViewDeviceValueDto deviceValueDto, _) =>
                    double.parse(deviceValueDto.value),
                dataLabelSettings: DataLabelSettings(
                    textStyle:
                        TextStyle(fontSize: 14, color: Colors.blueGrey[400]),
                    isVisible: true),
                enableTooltip: true),
        ],
        primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          //dateFormat: DateFormat.y(),
          labelStyle: TextStyle(color: Colors.black87, fontSize: 13),
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
