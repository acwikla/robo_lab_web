import 'package:flutter/material.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/global.dart';
import 'package:robo_lab_web/patterns/custom_text.dart';

AppBar topNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key) =>
    AppBar(
      leading: Row(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20),
            //precision_manufacturing
            //toys_sharp
            child: Icon(Icons.precision_manufacturing_sharp,
                color: Colors.grey /*papayaWhip*/, size: 35),
          )
        ],
      ),
      elevation: 10,
      title: Row(
        children: [
          Visibility(
              child: CustomText(
                  text: "ROBOLab",
                  color: Colors.grey /*papayaWhip*/,
                  size: 20,
                  weight: FontWeight.bold)),
          Expanded(child: Container()),
          Stack(
            children: [
              IconButton(
                  icon: Icon(Icons.notifications_none_sharp,
                      color: Colors.grey /*papayaWhip*/),
                  onPressed: () {}),
              Positioned(
                  top: 7,
                  right: 7,
                  child: Container(
                    width: 12,
                    height: 12,
                    padding: EdgeInsets.all(4),
                  ))
            ],
          ),
          Container(
            width: 2,
            height: 22,
            color: Colors.grey /*papayaWhip*/,
          ),
          SizedBox(
            width: 24,
          ),
          CustomText(
              text: Global.user.login,
              color: Colors.grey /*papayaWhip*/,
              size: 18),
          SizedBox(
            width: 16,
          ),
          Container(
            decoration: BoxDecoration(
                color: linen.withOpacity(.7),
                borderRadius: BorderRadius.circular(30)),
            child: Container(
              //padding: EdgeInsets.all(2),
              margin: EdgeInsets.all(2),
              child: CircleAvatar(
                backgroundColor: topPanelColor,
                child: Icon(
                  Icons.person_outline,
                  color: Colors.grey /*papayaWhip*/,
                ),
              ),
            ),
          )
        ],
      ),
      iconTheme: IconThemeData(color: Colors.grey /*papayaWhip*/),
      backgroundColor: topPanelColor, //steelBlue,
    );
