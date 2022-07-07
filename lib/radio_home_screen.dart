import 'package:flutter/material.dart';
import 'package:radio_player/radio_player.dart';

class RadioHomeScreen extends StatefulWidget {
  const RadioHomeScreen({Key? key}) : super(key: key);

  @override
  State<RadioHomeScreen> createState() => _RadioHomeScreenState();
}

class _RadioHomeScreenState extends State<RadioHomeScreen> {
  final RadioPlayer _radioPlayer = RadioPlayer();
  bool isPlaying = false;
  List<String>? metadata;

  @override
  void initState() {
    super.initState();
    initRadioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Radio App')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: _radioPlayer.getArtworkImage(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                Image artwork;
                if (snapshot.hasData) {
                  artwork = snapshot.data;
                } else {
                  artwork = Image.asset(
                    'assets/cover.jpg',
                    fit: BoxFit.cover,
                  );
                }
                return SizedBox(
                  height: 180,
                  width: 180,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: artwork,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              metadata?[0] ?? 'Radio X',
              softWrap: false,
              overflow: TextOverflow.fade,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(
              metadata?[1] ?? '',
              softWrap: false,
              overflow: TextOverflow.fade,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          isPlaying ? _radioPlayer.pause() : _radioPlayer.play();
        },
        tooltip: 'Control button',
        child: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
        ),
      ),
    );
  }

  void initRadioPlayer() {
    _radioPlayer.setChannel(
      title: 'Radio Player',
      url:
          'https://playerservices.streamtheworld.com/api/livestream-redirect/VIRGIN_RADIO_SC?/;',
      imagePath: 'assets/cover.jpg',
    );

    _radioPlayer.stateStream.listen((event) {
      setState(() {
        isPlaying = event;
      });
    });

    _radioPlayer.metadataStream.listen((event) {
      setState(() {
        metadata = event;
      });
    });
  }
}
