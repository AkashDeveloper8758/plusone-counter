import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:plusone_counter/controllers/home_controllers.dart';
import 'package:plusone_counter/model/counter_model.dart';
import 'package:plusone_counter/utils/custom_components/custom_button.dart';
import 'package:uuid/uuid.dart';

class CreateCounterScreen extends StatefulWidget {
  final CounterModel? counterModel;
  const CreateCounterScreen({super.key, this.counterModel});

  @override
  State<CreateCounterScreen> createState() => _CreateCounterScreenState();
}

class _CreateCounterScreenState extends State<CreateCounterScreen> {
  TextEditingController _titleController = TextEditingController();
  int dailyGoal = 0;
  List<int> incrementalsList = [-10, -50, 10, 50];
  bool _isUpdate = false;

  updateGoalCount(int inc) {
    dailyGoal += inc;
    if (dailyGoal < 0) {
      dailyGoal = 0;
    }
    setState(() {});
  }

  final _formKey = GlobalKey<FormState>();
  final HomeController _homeController = Get.find();
  @override
  void initState() {
    _isUpdate = widget.counterModel != null;
    if (_isUpdate) {
      dailyGoal = widget.counterModel!.dailyGoal ?? 0;
      _titleController.text = widget.counterModel!.counterTitle;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add your counter'),
        ),
        body: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: TextFormField(
                            controller: _titleController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Title is required';
                              }
                              return null;
                            },
                            maxLines: 2,
                            minLines: 1,
                            decoration: const InputDecoration(
                              labelText: 'Counter title',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Daily Goal',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  updateGoalCount(-1);
                                },
                                child: Icon(Icons.remove)),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: CircleAvatar(
                                  radius: 50,
                                  child: Container(
                                      child: Text(
                                    '$dailyGoal',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  )),
                                )),
                            ElevatedButton(
                                onPressed: () {
                                  updateGoalCount(1);
                                },
                                child: Icon(Icons.add)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 18),
                        child: Wrap(
                          children: incrementalsList.map((e) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              child: ElevatedButton(
                                  onPressed: () {
                                    updateGoalCount(e);
                                  },
                                  child:
                                      Text(' ${e > 0 ? "+" : "-"} ${e.abs()}')),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
                Obx(
                  () => CustomButton(
                      isLoading: _homeController.isLoading.value,
                      title: "Save counter",
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          var counterId = Uuid().v1();
                          CounterModel counterModel = CounterModel(
                              id: _isUpdate
                                  ? widget.counterModel!.id
                                  : counterId,
                              createDate: _isUpdate
                                  ? widget.counterModel!.createDate
                                  : DateTime.now(),
                              counterRecords: _isUpdate
                                  ? widget.counterModel!.counterRecords
                                  : [],
                              dailyGoal: dailyGoal > 0 ? dailyGoal : null,
                              counterTitle: _titleController.text);
                          if (_isUpdate) {
                            await _homeController
                                .updateCounterModel(counterModel);
                          } else {
                            await _homeController.addCounterModel(counterModel);
                          }
                          Navigator.of(context).pop();
                        }
                      }),
                ),
              ],
            )),
      ),
    );
  }
}
