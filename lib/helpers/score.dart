import 'package:CoronaDOOM/helpers/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

FirebaseApp app;
Firestore firestore;

class Score {
  String name;
  int score;

  Score(this.name, this.score);
}

Future<void> initScoring() async {
  final env = DotEnv().env;

  app = await FirebaseApp.configure(
    name: env["APP"],
    options: const FirebaseOptions(
      googleAppID: '1:79601577497:ios:5f2bcc6ba8cecddd',
      apiKey: 'AIzaSyArgmRGfB5kiQT6CunAOmKRVKEsxKmy6YI-G72PVU',
      projectID: 'flutter-hack-2020-corona-doom',
    ),
  );

  firestore = Firestore(app: app);
}

Future<void> updateScore(String name, int score) async {
  final user = await getCurrentUser();

  await Firestore.instance
      .collection("scores")
      .document(user.uid)
      .setData({"name": name, "score": score});
}

Future<List<Score>> getLeaderBoard({int limit = 10}) async {
  final docs = await Firestore.instance
      .collection("scores")
      .orderBy("score", descending: true)
      .limit(limit)
      .getDocuments();

  return docs.documents
      .map((s) => Score(s["name"] as String, s["score"] as int))
      .toList();
}
