import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hive/hive.dart';
import 'package:plusone_counter/model/counter_model.dart';
import 'package:plusone_counter/utils/helper_classes/helper_function.dart';
import 'package:plusone_counter/utils/initials/app_routes.dart';

class CounterWidget extends StatelessWidget {
  final CounterModel counterModel;
  final Function onDeleteClick;
  const CounterWidget(
      {super.key, required this.counterModel, required this.onDeleteClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(RouteName.counterDetailScreen, arguments: counterModel);
      },
      child: Container(
        color: Theme.of(context).highlightColor,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(top: 8),
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
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Theme.of(context).scaffoldBackgroundColor),
                  child: Container(
                    child: Text(
                      '${counterModel.dailyGoal} 🔥',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
                SizedBox(width: 8),
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
                    }
                  },
                  child: const CircleAvatar(
                    radius: 24,
                    child: Icon(
                      Icons.edit_outlined,
                      size: 18,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
