import 'dart:async';

void main() async {
  // final Stream<int> stream = numberCreator();

  // #روش اول گوش دادن
  // // stream.listen((event) {
  // //   print(event);
  // // });

  // #روش دوم گوش دادن
  // await for (final event in stream) {
  //   print(event);
  // }

  //-----------------------------------------------

  // final Stream<int> stream = NumberCreator().stream;
  // final Stream<int> stream = NumberCreator().streamController.stream;

  // await for (final event in stream) {
  //   print(event);
  // }

  // final subscription = stream.listen((event) {
  //   print(event);
  // });
  // subscription.cancel();

  //-----------------------------------------------
  // #روش سوم ساختن

  // final Stream<int> stream =
  //     NumberCreator().streamController.stream.where((event) => event % 2 == 0);

  final Stream<int> stream = NumberCreator().streamController.stream.skip(3);
  await for (final event in stream) {
    print(event);
  }
}

// #روش اول ساختن
// Stream<int> numberCreator() async* {
//   int value = 1;
//   while (true) {
//     yield value++;
//     await Future.delayed(const Duration(seconds: 1));
//   }
// }

//-----------------------------------------------

// #روش دوم ساختن
class NumberCreator {
  final StreamController<int> streamController = StreamController();
  int value = 1;
  NumberCreator() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (value < 15) {
        // streamController.sink.add(value++);
        streamController.add(value++);
      } else {
        streamController.close();
      }
    });
  }

  Stream<int> get stream => streamController.stream;
}
