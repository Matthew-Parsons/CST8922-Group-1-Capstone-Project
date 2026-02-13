import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  
  bool _isRecording = false;
  String? _audioPath;
  int _recordingTime = 0;
  Timer? _timer;
  List<double> _audioLevels = List.filled(20, 0.1);
  Timer? _levelTimer;

  @override
  void dispose() {
    _recorder.dispose();
    _player.dispose();
    _timer?.cancel();
    _levelTimer?.cancel();
    super.dispose();
  }

  Future<void> _startRecording() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission denied')),
        );
      }
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(const RecordConfig(), path: path);
    
    setState(() {
      _isRecording = true;
      _recordingTime = 0;
      _audioPath = null;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingTime++;
      });
    });

    _levelTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      final amplitude = await _recorder.getAmplitude();
      setState(() {
        _audioLevels = List.generate(20, (index) {
          final random = Random();
          final base = amplitude.current.abs() * 100;
          return (base + random.nextDouble() * 20).clamp(10, 100);
        });
      });
    });
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stop();
    _timer?.cancel();
    _levelTimer?.cancel();
    
    setState(() {
      _isRecording = false;
      _audioPath = path;
      _audioLevels = List.filled(20, 0.1);
    });
  }

  Future<void> _playAudio() async {
    if (_audioPath != null) {
      await _player.play(DeviceFileSource(_audioPath!));
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Record Audio',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          if (!_isRecording)
            ElevatedButton(
              onPressed: _startRecording,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Start Recording', style: TextStyle(fontSize: 16)),
            )
          else
            ElevatedButton(
              onPressed: _stopRecording,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Stop Recording', style: TextStyle(fontSize: 16)),
            ),
          if (_isRecording) ...[
            const SizedBox(height: 20),
            Text(
              _formatTime(_recordingTime),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _audioLevels.map((level) {
                  return Container(
                    width: 4,
                    height: level,
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
          if (_audioPath != null) ...[
            const SizedBox(height: 30),
            const Text(
              'Recorded Audio:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _playAudio,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play Recording'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Saved to: $_audioPath',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
