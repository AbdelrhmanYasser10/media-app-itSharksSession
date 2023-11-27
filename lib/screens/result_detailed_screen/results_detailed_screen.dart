import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_app/models/image_model/image_model.dart';
import 'package:media_app/models/video_model/video_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:appinio_video_player/appinio_video_player.dart';

class ResultsDetailedScreen extends StatefulWidget {
  final ImageModel? image;
  final VideoModel? videoModel;
  const ResultsDetailedScreen({Key? key, this.image, this.videoModel})
      : super(key: key);

  @override
  State<ResultsDetailedScreen> createState() => _ResultsDetailedScreenState();
}

class _ResultsDetailedScreenState extends State<ResultsDetailedScreen> {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if(widget.videoModel != null) {
      setState(() {
        isLoading = true;
      });
      if(kDebugMode){
        print(widget.videoModel!.url);
      }
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoModel!.url))
        ..initialize().then((value) => setState(() {
          isLoading = false;
        }));
      _customVideoPlayerController = CustomVideoPlayerController(
        context: context,
        videoPlayerController: videoPlayerController,
      );
    }
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(widget.image!=null) {
      return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Image.network(
                widget.image!.originalUrl,
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                fit: BoxFit.cover,
              ),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.black45,
                    Colors.black26,
                    Colors.black12,
                    Colors.transparent,
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_outline_rounded,
                            color: Colors.blueGrey,
                            size: 32.0,
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Uri url = Uri.parse(widget.image!.photographerProfile);
                            launchUrl(url).then((value) {
                              if (!value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                    Text('Cannot launch photographer profile'),
                                  ),
                                );
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0, vertical: 8.0),
                              child: Text(
                                widget.image!.photographerName,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Center(
                          child: Text(
                            widget.image!.alt,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    else {
      return Scaffold(
        body: SafeArea(
          child: isLoading ?const Center(
            child: CircularProgressIndicator(),
          ) :Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: CustomVideoPlayer(
                        customVideoPlayerController: _customVideoPlayerController,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: const BoxDecoration(
                            color: Colors.black26,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_outline_rounded,
                            color: Colors.white,
                            size: 32.0,
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Uri url = Uri.parse(widget.videoModel!.userProfile);
                            launchUrl(url).then((value) {
                              if (!value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                    Text('Cannot launch photographer profile'),
                                  ),
                                );
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0, vertical: 8.0),
                              child: Text(
                                widget.videoModel!.userName,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      );
    }
  }
}
