# Corona-DOOM

Flutter Hack20 Submission

## What about the app

This app, or more of a game, is a DOOM-like game in which monsters resembles coronavirus. The game is using AR, so player can interract with their surrounding while busting up the viruses. At this initial version, the viruses will only appear within 180 degrees in front of player (left to right).

## How to install

Prerequisites:

- Real android device (I don't think emulator will work) that supports AR Core (update: maybe it does, see [here](https://developers.google.com/ar/develop/java/emulator))
- Flutter installation
- IDE of your choice (optional)

Once you fulfill the prerequisites, you can just install using flutter debug / flutter run.

## Problems

- Weird interraction between `arcore_flutter_plugin` and `google_sign_in`, thus I cannot use Google sign in and instead opted to anonymous sign in

## Playstore

## Resources

- [ARCore Flutter Plugin: configurations](https://medium.com/@difrancescogianmarco/arcore-flutter-plugin-configurations-3ee53f2dc749)
- [ARCore Flutter Plugin: add object on the plane](https://medium.com/@difrancescogianmarco/arcore-flutter-plugin-add-object-on-the-plane-8b3d7cbde3d3)
- [Epic Coronavirus Monster Vector](https://www.freepik.com/premium-vector/corona-virus-monster_7626116.htm)
