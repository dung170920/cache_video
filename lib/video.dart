import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Video extends StatefulWidget {
  final VideoPlayerController? controller;
  const Video({super.key, required this.controller});

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  // VideoPlayerController? _controller;

  // @override
  // void initState() {
  //   initializePlayer(widget.url);
  //   super.initState();
  // }

  // void initializePlayer(String url) async {
  //   var fileInfo = await DefaultCacheManager().getFileFromCache(url);
  //   if (fileInfo == null) {
  //     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
  //       ..initialize().then((value) async {
  //         await DefaultCacheManager().getSingleFile(url).then((value) {
  //           print('downloaded successfully done for $url');
  //         });
  //         setState(() {
  //           _controller?.play();
  //         });
  //       });
  //   } else {
  //     _controller = VideoPlayerController.file(fileInfo.file);
  //     _controller?.initialize().then((value) {
  //       setState(() {
  //         _controller?.play();
  //       });
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return widget.controller == null
        ? const Center(
            child: Text('Loading'),
          )
        : VideoPlayer(widget.controller!);
  }
}
