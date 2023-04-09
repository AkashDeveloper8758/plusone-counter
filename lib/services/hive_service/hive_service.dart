import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:plusone_counter/model/counter_model.dart';
import 'package:plusone_counter/model/counter_record_model.dart';
import 'package:plusone_counter/services/hive_service/create_counter_service.dart';

class HiveService {
  final String _counterBoxName = 'counter_box';

  late CreateCounterServiceHelper createCounterServiceHelper;
  static HiveService? _hiveService;
  HiveService._();

  _init() async {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive
      ..init(appDocumentDir.path)
      ..registerAdapter(CounterModelAdapter())
      ..registerAdapter(CounterRecordModelAdapter());

    createCounterServiceHelper = CreateCounterServiceHelper(
        await Hive.openBox<CounterModel>(_counterBoxName));
  }

  static Future<HiveService> getInstance() async {
    if (_hiveService == null) {
      _hiveService = HiveService._();
      await _hiveService!._init();
      return _hiveService ??= HiveService._();
    }
    return _hiveService!;
  }
}
