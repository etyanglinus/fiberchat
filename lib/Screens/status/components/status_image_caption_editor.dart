//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'dart:io';
import 'package:fiberchat/Configs/app_constants.dart';
import 'package:fiberchat/Configs/optional_constants.dart';
import 'package:fiberchat/Screens/status/components/status_video_caption_editor.dart';
import 'package:fiberchat/Services/localization/language_constants.dart';
import 'package:fiberchat/Utils/color_detector.dart';
import 'package:fiberchat/Utils/theme_management.dart';
import 'package:fiberchat/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusImageCaptionEditor extends StatefulWidget {
  StatusImageCaptionEditor({
    Key? key,
    required this.title,
    required this.callback,
    required this.file,
    required this.prefs,
  }) : super(key: key);

  final String title;
  final File file;
  final Function(String str, File file) callback;
  final SharedPreferences prefs;

  @override
  _StatusImageCaptionEditorState createState() =>
      new _StatusImageCaptionEditorState();
}

class _StatusImageCaptionEditorState extends State<StatusImageCaptionEditor> {
  bool isLoading = false;
  String? error;
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController textEditingController =
      new TextEditingController();

  Widget _buildImage() {
    return Image.file(widget.file);
  }

  @override
  Widget build(BuildContext context) {
    return Fiberchat.getNTPWrappedWidget(PopScope(
      onPopInvoked: (v) => Future.value(!isLoading),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: new AppBar(
            elevation: 0.4,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 30,
                color: pickTextColorBasedOnBgColorAdvanced(
                    Thm.isDarktheme(widget.prefs)
                        ? fiberchatAPPBARcolorDarkMode
                        : fiberchatAPPBARcolorLightMode),
              ),
            ),
            title: new Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                color: pickTextColorBasedOnBgColorAdvanced(
                    Thm.isDarktheme(widget.prefs)
                        ? fiberchatAPPBARcolorDarkMode
                        : fiberchatAPPBARcolorLightMode),
              ),
            ),
            backgroundColor: Thm.isDarktheme(widget.prefs)
                ? fiberchatAPPBARcolorDarkMode
                : fiberchatAPPBARcolorLightMode,
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.check,
                    color: pickTextColorBasedOnBgColorAdvanced(
                        Thm.isDarktheme(widget.prefs)
                            ? fiberchatAPPBARcolorDarkMode
                            : fiberchatAPPBARcolorLightMode),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.callback(
                        textEditingController.text.isEmpty
                            ? ''
                            : textEditingController.text,
                        widget.file);
                  }),
              SizedBox(
                width: 8.0,
              )
            ]),
        body: Stack(children: [
          new Column(children: [
            new Expanded(
                child: new Center(
                    child: error != null
                        ? fileSizeErrorWidget(error!)
                        : _buildImage())),
            Container(
              padding: EdgeInsets.all(12),
              height: 80,
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Row(children: [
                Flexible(
                  child: TextField(
                    maxLength:
                        int.tryParse((MaxTextlettersInStatus / 1.7).toString()),
                    maxLines: null,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0, color: fiberchatWhite),
                    controller: textEditingController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        // width: 0.0 produces a thin "hairline" border
                        borderRadius: BorderRadius.circular(1),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 1.5),
                      ),
                      hoverColor: Colors.transparent,
                      focusedBorder: OutlineInputBorder(
                        // width: 0.0 produces a thin "hairline" border
                        borderRadius: BorderRadius.circular(1),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 1.5),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1),
                          borderSide: BorderSide(color: Colors.transparent)),
                      contentPadding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                      hintText: getTranslated(context, 'typeacaption'),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ),
              ]),
            )
          ]),
          Positioned(
            child: isLoading
                ? Container(
                    child: Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                fiberchatSECONDARYolor))),
                    color: pickTextColorBasedOnBgColorAdvanced(
                            !Thm.isDarktheme(widget.prefs)
                                ? fiberchatCONTAINERboxColorDarkMode
                                : fiberchatCONTAINERboxColorLightMode)
                        .withOpacity(0.6),
                  )
                : Container(),
          )
        ]),
      ),
    ));
  }
}
