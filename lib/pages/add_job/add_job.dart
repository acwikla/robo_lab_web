import 'package:flutter/material.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/dto/add_property_dto.dart';
import 'package:robo_lab_web/dto/job_dto.dart';
import 'package:robo_lab_web/patterns/custom_summary_cadr.dart';
import 'package:robo_lab_web/requests/job_requests.dart';
import 'package:robo_lab_web/utils/property.dart';

import '../../global.dart';
import '../../gui.dart';
import '../../validator.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({Key? key}) : super(key: key);

  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //GlobalKey<FormState> _propertyFormKey = GlobalKey<FormState>();

  late JobDto _newJob = new JobDto(
      id: 0, name: '', description: '', properties: '', deviceTypeName: '');
  int _count = 1;
  String? _selectedDeviceType;
  Future<JobDto>? _futureJob;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _propertyList =
        new List.generate(_count, (int i) => new PropertyFeild());
    print(_propertyList.length);
    return Container(
      //width: 3,
      child: ListView(padding: new EdgeInsets.all(10.0), children: [
        Text('Job creation panel', style: Gui.textStylePageTitle),
        SizedBox(height: 30),
        Form(
            key: _AddJobPageState._formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add new job for device type:',
                    style: Gui.textStyleParagraph),
                _buildNewJobFeild(context),
                Text('Define job properties:', style: Gui.textStyleFootnote),
                Divider(color: Colors.grey),
                new ConstrainedBox(
                    constraints: new BoxConstraints(
                      minHeight: 50.0,
                      maxHeight: 240,
                    ),
                    child: Container(
                        //constraints: BoxConstraints(
                        //maxHeight: 500, //double.infinity
                        //minHeight: 50),
                        //height: 60,
                        child: new ListView(
                      children: _propertyList,
                      scrollDirection: Axis.vertical,
                    ))),
                _showNewPropertyButton(context),
              ],
            )),
        Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          _createNewJobButton(context),
          _returnRequestMessage(context)
        ])
      ]),
    );
  }

  Widget _buildNewJobFeild(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 7),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: new TextFormField(
              onChanged: (value) => {
                _newJob.name = value!,
                print('_newJob.name:'),
                print(_newJob.name)
              },
              textInputAction: TextInputAction.next,
              cursorColor: Colors.grey,
              decoration: Gui.inputDecoration('Job Name'),
              validator: Validator.notNullOrEmpty,
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            flex: 2,
            child: new TextFormField(
              onChanged: (value) => {
                _newJob.description = value!,
                print('_newJob.description:'),
                print(_newJob.description)
              },
              textInputAction: TextInputAction.next,
              cursorColor: Colors.grey,
              decoration: Gui.inputDecoration('Description'),
              validator: Validator.notNullOrEmpty,
            ),
          ),
          SizedBox(width: 10),
          _buildSelectDeviceTypeList(context),
        ],
      ),
    );
  }

  Widget _buildSelectDeviceTypeList(BuildContext context) {
    return Container(
        height: 53,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
              color: Colors.black38, width: 1, style: BorderStyle.solid),
        ),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                //style: TextStyle(fontSize: 15, color: Colors.black),
                hint: Text("Type", style: TextStyle(color: Colors.black38)),
                value: _selectedDeviceType,
                //validator: (value) => value == null ? 'field required' : null,
                //validator: Validator.notNullOrEmpty,
                onChanged: (newValue) {
                  setState(() {
                    _selectedDeviceType = newValue!;
                    _newJob.deviceTypeName = newValue!;
                    print('_selectedDeviceType:');
                    print(_selectedDeviceType);
                  });
                },
                items: [
                  'SmartTerra',
                  'RoboArm(Arexx RA-1-PRO)',
                  'Dobot Magician V2',
                  'ROBOLab Press'
                ].map((String propType) {
                  return DropdownMenuItem<String>(
                      value: propType,
                      child: Row(children: <Widget>[
                        SizedBox(width: 5),
                        Text(propType, style: TextStyle(fontSize: 15)),
                      ]));
                }).toList())));
  }

  Widget _showNewPropertyButton(BuildContext context) {
    //https://stackoverflow.com/questions/50777895/flutter-add-new-widget-on-click
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: FloatingActionButton(
            mini: true,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Process data.
                setState(() {
                  _addNewContactRow();
                });
              }
            },
            child: Icon(
              Icons.add,
              size: 25,
            ),
            backgroundColor: peachPuff,
            hoverColor: lightBlueGrey,
            elevation: 5,
            tooltip: 'Add new property',
          ),
        ),
        SizedBox(height: 15),
        //_returnRequestMessage(context),
      ],
    );
  }

  Widget _createNewJobButton(BuildContext context) {
    //https://stackoverflow.com/questions/50777895/flutter-add-new-widget-on-click
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Click button to create a job.',
          style: TextStyle(
            color: darkerSteelBlue,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: FloatingActionButton(
            //mini: true,
            onPressed: () {
              if (_formKey.currentState!.validate()
                  //&&_propertyFormKey.currentState!.validate()
                  ) {
                // Process data.
                setState(() {
                  _formKey.currentState!.save(); // run TextFormField onSaved
                  //_propertyFormKey.currentState!
                  //.save(); // run TextFormField onSaved
                  print('_newJob.deviceTypeName: ' + _newJob.deviceTypeName);
                  Set<AddPropertyDto> set =
                      Set.from(_PropertyFeildState._jobPropertyList);
                  set.forEach((element) => {
                        _newJob.properties =
                            _newJob.properties + element.toMap().toString()
                      });

                  if (_newJob.deviceTypeName.isEmpty) {
                    _newJob.deviceTypeName = 'nan';
                  }

                  _futureJob = JobRequests.createJobForDeviceType(_newJob);
                });
              }
            },
            child: Icon(
              Icons.check,
              size: 30,
            ),
            backgroundColor: peachPuff,
            hoverColor: lightBlueGrey,
            elevation: 5,
            tooltip: 'Create job',
          ),
        ),
        SizedBox(height: 15),
        //_returnRequestMessage(context),
      ],
    );
  }

  Widget _returnRequestMessage(BuildContext context) {
    return FutureBuilder<JobDto>(
      future: _futureJob,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomSummaryCard(
              subtitleText:
                  'Job has been successfully submitted for a device type:' +
                      _selectedDeviceType!);
        } else if (snapshot.hasError) {
          return CustomSummaryCard(subtitleText: '${snapshot.error}');
        }
        return //const CircularProgressIndicator();
            CustomSummaryCard(subtitleText: 'No action was taken.');
      },
    );
  }

  void _addNewContactRow() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _count = _count + 1;
      });
    }
  }
}

