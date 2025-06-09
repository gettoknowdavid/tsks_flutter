import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsks_flutter/app.dart';
import 'package:tsks_flutter/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
 
  runApp(const ProviderScope(child: TsksApp()));
}
