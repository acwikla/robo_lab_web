import 'package:flutter/material.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/dto/device_type_dto.dart';
import 'package:robo_lab_web/dto/view_device_dto.dart';
import 'package:robo_lab_web/patterns/custom_summary_cadr.dart';
import 'package:robo_lab_web/requests/device_requests.dart';
import 'package:robo_lab_web/requests/device_type_requests.dart';

import '../../gui.dart';
import '../../validator.dart';

class CreateDeviceTypePage extends StatefulWidget {
  const CreateDeviceTypePage({Key? key}) : super(key: key);

  @override
  _CreateDeviceTypePageState createState() => _CreateDeviceTypePageState();
}

class _CreateDeviceTypePageState extends State<CreateDeviceTypePage> {
  late String? _newDevTypeName = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<DeviceTypeDTO>? _futureDeviceType;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 3,
        child: ListView(padding: new EdgeInsets.all(10.0), children: [
          Text('Create device type panel', style: Gui.textStylePageTitle),
          SizedBox(height: 30),
          //Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //Text('Create new device type:', style: Gui.textStyleParagraph),
          //SizedBox(height: 10),
          //Divider(color: Colors.grey, height: 2)
          //]),
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
        SizedBox(height: 10),
        _returnRequestMessage(context, _futureDeviceType, 'device type'),
      ],
    );
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
