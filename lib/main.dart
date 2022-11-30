import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Main',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

const url =
    'https://images.unsplash.com/photo-1659135890084-930731031f40?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8bWFjYm9vayUyMG0yfGVufDB8MHwwfHw%3D&auto=format&fit=crop&w=800&q=60';
const imageHeight = 300.0;

enum Action {
  rotateLeft,
  rotateRight,
  moreVisible,
  lessVisible,
}

class State {
  final double rotationDeg;
  final double alpha;
  State({
    required this.rotationDeg,
    required this.alpha,
  });

  const State.zero()
      : rotationDeg = 0.0,
        alpha = 1.0;

  State rotateRight() => State(
        alpha: alpha,
        rotationDeg: rotationDeg + 10.0,
      );
  State rotateLeft() => State(
        alpha: alpha,
        rotationDeg: rotationDeg - 10.0,
      );
  State increaseAlpha() => State(
        alpha: min(alpha + 0.1, 1.0),
        rotationDeg: rotationDeg,
      );
  State decreaseAlpha() => State(
        alpha: max(alpha - 0.1, 0.0),
        rotationDeg: rotationDeg,
      );
}

State reducer(State oldState, Action? action) {
  switch (action) {
    case Action.rotateLeft:
      return oldState.rotateLeft();
    case Action.rotateRight:
      return oldState.rotateRight();
    case Action.moreVisible:
      return oldState.increaseAlpha();
    case Action.lessVisible:
      return oldState.decreaseAlpha();

    case null:
      return oldState;
  }
}

//useReduces hook
class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = useReducer<State, Action?>(
      reducer,
      initialState: const State.zero(),
      initialAction: null,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RotateLeft(store: store),
                RotateRight(store: store),
                DecreaseAlpha(store: store),
                IncreaseAlpha(store: store),
              ],
            ),
            const SizedBox(height: 100),
            Opacity(
              opacity: store.state.alpha,
              child: RotationTransition(
                  turns:
                      AlwaysStoppedAnimation(store.state.rotationDeg / 360.0),
                  child: Image.network(url)),
            ),
          ],
        ),
      ),
    );
  }
}

class IncreaseAlpha extends StatelessWidget {
  const IncreaseAlpha({
    Key? key,
    required this.store,
  }) : super(key: key);

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        store.dispatch(Action.moreVisible);
      },
      child: const Text("Increase Alpha"),
    );
  }
}

class DecreaseAlpha extends StatelessWidget {
  const DecreaseAlpha({
    Key? key,
    required this.store,
  }) : super(key: key);

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        store.dispatch(Action.lessVisible);
      },
      child: const Text("Decrease Alpha"),
    );
  }
}

class RotateRight extends StatelessWidget {
  const RotateRight({
    Key? key,
    required this.store,
  }) : super(key: key);

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        store.dispatch(Action.rotateRight);
      },
      child: const Text("Rotate Right"),
    );
  }
}

class RotateLeft extends StatelessWidget {
  const RotateLeft({
    Key? key,
    required this.store,
  }) : super(key: key);

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        store.dispatch(Action.rotateLeft);
      },
      child: const Text("Rotate Left"),
    );
  }
}
