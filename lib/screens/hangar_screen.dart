import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HangarScreen extends StatelessWidget {
  const HangarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hangar Bays',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text('5 of 12 bays occupied', style: textTheme.bodyMedium),
          SizedBox(height: 12),

          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(2),
              itemCount: 12,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemBuilder: (BuildContext context, int index) {
                return droneHangarCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget droneHangarCard() {
    return Column(

    );
  }
}
