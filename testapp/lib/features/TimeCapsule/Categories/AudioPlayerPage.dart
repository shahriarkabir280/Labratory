import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerPage extends StatefulWidget {
  final String filePath; // This is the Cloudinary URL now
  final String fileName;

  const AudioPlayerPage({
    required this.filePath,
    required this.fileName,
    Key? key,
  }) : super(key: key);

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  double _currentPosition = 0.0;
  double _totalDuration = 1.0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // Use setUrl to stream audio from Cloudinary URL
      await _audioPlayer.setUrl(widget.filePath);
      setState(() {
        _totalDuration = _audioPlayer.duration?.inSeconds.toDouble() ?? 1.0;
      });

      // Listen to position updates
      _audioPlayer.positionStream.listen((position) {
        setState(() {
          _currentPosition = position.inSeconds.toDouble();
        });
      });

      // Listen to play/pause state updates
      _audioPlayer.playingStream.listen((isPlaying) {
        setState(() {
          this.isPlaying = isPlaying;
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading audio: $e")),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Play/Pause button functionality
  void _playPause() {
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  // Seek forward by 10 seconds
  void _seekForward() {
    final newPosition = _currentPosition + 10.0;
    _audioPlayer.seek(Duration(seconds: newPosition.toInt()));
  }

  // Seek backward by 10 seconds
  void _seekBackward() {
    final newPosition = _currentPosition - 10.0;
    _audioPlayer.seek(Duration(seconds: newPosition.toInt()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.audiotrack,
            size: 100,
            color: Colors.blueAccent,
          ),
          const SizedBox(height: 20),
          Text(
            widget.fileName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Slider(
            value: _currentPosition,
            min: 0,
            max: _totalDuration,
            onChanged: (value) {
              _audioPlayer.seek(Duration(seconds: value.toInt()));
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10),
                iconSize: 40,
                onPressed: _seekBackward,
              ),
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                iconSize: 60,
                onPressed: _playPause,
              ),
              IconButton(
                icon: const Icon(Icons.forward_10),
                iconSize: 40,
                onPressed: _seekForward,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
