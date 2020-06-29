import 'dart:async';
import 'dart:math';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

final uuid = Uuid();
final random = Random();

const MAX_VIRUSES = 10;

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  ArCoreController arCoreController;
  ArCoreNode sphereNode;
  ArCoreSphere sphere;
  Timer timer;

  Set<String> viruses = {};
  int score = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              ArCoreView(
                onArCoreViewCreated: _onArCoreViewCreated,
                enableTapRecognizer: true,
              ),
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
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                    ),
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                  child: Text(
                    "Score: ${score.toString()}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -2,
                left: -2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                    ),
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                  child: Text(
                    "Number of virus: ${viruses.length}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onArCoreViewCreated(ArCoreController controller) async {
    final texture = await rootBundle.load('assets/corona.png');

    final material = ArCoreMaterial(
      textureBytes: texture.buffer.asUint8List(),
      metallic: 0,
      reflectance: 0,
      roughness: 1,
      color: Colors.transparent,
    );

    sphere = ArCoreSphere(materials: [material]);

    arCoreController = controller;

    arCoreController.onNodeTap = _removeMonster;

    _addMonster(first: true);

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _addMonster();
    });
  }

  Future<void> _addMonster({bool first = false}) async {
    if (viruses.length >= MAX_VIRUSES) return;

    final monster = uuid.v1();

    final x = first ? 0.0 : (-5 + random.nextDouble() * 10);
    final y = first ? 0.0 : (-2 + random.nextDouble() * 4);
    const z = -3.0;

    final horizontalTheta = atan(x / z.abs());

    final newZ = z.abs() * sin(pi / 2 - horizontalTheta);

    final newX = newZ / tan(pi / 2 - horizontalTheta);

    final yAxisRotation = vector.Quaternion.axisAngle(
      vector.Vector3(0, 1, 0),
      pi / 2 - horizontalTheta,
    );
    // final verticalTheta = asin(y / newZ.abs());
    // final xAxisRotation =
    //     vector.Quaternion.axisAngle(vector.Vector3(1, 0, 0), verticalTheta);

    final position = vector.Vector3(newX, y, -newZ);

    final rotation = yAxisRotation;
    // var rotation = xAxisRotation * yAxisRotation;

    final rotationVector = vector.Vector4(
      rotation.x,
      rotation.y,
      rotation.z,
      rotation.w,
    );

    sphereNode = ArCoreNode(
      name: monster,
      shape: sphere,
      position: position,
      rotation: rotationVector,
    );

    viruses.add(monster);
    arCoreController.addArCoreNode(sphereNode);
    setState(() {});

    final isGameOver = viruses.length >= MAX_VIRUSES;

    if (isGameOver) {
      _gameOver();
    }
  }

  Future<void> _removeMonster(String monster) async {
    if (!monster.contains(monster)) return;
    viruses.remove(monster);
    arCoreController.removeNode(nodeName: monster);
    setState(() {
      score += 100;
    });
  }

  void _gameOver() {
    showDialog(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        backgroundColor: Colors.black,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
        scrollable: true,
        content: Column(
          children: [
            const Text(
              "GAME OVER",
              style: TextStyle(
                color: Colors.red,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Final score: $score",
              style: const TextStyle(color: Colors.green, fontSize: 24),
            ),
            const SizedBox(height: 32),
            FlatButton(
              padding: const EdgeInsets.all(16),
              shape: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
              onPressed: Navigator.of(context).pop,
              child: const Text(
                "Return",
                style: TextStyle(color: Colors.green, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    ).then((value) => Navigator.of(context).pop());
  }

  @override
  void dispose() {
    timer.cancel();
    arCoreController.dispose();
    super.dispose();
  }
}
