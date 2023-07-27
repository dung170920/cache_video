import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video/video.dart';
import 'package:video_player/video_player.dart';

List<String> videoNetworks = [
  'https://cn-video-public.s3.ap-southeast-1.amazonaws.com/2023+BMW+XM.mp4',
  'https://cn-video-public.s3.ap-southeast-1.amazonaws.com/%C3%81o+b%C3%A9+g%C3%A1i.mp4',
  'https://cn-video-public.s3.ap-southeast-1.amazonaws.com/%C3%81o+Blazer+nam+chu%E1%BA%A9n.mp4',
  'https://cn-video-public.s3.ap-southeast-1.amazonaws.com/%C3%81o+s%C6%A1+mi+c%C3%B4ng+s%E1%BB%9F.mp4',
  'https://cn-video-public.s3.ap-southeast-1.amazonaws.com/Ao+thun+nam+co+dan.mp4',
  'https://cn-video-public.s3.ap-southeast-1.amazonaws.com/B%C3%A1n+iphone+12pro+xanh+d%C6%B0%C6%A1ng.mp4',
  'https://cn-video-public.s3.ap-southeast-1.amazonaws.com/B%C3%A1n+qu%E1%BA%A7n+jean+gi%C3%A1+t%E1%BB%91t.mp4',
  'https://cn-video-public.s3.ap-southeast-1.amazonaws.com/B%C3%A1n+s%E1%BB%89+s%E1%BB%91+l%C6%B0%E1%BB%A3ng+l%E1%BB%9Bn+qu%E1%BA%A7n+t%C3%A2y+nam.mp4',
  'https://cn-video-public.s3.ap-southeast-1.amazonaws.com/B%C3%A1n+tivi+samsung+40inch.mp4',
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Video',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  bool _stop = true;
  final Map<String, VideoPlayerController> _controllers = {};

  @override
  void initState() {
    _clearCache();
    if (videoNetworks.isNotEmpty) {
      _initController(0).then((_) {
        print('load first');
        _playController(0);
      });
    }

    if (videoNetworks.length > 1) {
      _initController(1).whenComplete(() => _stop = false);
    }
    super.initState();
  }

  Future<void> _initController(int i) async {
    String url = videoNetworks[i];
    VideoPlayerController controller;
    var fileInfo = await DefaultCacheManager().getFileFromCache(url);
    if (fileInfo == null) {
      controller = VideoPlayerController.networkUrl(Uri.parse(url))
        ..initialize().then((value) async {
          await DefaultCacheManager().getSingleFile(url).then((value) {
            print('downloaded successfully done for $url');
          });
          // setState(() {
          //   _controller(i)!.play();
          // });
        });
    } else {
      controller = VideoPlayerController.file(fileInfo.file)
        ..initialize().then((value) {
          print('load video from cache');
          // setState(() {
          //   _controller.play();
          // });
        });
    }

    _controllers[videoNetworks[i]] = controller;
  }

  void _stopController(int i) {
    _controller(i)?.pause();
    _controller(i)?.seekTo(const Duration(milliseconds: 0));
  }

  void _playController(int i) {
    setState(() {
      _controller(i)?.play();
    });
  }

  VideoPlayerController? _controller(int i) {
    print(_controllers);
    return _controllers[videoNetworks[i]];
  }

  void _changeVideo(int i) {
    print('currentIndex $currentIndex');
    print('newIndex $i');
    if (_stop || i == videoNetworks.length - 1) {
      return;
    }
    _stop = true;

    _stopController(currentIndex);

    _playController(i);

    _initController(i + 1).whenComplete(() => _stop = false);
  }

  void _clearCache() {
    DefaultCacheManager().emptyCache();
    print('cache empty');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Playing ${currentIndex + 1} of ${videoNetworks.length}"),
      ),
      body: PageView.builder(
        itemCount: videoNetworks.length,
        scrollDirection: Axis.vertical,
        onPageChanged: (index) {
          _changeVideo(index);
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) => Video(controller: _controller(index)),
      ),
    );
  }
}
