import 'package:flutter/material.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/dto/view_device_job_dto.dart';
import 'package:robo_lab_web/dto/view_device_value_dto.dart';
import 'package:robo_lab_web/requests/device_jobs_requests.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../global.dart';
import 'dart:async';
import 'dart:html' as html;
import "package:collection/collection.dart";

class CompletedJobDetailsPage extends StatefulWidget {
  final ViewDeviceJobDto deviceJob;

  const CompletedJobDetailsPage({Key? key, required this.deviceJob})
      : super(key: key);

  @override
  createState() => _CompletedJobDetailsPageState();
}

class _CompletedJobDetailsPageState extends State<CompletedJobDetailsPage> {
  // raw data
  late List<PropName> _propNameList;
  late Map<String, List<ViewDeviceValueDto>> _devJobValuesGrouped;

  late Future<bool> _dataLoaded;

  // chart data
  //late Map<String, List<LinearPropertyValue>> _seriesListData;

  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _dataLoaded = DeviceJobsRequests.getDeviceJobValues(Global.deviceJob.id)
        .then((values) {
      //setState(() {
      // all device values grouped by property name
      _devJobValuesGrouped = groupBy(values, (ViewDeviceValueDto value) {
        return value.propertyName;
      });

      // properties settings (name, isCheck)
      _propNameList =
          _devJobValuesGrouped.keys.map((e) => PropName(name: e)).toList();

      return true;

      // create chart series
      //_createChartSeries(_devJobValuesGrouped);
      //});
    });

    _tooltipBehavior = TooltipBehavior(
        enable: true,
        duration: 5,
        color: lightBlueGrey,
        elevation: 10,
        shadowColor: topPanelColor);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _dataLoaded,
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Row(
            children: [
              Expanded(flex: 1, child: _buildSelectChartDataArea(context)),
              Expanded(flex: 3, child: _buildMultiSeriesChartData(context)),
            ],
          );
        }
      },
    );
  }

  void itemChange(bool val, int index) {
    setState(() {
      _propNameList[index].isCheck = val;
    });
  }

  // void _createChartSeries(Map<String, List<ViewDeviceValueDto>> valuesMap) {
  //   // clear series data
  //   _seriesListData = {};

  //   // create new series data
  //   valuesMap.forEach((propertyName, deviceValues) {
  //     var tempData = deviceValues
  //         .map((item) => LinearPropertyValue(
  //             value: double.parse(item.value), dateTime: item.dateTime))
  //         .toList();

  //     _seriesListData[propertyName] = tempData;
  //   });
  // }

  Future _getExelFile() async {
    html.window.open(
        Uri.encodeFull(
            'http://51.158.163.165/api/device-jobs/${Global.deviceJob.id}/export-all-job-values'),
        'open');
  }

  Widget _buildSelectChartDataArea(BuildContext context) {
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
              _getExelFile();
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
          //for (int i = 0; i < _propNameList.length; i++)
          for (var checkedProp in _propNameList.where((prop) => prop.isCheck))
            LineSeries<ViewDeviceValueDto, DateTime>(
                width: 2,
                name: checkedProp.name,
                color: Colors.teal[400 + (1 * 200)],
                //.blueGrey[400 + (i * 200)], //leftMenuColor,
                dataSource: _devJobValuesGrouped[checkedProp.name]!,
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
}

// class LinearPropertyValue {
//   LinearPropertyValue({required this.value, required this.dateTime});

//   double value;
//   DateTime dateTime;
// }
