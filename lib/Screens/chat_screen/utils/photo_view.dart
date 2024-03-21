import 'package:cached_network_image/cached_network_image.dart';
import 'package:fiberchat/Configs/app_constants.dart';
import 'package:fiberchat/Utils/utils.dart';
import 'package:fiberchat/widgets/DownloadManager/save_image_videos_in_gallery.dart';
import 'package:flutter/material.dart';
import 'package:fiberchat/widgets/PhotoView/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoViewWrapper extends StatelessWidget {
  PhotoViewWrapper(
      {required this.urls,
      this.message,
      this.loadingChild,
      this.backgroundDecoration,
      this.minScale,
      this.maxScale,
      required this.keyloader,
      required this.prefs,
      required this.imageUrl,
      required this.tag});

  final String tag;
  final String? message;
  final SharedPreferences prefs;
  final GlobalKey keyloader;
  final List<String> urls;
  final Widget? loadingChild;
  final Decoration? backgroundDecoration;
  final dynamic minScale;
  final String imageUrl;
  final dynamic maxScale;

  final GlobalKey<ScaffoldState> _scaffoldd = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Fiberchat.getNTPWrappedWidget(Scaffold(
        backgroundColor: Colors.black,
        key: _scaffoldd,
        appBar: AppBar(
          elevation: 0.4,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              size: 24,
              color: fiberchatWhite,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "dfs32231t834",
          backgroundColor: fiberchatSECONDARYolor,
          onPressed: () async {
            GalleryDownloader.saveNetworkImage(
                context, imageUrl, false, "", keyloader, prefs);
          },
          child: Icon(
            Icons.file_download,
          ),
        ),
        body: Container(
            color: Colors.black,
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: PhotoView(
              loadingBuilder: (BuildContext context, var image) {
                return loadingChild ??
                    Center(
                      child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              fiberchatSECONDARYolor),
                        ),
                      ),
                    );
              },
              imageProvider: CachedNetworkImageProvider(urls.first),
              backgroundDecoration: backgroundDecoration as BoxDecoration?,
              minScale: minScale,
              maxScale: maxScale,
            ))));
  }
}
