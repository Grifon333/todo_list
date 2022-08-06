import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'ui/widgets/app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
}