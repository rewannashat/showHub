import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MoviePlayerScreen extends StatefulWidget {
  final String movieUrl;

  const MoviePlayerScreen({Key? key, required this.movieUrl}) : super(key: key);

  @override
  _MoviePlayerScreenState createState() => _MoviePlayerScreenState();
}

class _MoviePlayerScreenState extends State<MoviePlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

  Future<void> initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.movieUrl))
        ..initialize().then((_) {
          setState(() {
            _isInitialized = true;
          });
          _controller.play();
        }).catchError((error) {
          print("Error initializing video: $error");
          setState(() {
            _isError = true;
          });
        });
    } catch (e) {
      print("Exception initializing video: $e");
      setState(() {
        _isError = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Movie Player"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: _isError
            ? Text("Error loading video", style: TextStyle(color: Colors.white))
            : _isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : CircularProgressIndicator(color: Colors.white),
      ),
      floatingActionButton: _isInitialized
          ? FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      )
          : null,
    );
  }
}
