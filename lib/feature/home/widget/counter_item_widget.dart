import 'package:flutter/material.dart';
import 'package:plusone_counter/model/counter_model.dart';
import 'package:plusone_counter/utils/helper_classes/helper_function.dart';
import 'package:plusone_counter/utils/initials/app_routes.dart';

class CounterWidget extends StatelessWidget {
  final CounterModel counterModel;
  final Function onDeleteClick;
  final Function onClearRecordsClicked;
  const CounterWidget(
      {super.key,
      required this.counterModel,
      required this.onDeleteClick,
      required this.onClearRecordsClicked});

  @override
  Widget build(BuildContext context) {
    String goalStreakString = '';
    if (counterModel.dailyGoal != null) {
      goalStreakString += '🎯 ${counterModel.dailyGoal}';
    }
    if (counterModel.counterRecords.isNotEmpty) {
      goalStreakString +=
          ' 🔥 ${HelperFunction.getContinousStreak(counterModel.counterRecords)}';
    }

    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(RouteName.counterDetailScreen, arguments: counterModel);
      },
      child: Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
        margin: const EdgeInsets.only(top: 8),
        // height: 78,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    counterModel.counterTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                SizedBox(width: 4),
                if (goalStreakString.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).scaffoldBackgroundColor),
                    child: Container(
                      child: Text(
                        '$goalStreakString',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                // SizedBox(width: 8),
                PopupMenuButton(
                  itemBuilder: (ctx) => const [
                    PopupMenuItem(
                      value: 2,
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: Text('Delete'),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Text('Clear all records'),
                    ),
                  ],
                  onSelected: (value) async {
                    if (value == 1) {
                      var response =
                          await HelperFunction.showConfromationDialogBox(
                              'Are you sure, you want to delete this counter ?',
                              context);
                      if (response) onDeleteClick();
                    } else if (value == 2) {
                      Navigator.of(context).pushNamed(
                          RouteName.addCounterScreen,
                          arguments: counterModel);
                    } else if (value == 3) {
                      onClearRecordsClicked();
                    }
                  },
                  // child: const CircleAvatar(
                  //   radius: 24,
                  //   child: Icon(
                  //     Icons.edit_outlined,
                  //     size: 18,
                  //   ),
                  // ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
