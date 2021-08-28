import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/dto/view_device_job_dto.dart';
import 'package:robo_lab_web/dto/view_device_value_dto.dart';
import 'package:robo_lab_web/global.dart';
import 'package:robo_lab_web/gui.dart';
import 'package:robo_lab_web/patterns/custom_action_button.dart';
import 'package:robo_lab_web/requests/device_jobs_requests.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:html' as html;

//import 'package:url_launcher/url_launcher.dart';

class SingleSeriesChartPage extends StatefulWidget {
  const SingleSeriesChartPage({Key? key}) : super(key: key);

  @override
  _SingleSeriesChartPageState createState() => _SingleSeriesChartPageState();
}

class _SingleSeriesChartPageState extends State<SingleSeriesChartPage> {
  late TooltipBehavior _tooltipBehavior;
  //late List<ViewDeviceValueDto> _deviceJobValue;
  late Future<List<ViewDeviceValueDto>> _futureDeviceJobValues;
  late List<ViewDeviceValueDto> _deviceJobValues = [];
  List<String> deviceValueAllPropertyNames = []; //out
  late List<String> jobPropertyName = [];
  String _selectedProperty = 'Data';
  List<ViewDeviceValueDto> _propertyValue = [];

  @override
  void initState() {
    _futureDeviceJobValues =
        DeviceJobsRequests.getDeviceJobValues(Global.deviceJob.id);
    //convert Future<List<T> -> List<T>,
    //_deviceJobValues = await _futureDeviceJobValues;- nope
    _futureDeviceJobValues.then((value) {
      setState(() => value.forEach((item) => _deviceJobValues.add(item)));
    });

    _tooltipBehavior = TooltipBehavior(
      enable: true,
      duration: 5,
      color: lightBlueGrey,
      elevation: 10,
      shadowColor: topPanelColor,
      //tooltipPosition: TooltipPosition.pointer
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: _buildSelectChartDataArea(context)),
        Expanded(flex: 3, child: _buildJobValueChart(context))
      ],
    );
  }

  Future getExelFile() async {
    html.window.open(
        Uri.encodeFull(
            'http://51.158.163.165/api/device-jobs/${Global.deviceJob.id}/export-all-job-values'),
        'open');
  }

  Widget _buildSelectChartDataArea(BuildContext context) {
    String val = '';
    _deviceJobValues.forEach(
        (f) => {val = f.propertyName, print("_deviceJobValues: $val.")});
    _deviceJobValues
        .forEach((f) => deviceValueAllPropertyNames.add(f.propertyName));
    jobPropertyName =
        new Set<String>.from(deviceValueAllPropertyNames).toList();
    if (jobPropertyName.isEmpty) {
      jobPropertyName.add('Job has no value to view.');
    }
    jobPropertyName.forEach((f) => print("result: $f"));
    _deviceJobValues
        .where((element) => element.propertyName == _selectedProperty)
        .forEach((element) {
      _propertyValue.add(element);
    });

    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.fromLTRB(10, 40, 30, 40),
        child: ListView(
          children: [
            Text(
              'Select chart data',
              style: TextStyle(
                color: darkerSteelBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
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
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                itemCount: jobPropertyName.length ?? 0,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${jobPropertyName[index]}',
                        style: Gui.textStyleCasual),
                    selected: false,
                    leading: Radio(
                      value: jobPropertyName[index],
                      groupValue: _selectedProperty,
                      activeColor: peachPuff, //lightBlueGrey,
                      focusColor: Colors.grey,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedProperty = value!;
                          print('new');
                          print(_selectedProperty);
                          _propertyValue.clear();
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            _buildDownloadExcelButton(context)
          ],
        ));
  }

  Widget _buildDownloadExcelButton(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          'Click button to download excel file with all the results.',
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
              // Add your onPressed code here!
              getExelFile();
            },
            child: Icon(
              Icons.download_sharp,
              size: 22,
            ),
            backgroundColor: peachPuff,
            hoverColor: lightBlueGrey,
            elevation: 5,
            tooltip: 'Download file',
          ),
        )
      ],
    );
  }

  Widget _buildJobValueChart(BuildContext context) {
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
        tooltipBehavior: _tooltipBehavior,
        plotAreaBorderColor: Colors.transparent,
        series: <ChartSeries>[
          LineSeries<ViewDeviceValueDto, DateTime>(
              width: 2,
              name: _selectedProperty,
              color: leftMenuColor,
              dataSource: _propertyValue,
              xValueMapper: (ViewDeviceValueDto deviceValueDto, _) =>
                  deviceValueDto.dateTime,
              yValueMapper: (ViewDeviceValueDto deviceValueDto, _) =>
                  double.parse(deviceValueDto.value),
              dataLabelSettings: DataLabelSettings(
                  textStyle: TextStyle(
                      fontFamily:
                          GoogleFonts.ptSansTextTheme.toString(), //'Roboto',
                      fontSize: 14,
                      color: Colors.blueGrey[800]),
                  isVisible: true),
              enableTooltip: true),
        ],
        primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          dateFormat: DateFormat.Hms(),
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

    /*return FutureBuilder<List<ViewDeviceValueDto>>(
        future: _futureDeviceJobValues,
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return Center(child: CircularProgressIndicator(color: skyBlue));
          } else {
            return SfCartesianChart([...]);
          }
        });*/
  }
}
