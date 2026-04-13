import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AppData.dart';
import '../models/drone.dart';
import '../models/hangar.dart';

final AppData appData = AppData();

class HangarScreen extends StatelessWidget {
  const HangarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;


    final occupiedBays = appData.hangar.bays
        .where((bay) => bay.assignedDrone != null)
        .length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hangar Bays',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '$occupiedBays of ${appData.hangar.bays.length} bays occupied',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          buildBaysGridView(),
        ],
      ),
    );
  }

  Expanded buildBaysGridView() {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          final crossAxisCount = width < 380 ? 2 : 3;
          final aspectRatio = crossAxisCount == 2 ? 1.0 : 0.85;

          return GridView.builder(
            padding: const EdgeInsets.all(2),
            itemCount: appData.hangar.bays.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 14,
              childAspectRatio: aspectRatio,
            ),
            itemBuilder: (BuildContext context, int index) {
              return hangarBayCard(
                appData.hangar.bays[index],
                index,
                context,
              );
            },
          );
        },
      ),
    );
  }

  Widget hangarBayCard(Bay bay, int index, BuildContext context) {
    final assignedDrone = bay.assignedDrone;
    final droneName = assignedDrone == null ? 'Empty' : assignedDrone.name;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: assignedDrone == null
            ? Colors.transparent
            : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: assignedDrone == null
              ? Colors.grey.shade300
              : Colors.blue.shade200,
          width: 1.2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          print('Bay tapped');
        },
        child: Padding(
          padding: const EdgeInsets.all(9.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bay label
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: assignedDrone == null
                        ? Colors.grey.shade400
                        : Colors.blue.shade200,
                    width: 0.5,
                  ),
                  color: assignedDrone == null
                      ? null
                      : Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                child: Text(
                  'Bay ${index + 1}',
                  style: textTheme.titleSmall?.copyWith(
                    color: assignedDrone == null
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // Icon circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: assignedDrone == null
                      ? Colors.grey.shade200
                      : Colors.blue.shade100,
                ),
                child: Icon(
                  assignedDrone == null ? Icons.add : Icons.flight,
                ),
              ),

              const SizedBox(height: 6),

              // Drone name
              Text(
                droneName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}