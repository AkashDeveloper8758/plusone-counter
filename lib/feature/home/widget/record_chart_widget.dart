import 'package:flutter/material.dart';
import 'package:plusone_counter/model/counter_record_model.dart';
import 'package:plusone_counter/utils/custom_components/custom_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RecordChart extends StatefulWidget {
  final List<CounterRecordModel> counterRecordList;
  const RecordChart({super.key, required this.counterRecordList});

  @override
  State<RecordChart> createState() => _RecordChartState();
}

class _RecordChartState extends State<RecordChart> {
  bool _isShowBarGraph = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                series: <ChartSeries>[
                  // Renders line chart
                  LineSeries<CounterRecordModel, DateTime>(
                    dataSource: widget.counterRecordList,
                    xValueMapper: (datum, index) => datum.dateTime,
                    yValueMapper: (datum, index) => datum.countValue,
                    color: Theme.of(context).primaryColor,
                  )
                ])),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: CustomButton(
              title: '${_isShowBarGraph ? 'hide' : 'show'} bar chart',
              onPressed: () {
                _isShowBarGraph = !_isShowBarGraph;
                setState(() {});
              }),
        ),
        if (_isShowBarGraph)
          Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<CounterRecordModel, DateTime>>[
                    ColumnSeries<CounterRecordModel, DateTime>(
                        dataSource: widget.counterRecordList,
                        xValueMapper: (data, _) => data.dateTime,
                        yValueMapper: (data, _) => data.countValue,
                        name: 'Counter Data',
                        color: Theme.of(context).primaryColor)
                  ])),
      ],
    );
  }
}
