import 'package:flutter/material.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/dto/view_device_job_dto.dart';
import 'package:robo_lab_web/dto/view_device_value_dto.dart';
import 'package:robo_lab_web/requests/device_jobs_requests.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../global.dart';
import "package:collection/collection.dart";

import 'dart:convert';
import 'dart:html';
import 'dart:async';
import 'dart:ui' as dart_ui;
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:html' as html;

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
  final GlobalKey<SfCartesianChartState> _chartKey = GlobalKey();
  late Future<bool> _dataLoaded;

  // chart data
  //late Map<String, List<LinearPropertyValue>> _seriesListData;

  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _dataLoaded = DeviceJobsRequests.getDeviceJobValues(widget.deviceJob.id)
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
              Expanded(flex: 3, child: _buildChartDataSide(context)),
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
            'http://51.158.163.165/api/device-jobs/${widget.deviceJob.id}/export-all-job-values'),
        'open');
  }

  Future<void> _renderPdf() async {
    final PdfDocument document = PdfDocument();
    final PdfBitmap bitmap = PdfBitmap(await _readImageData());
    document.pageSettings.orientation =
        MediaQuery.of(context).orientation == Orientation.landscape
            ? PdfPageOrientation.landscape
            : PdfPageOrientation.portrait;
    document.pageSettings.margins.all = 0;
    document.pageSettings.size =
        Size(bitmap.width.toDouble(), bitmap.height.toDouble());
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    page.graphics.drawImage(
        bitmap, Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      duration: Duration(milliseconds: 200),
      content: Text('Chart has been exported as PDF document'),
    ));
    final List<int> bytes = document.save();
    document.dispose();
    await FileSaveHelper.saveAndLaunchFile(bytes, 'cartesian_chart.pdf');
  }

  Future<List<int>> _readImageData() async {
    final dart_ui.Image data =
        await _chartKey.currentState!.toImage(pixelRatio: 3.0);
    final ByteData? bytes =
        await data.toByteData(format: dart_ui.ImageByteFormat.png);
    return bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }

  Widget _buildSelectChartDataArea(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(20, 20, 10, 10),
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
        //Container(
        //margin: EdgeInsets.fromLTRB(20, 40, 10, 30),
        //child: _buildDownloadExcelButton(context),
        //)
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
          'Download excel file with all the results.',
          //'Download excel file with all the results.',
          style: TextStyle(
            color: darkerSteelBlue,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          //padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: FloatingActionButton(
            mini: true, //??
            onPressed: () {
              _getExelFile();
            },
            child: Icon(
              Icons.download_sharp,
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

  Widget _buildDownloadPDFButton(BuildContext context) {
    return Column(
      children: [
        Text(
          'Download PDF file with chart view.',
          //'Download excel file with all the results.',
          style: TextStyle(
            color: darkerSteelBlue,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
            //padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: FloatingActionButton(
          mini: true,
          child: Icon(
            Icons.picture_as_pdf,
          ),
          backgroundColor: peachPuff,
          hoverColor: lightBlueGrey,
          elevation: 5,
          tooltip: 'Download PDF file',
          onPressed: () {
            _renderPdf();
          },
        ))
      ],
    );
  }

  Widget _buildMultiSeriesChartData(BuildContext context) {
    return SfCartesianChart(
        key: _chartKey,
        backgroundColor: Colors.transparent,
        title: ChartTitle(
          text: 'Results of the completed job: ${widget.deviceJob.id}',
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
        margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
        plotAreaBackgroundColor: superLightBlueGrey,
        borderWidth: 2,
        legend: Legend(
            isVisible: true,
            position: LegendPosition.top,
            alignment: ChartAlignment.center,
            //offset: Offset(40, 40),
            backgroundColor: Colors.transparent,
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

  Widget _buildChartDataSide(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 20, 10, 15),
      child: Column(
        children: [
          Expanded(
            flex: 7,
            child: _buildMultiSeriesChartData(context),
          ),
          Divider(
            color: lightBlueGrey.withOpacity(.6),
            thickness: 1.5,
          ),
          Expanded(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _buildDownloadExcelButton(context),
          ])),
          SizedBox(
            height: 4,
          ),
          Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_buildDownloadPDFButton(context)])),
        ],
      ),
    );
  }
}

class PropName {
  PropName({this.isCheck = false, required this.name});
  bool isCheck;
  String name;
}

class FileSaveHelper {
  ///To save the pdf file in the device
  static Future<void> saveAndLaunchFile(
      List<int> bytes, String fileName) async {
    AnchorElement(
        href:
            'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
      ..setAttribute('download', fileName)
      ..click();
  }
}
// class LinearPropertyValue {
//   LinearPropertyValue({required this.value, required this.dateTime});

//   double value;
//   DateTime dateTime;
// }
