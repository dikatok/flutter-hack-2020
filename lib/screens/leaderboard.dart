import 'package:CoronaDOOM/helpers/helpers.dart';
import 'package:flutter/material.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<Score> scores;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      scores = await getLeaderBoard();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned(
              top: -2,
              left: -2,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(8),
                  ),
                  color: Colors.black.withOpacity(0.3),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: IconButton(
                  constraints:
                      const BoxConstraints(maxWidth: 32, maxHeight: 32),
                  icon: const Icon(Icons.chevron_left),
                  iconSize: 32,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(0),
                  color: Colors.green,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width / 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: scores
                        ?.map((score) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  score.name,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  score.score.toString(),
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                  ),
                                )
                              ],
                            ))
                        ?.toList() ??
                    [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
