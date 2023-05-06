import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

class DuctsAudioPlayer extends StatefulWidget {
  final String? audioFile;
  const DuctsAudioPlayer({super.key, this.audioFile});

  @override
  State<DuctsAudioPlayer> createState() => _DuctsAudioPlayerState();
}

class _DuctsAudioPlayerState extends State<DuctsAudioPlayer> {
  List<dynamic> itemList = [];
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Source? source;
  bool isPlaying = false;
  Source? audioUrl;
  play() async {
    audioUrl = await UrlSource(widget.audioFile.toString());
    await audioPlayer.play(audioUrl!);
  }

  @override
  void initState() {
    super.initState();
    if (widget.audioFile != null) {
      play();
    }
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // audioPlayer.play(audioUrl!);
    return widget.audioFile == null
        ? Container()
        : Wrap(children: [
            Icon(
              CupertinoIcons.music_note_2,
              color: CupertinoColors.systemYellow,
              size: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 11),
                            blurRadius: 11,
                            color: Colors.black.withOpacity(0.06))
                      ],
                      borderRadius: BorderRadius.circular(18),
                      color: CupertinoColors.lightBackgroundGray),
                  padding: const EdgeInsets.all(5.0),
                  child: TitleText('Playing Now')),
            ),
          ]);
  }
}

class AudioVisualizer extends HookWidget {
  final int? duration;
  final RxBool isPlaying;
  const AudioVisualizer({
    super.key,
    required this.isPlaying,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    List<Color> color = [
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.redAccent,
      Colors.yellowAccent
    ];
    List<int> duration = [900, 700, 600, 800, 500];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List<Widget>.generate(
          10,
          (index) => VisualComponent(
                isPlaying.value,
                duration: duration[index % 5],
                color: color[index % 4],
              )),
    );
  }
}

class VisualComponent extends HookWidget {
  final int duration;
  final Color color;
  final bool isPlaying;
  const VisualComponent(
    this.isPlaying, {
    super.key,
    required this.duration,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final audioAnimationController =
        useAnimationController(duration: Duration(milliseconds: duration));
    final audioCuvreAnimation = CurvedAnimation(
        parent: audioAnimationController, curve: Curves.easeInOutSine);
    Animation<double>? anim =
        Tween<double>(begin: 0, end: 100).animate(audioCuvreAnimation)
          ..addListener(() {
            // playing.value == true
            //     ?
            audioAnimationController.repeat(reverse: true);
            //  : audioAnimationController.stop();
          });
    final audioAnim = useAnimation(anim);
    useEffect(
      () {
        audioAnim;
        audioAnimationController.forward();
        // anim;

        return () {};
      },
      [isPlaying],
    );
    return Container(
      width: 10,
      height: audioAnim,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(0, 11),
            blurRadius: 11,
            color: Colors.black.withOpacity(0.06))
      ], borderRadius: BorderRadius.circular(5), color: color),
      padding: const EdgeInsets.all(5.0),
    );
  }
}
