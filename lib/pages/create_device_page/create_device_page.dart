import 'package:flutter/material.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/dto/device_type_dto.dart';
import 'package:robo_lab_web/dto/view_device_dto.dart';
import 'package:robo_lab_web/patterns/custom_summary_cadr.dart';
import 'package:robo_lab_web/requests/device_requests.dart';
import 'package:robo_lab_web/requests/device_type_requests.dart';

import '../../gui.dart';
import '../../validator.dart';

class CreateDevicePage extends StatefulWidget {
  const CreateDevicePage({Key? key}) : super(key: key);

  @override
  _CreateDevicePageState createState() => _CreateDevicePageState();
}

class _CreateDevicePageState extends State<CreateDevicePage> {
  late Future<List<DeviceTypeDTO>> _deviceTypes;
  late String? _newDevTypeName = '';
  late String? _newDeviceName = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  Future<DeviceTypeDTO>? _futureDeviceType;
  Future<ViewDeviceDto>? _futureDevice;
  DeviceTypeDTO? _selectedDeviceType;

  @override
  void initState() {
    _deviceTypes = DeviceTypeRequests.getDeviceTypes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 3,
        child: ListView(padding: new EdgeInsets.all(10.0), children: [
          Text('Create device panel', style: Gui.textStylePageTitle),
          SizedBox(height: 30),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Create new device type:', style: Gui.textStyleParagraph),
            SizedBox(height: 10),
            //Divider(color: Colors.grey, height: 2)
          ]),
          Form(
              key: _formKey,
              child: TextFormField(
                onSaved: (value) => {_newDevTypeName = value},
                textInputAction: TextInputAction.next,
                cursorColor: Colors.grey,
                decoration: Gui.inputDecoration('Device Type Name'),
                validator: Validator.notNullOrEmpty,
              )),
          SizedBox(height: 15),
          _buildCreateDeviceTypeButton(context),
          SizedBox(
            height: 30,
            child: Divider(color: peachPuff, thickness: 1),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Add new device:', style: Gui.textStyleParagraph),
            //SizedBox(height: 10),
            //Divider(color: Colors.grey, height: 2)
          ]),
          _buildSelectDeviceTypeList(context),
          SizedBox(height: 15),
          _addNewDeviceArea(context),
          SizedBox(height: 15),
          _buildAddDeviceButton(context),
          SizedBox(height: 15),
        ]));
  }

  Widget _buildCreateDeviceTypeButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Click button to create a new device type.',
          style: TextStyle(
            color: darkerSteelBlue,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: FloatingActionButton(
            mini: true,
            onPressed: () {
              // Validate will return true if the form is valid
              if (_formKey.currentState!.validate()) {
                // Process data.
                setState(() {
                  _formKey.currentState!.save(); // run TextFormField onSaved
                  print("_newDevTypeName: " + _newDevTypeName.toString());
                  _futureDeviceType =
                      DeviceTypeRequests.createDeviceType(_newDevTypeName!);
                });
              }
            },
            child: Icon(
              Icons.check,
              size: 25,
            ),
            backgroundColor: peachPuff,
            hoverColor: lightBlueGrey,
            elevation: 5,
            tooltip: 'Create device type',
          ),
        ),
        _returnRequestMessage(context, _futureDeviceType, 'device type'),
      ],
    );
  }

  Widget _buildAddDeviceButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Click button to add a new device.',
          style: TextStyle(
            color: darkerSteelBlue,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: FloatingActionButton(
            mini: true,
            onPressed: () {
              // Validate will return true if the form is valid
              if (_formKey2.currentState!.validate()) {
                // Process data.
                setState(() {
                  _formKey2.currentState!.save(); // run TextFormField onSaved
                  print("_newDevTypeName: " + _newDeviceName.toString());
                  _futureDevice = DeviceRequests.addDevice(
                      _newDeviceName, _selectedDeviceType?.name);
                });
              }
            },
            child: Icon(
              Icons.check,
              size: 25,
            ),
            backgroundColor: peachPuff,
            hoverColor: lightBlueGrey,
            elevation: 5,
            tooltip: 'Add device',
          ),
        ),
        _returnRequestMessage(context, _futureDevice, 'device')
      ],
    );
  }

  Widget _buildSelectDeviceTypeList(BuildContext context) {
    return FutureBuilder<List<DeviceTypeDTO>>(
        future: _deviceTypes,
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return Center(child: CircularProgressIndicator(color: skyBlue));
          } else {
            return DropdownButton<DeviceTypeDTO>(
                style: TextStyle(fontSize: 17),
                hint: Text("Select device type"),
                value: _selectedDeviceType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedDeviceType = newValue;
                    //_jobBody.clear();
                  });
                },
                items: snapshot.data!.map((devType) {
                  return DropdownMenuItem(
                      value: devType,
                      child: Row(children: <Widget>[
                        SizedBox(width: 10),
                        Text(devType.name,
                            style: TextStyle(color: Colors.black)),
                      ]));
                }).toList());
          }
        });
  }

  Widget _addNewDeviceArea(BuildContext context) {
    return Form(
        key: _formKey2,
        child: TextFormField(
          onSaved: (value) => {_newDeviceName = value},
          textInputAction: TextInputAction.next,
          cursorColor: Colors.grey,
          decoration: Gui.inputDecoration('Device Name'),
          validator: Validator.notNullOrEmpty,
        ));
  }

  Widget _returnRequestMessage(
      BuildContext context, Future? _futureObj, String typeOfInstanceName) {
    return FutureBuilder<dynamic>(
      future: _futureObj,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomSummaryCard(
              subtitleText: 'Successfully created ' +
                  '$typeOfInstanceName' +
                  ', named: ' +
                  '${snapshot.data!.name}' +
                  ', with ID: ' +
                  '${snapshot.data!.id}.');
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return CustomSummaryCard(subtitleText: '${snapshot.error}');
        }
        return //const CircularProgressIndicator();
            CustomSummaryCard(subtitleText: 'No action was taken.');
      },
    );
  }
}


//_fillDeviceTypeName
//_addDeviceTypeButton
//_selectDeviceTypeList
//_addDeviceArea
//_addDeviceButton
//_summaryCard