//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'dart:io';
import 'package:fiberchat/Configs/app_constants.dart';
import 'package:fiberchat/Services/localization/language_constants.dart';
import 'package:fiberchat/Utils/color_detector.dart';
import 'package:fiberchat/Utils/theme_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class StatusVideoCaptionEditor extends StatefulWidget {
  StatusVideoCaptionEditor({
    Key? key,
    required this.title,
    required this.prefs,
    required this.file,
    required this.callback,
    required this.videoFileExt,
    required this.videoFileName,
  }) : super(key: key);

  final String title;
  final String videoFileName;
  final String videoFileExt;
  final File file;
  final Function(String str, File file, double duration) callback;
  final SharedPreferences prefs;
  @override
  _StatusVideoCaptionEditorState createState() =>
      _StatusVideoCaptionEditorState();
}

class _StatusVideoCaptionEditorState extends State<StatusVideoCaptionEditor> {
  final videoInfo = FlutterVideoInfo();

  final TextEditingController textEditingController =
      new TextEditingController();
  late VideoPlayerController _videoPlayerController;
  var info;
  String? error;

  _buildVideo(BuildContext context) {
    return _videoPlayerController.value.isInitialized
        ? AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController),
          )
        : Container();
  }

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    setVideoParams();
  }

  setVideoParams() async {
    info = await videoInfo.getVideoInfo(widget.file.path);

    setState(() {});
    _videoPlayerController = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
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
        backgroundColor: Thm.isDarktheme(widget.prefs)
            ? fiberchatAPPBARcolorDarkMode
            : fiberchatAPPBARcolorLightMode,
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 18,
            color: pickTextColorBasedOnBgColorAdvanced(
                Thm.isDarktheme(widget.prefs)
                    ? fiberchatAPPBARcolorDarkMode
                    : fiberchatAPPBARcolorLightMode),
          ),
        ),
        actions: info == null
            ? null
            : <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.check,
                      color: pickTextColorBasedOnBgColorAdvanced(
                          Thm.isDarktheme(widget.prefs)
                              ? fiberchatAPPBARcolorDarkMode
                              : fiberchatAPPBARcolorLightMode),
                    ),
                    onPressed: () async {
                      await _videoPlayerController.pause();
                      Navigator.of(context).pop();
                      widget.callback(
                          textEditingController.text.isEmpty
                              ? ''
                              : textEditingController.text,
                          widget.file,
                          info!.duration);
                    }),
                SizedBox(
                  width: 8.0,
                )
              ],
      ),
      body: Stack(children: [
        new Column(children: [
          new Expanded(
              child: new Center(
                  child: error != null
                      ? fileSizeErrorWidget(error!)
                      : info == null
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  fiberchatSECONDARYolor))
                          : _buildVideo(context))),
          Container(
            padding: EdgeInsets.all(12),
            height: 80,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Row(children: [
              Flexible(
                child: TextField(
                  maxLength: 100,
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
                            fiberchatSECONDARYolor)),
                  ),
                  color: pickTextColorBasedOnBgColorAdvanced(
                          !Thm.isDarktheme(widget.prefs)
                              ? fiberchatCONTAINERboxColorDarkMode
                              : fiberchatCONTAINERboxColorLightMode)
                      .withOpacity(0.6),
                )
              : Container(),
        )
      ]),
    );
  }
}

Widget fileSizeErrorWidget(String error) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 60, color: Colors.red[300]),
          SizedBox(
            height: 15,
          ),
          Text(error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.red[300])),
        ],
      ),
    ),
  );
}
