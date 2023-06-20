import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcam_dashboard/data/api/api_client.dart';
import 'package:smartcam_dashboard/data/models/alert.dart';
import 'package:smartcam_dashboard/data/repositories/auth_repository.dart';
import 'package:smartcam_dashboard/utils/utils.dart';
import 'package:smartcam_dashboard/views/components/exa_app_bar.dart';
import 'package:video_player/video_player.dart';

class AlertDetailScreen extends StatefulWidget {
  static const String routeName = '/alert_detail_screen';
  final Alert alert;
  const AlertDetailScreen({super.key, required this.alert});

  @override
  State<AlertDetailScreen> createState() => _AlertDetailScreenState();
}

class _AlertDetailScreenState extends State<AlertDetailScreen> {
  late final VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  late final AuthRepository _cognitoAuthRepo;
  @override
  void initState() {
    super.initState();
    _cognitoAuthRepo = RepositoryProvider.of<AuthRepository>(context);
  }

  _initialize(String url) async {
    logging(url);
    videoPlayerController = VideoPlayerController.network(url);
    await videoPlayerController.initialize();
    chewieController = ChewieController(
      deviceOrientationsOnEnterFullScreen: [DeviceOrientation.portraitUp],
      showOptions: true,
      aspectRatio: videoPlayerController.value.aspectRatio,
      videoPlayerController: videoPlayerController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ExaAppBar(showLogOutButton: false),
      body: widget.alert.s3Path == null
          ? Center(
              child: Text('No video available'),
            )
          : FutureBuilder<String>(
              future: _cognitoAuthRepo.getJwtToken(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final token = snapshot.data;
                  Clipboard.setData(ClipboardData(text: token ?? ""));
                  print(token);
                  final s3Key =
                      ApiClient.pathToKey(s3Path: widget.alert.s3Path!);
                  final url =
                      ApiClient.getJWTQuery(s3Key: s3Key, token: token!);
                  return FutureBuilder(
                    future: _initialize(url),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.width *
                              1 /
                              videoPlayerController.value.aspectRatio,
                          width: MediaQuery.of(context).size.width,
                          child: Chewie(
                            controller: chewieController,
                          ),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor),
                      );
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                );
              }),
    );
  }
}
