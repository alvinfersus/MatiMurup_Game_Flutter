import 'package:flutter/material.dart';

class GameGrid extends StatelessWidget {
  final int gridCount;
  final bool activeBoxStatus;
  final bool interaksi;
  final List<int> randomNumber;
  final Function(int) onTap;
  final int inActiveStatus;

  GameGrid(
      {required this.gridCount,
      required this.activeBoxStatus,
      required this.interaksi,
      required this.randomNumber,
      required this.onTap,
      required this.inActiveStatus});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Tetap tiga kolom
        crossAxisSpacing: 10, // Spasi antar kolom
        mainAxisSpacing: 10, // Spasi antar baris
      ),
      itemCount: gridCount,
      itemBuilder: (BuildContext context, int index) {
        // int boxNumber = -1;
        // if (inActiveStatus < gridCount) {
        //   boxNumber = randomNumber[inActiveStatus];
        // }

        // bool isCorrectBox = activeBoxStatus && boxNumber == index;
        bool isAnimating = index == inActiveStatus && activeBoxStatus;

        return GestureDetector(
          onTap: interaksi ? () { onTap(index); } : null, // Menonaktifkan tombol saat interaksi adalah false
          child: Container(
            // color: isCorrectBox ? Colors.yellow : activeBoxStatus ? Colors.grey : Colors.grey,
            color: isAnimating ? Colors.yellow : Colors.grey,
          ),
        );
      },
    );
  }
}
