import 'package:flutter/material.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/dto/add_property_dto.dart';
import 'package:robo_lab_web/utils/property.dart';

import '../../gui.dart';
import '../../validator.dart';

class AddPropertyPage extends StatefulWidget {
  const AddPropertyPage({Key? key}) : super(key: key);

  @override
  _AddPropertyPageState createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
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
        width: 3,
        child: ListView(padding: new EdgeInsets.all(10.0), children: [
          Text('Property panel', style: Gui.textStylePageTitle),
          SizedBox(height: 30),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Please fill data:', style: Gui.textStyleParagraph),
            SizedBox(
              height: 10,
            ),
            _buildPropertyFeild(context),
            _showNewPropertyButton(context)
          ])
        ]));
  }

  Widget _buildPropertyFeild(BuildContext context) {
    return Row(
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
    );
  }

  Widget _buildSelectTypeList(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
              color: Colors.black38, width: 1.2, style: BorderStyle.solid),
        ),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                style: TextStyle(fontSize: 15, color: Colors.black26),
                hint: Text("Type"),
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
                        Text(propType,
                            style:
                                TextStyle(fontSize: 15, color: Colors.black38)),
                      ]));
                }).toList())));
  }

  Widget _showNewPropertyButton(BuildContext context) {
    //https://stackoverflow.com/questions/50777895/flutter-add-new-widget-on-click
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Click button to submit a job.',
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
              _buildPropertyFeild(context);
              // Validate will return true if the form is valid
              if (_formKey.currentState!.validate()) {
                // Process data.
                setState(() {
                  _formKey.currentState!.save(); // run TextFormField onSaved
                  print('_newProperty.name: ');
                  print(_newProperty.name);
                  print('_newProperty.body: ');
                  print(_newProperty.body);
                  /*_futureDeviceJob = DeviceJobsRequests.postDeviceJob(
                      Global.device.id,
                      selectedJob!.id,
                      newDeviceJob!);*/
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
            tooltip: 'Add new property',
          ),
        ),
        SizedBox(height: 15),
        //_returnRequestMessage(context),
      ],
    );
  }
}
