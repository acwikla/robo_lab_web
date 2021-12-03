import 'package:flutter/material.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/dto/add_property_dto.dart';
import 'package:robo_lab_web/dto/job_dto.dart';
import 'package:robo_lab_web/utils/property.dart';

import '../../gui.dart';
import '../../validator.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({Key? key}) : super(key: key);

  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  late JobDto _newJob = new JobDto(
      id: 0, name: '', description: '', properties: '', deviceTypeName: '');
  int _count = 1;
  String? _selectedDeviceType;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _propertyList =
        new List.generate(_count, (int i) => new PropertyFeild());
    return Container(
        //width: 3,
        child: ListView(padding: new EdgeInsets.all(10.0), children: [
      Text('Job creation panel', style: Gui.textStylePageTitle),
      SizedBox(height: 30),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Add new job for device type:', style: Gui.textStyleParagraph),
        _buildNewJobFeild(context),
        Text('Define job properties:', style: Gui.textStyleFootnote),
        Divider(color: Colors.grey),
        Container(
            height: 300.0,
            child: new ListView(
              children: _propertyList,
              scrollDirection: Axis.vertical,
            )),
        _showNewPropertyButton(context),
      ])
    ]));
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
                onChanged: (newValue) {
                  setState(() {
                    _selectedDeviceType = newValue!;
                    _newJob.description = newValue!;
                    print('_selectedDeviceType:');
                    print(_selectedDeviceType);
                  });
                },
                items: ['DevType1', 'DevType2', 'DevType3', 'DevType4']
                    .map((String propType) {
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
              _addNewContactRow();
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

  void _addNewContactRow() {
    setState(() {
      _count = _count + 1;
    });
  }
}

class PropertyFeild extends StatefulWidget {
  const PropertyFeild({Key? key}) : super(key: key);

  @override
  _PropertyFeildState createState() => _PropertyFeildState();
}

class _PropertyFeildState extends State<PropertyFeild> {
  late AddPropertyDto _newProperty = new AddPropertyDto(body: {});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //List<String> _propertyTypesList = ['int', 'double', 'string', 'color'];
  String? _selectedPropertyType;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      ),
    );
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