class PropertyFeild extends StatefulWidget {
  const PropertyFeild({Key? key}) : super(key: key);

  @override
  _PropertyFeildState createState() => _PropertyFeildState();
}

class _PropertyFeildState extends State<PropertyFeild> {
  late AddPropertyDto _newProperty = new AddPropertyDto(body: {});
  static List<AddPropertyDto> _jobPropertyList = [];
  //List<String> _propertyTypesList = ['int', 'double', 'string', 'color'];
  String? _selectedPropertyType;

  @override
  void initState() {
    _jobPropertyList.add(_newProperty);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return //Form(
        //key: _AddJobPageState._propertyFormKey,
        //child:
        Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
            child: Row(
              children: [
                Flexible(
                  child: new TextFormField(
                    onChanged: (value) => {
                      _newProperty.name = value!,
                      print('_newProperty.name:'),
                      print(_newProperty.name)
                    },
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.grey,
                    decoration: Gui.inputDecoration('Name'),
                    validator: Validator.notNullOrEmpty,
                  ),
                ),
                SizedBox(width: 10),
                Flexible(child: _buildSelectTypeList(context)),
                SizedBox(width: 10),
                Flexible(
                    child: new TextFormField(
                  onChanged: (value) => {
                    _newProperty.set('min', value!),
                    print('_newProperty.body:'),
                    print(_newProperty.body),
                  },
                  textInputAction: TextInputAction.next,
                  cursorColor: Colors.grey,
                  decoration: Gui.inputDecoration('Min Value'),
                  //validator: Validator.notNullOrEmpty,
                )),
                SizedBox(width: 10),
                Flexible(
                    child: new TextFormField(
                  onChanged: (value) => {
                    _newProperty.set('max', value),
                    print('_newProperty.body:'),
                    print(_newProperty.body)
                  },
                  textInputAction: TextInputAction.next,
                  cursorColor: Colors.grey,
                  decoration: Gui.inputDecoration('Max Value'),
                  //validator: Validator.notNullOrEmpty,
                )),
              ],
            ));
    //);
  }

  Widget _buildSelectTypeList(BuildContext context) {
    return Container(
        height: 53,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
              color: Colors.black38, width: 1, style: BorderStyle.solid),
        ),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                //style: TextStyle(fontSize: 15, color: Colors.black),
                hint: Text("Type", style: TextStyle(color: Colors.black38)),
                value: _selectedPropertyType,
                //validator: (value) => value == null ? 'Field required' : null,
                //validator: Validator.notNullOrEmpty,
                onChanged: (newValue) {
                  setState(() {
                    _selectedPropertyType = newValue!;
                    _newProperty.set('type', newValue!);
                    print('_selectedPropertyType:');
                    print(_selectedPropertyType);
                    print('_newProperty.body:');
                    print(_newProperty.body);
                    //_jobBody.clear();
                  });
                },
                items:
                    ['Int', 'Double', 'String', 'Color'].map((String propType) {
                  return DropdownMenuItem<String>(
                      value: propType,
                      child: Row(children: <Widget>[
                        SizedBox(width: 5),
                        Text(propType, style: TextStyle(fontSize: 15)),
                      ]));
                }).toList())));
  }
}
