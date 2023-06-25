import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/injection/service_locator.dart';
import 'core/localizations/localization_service.dart';
import 'core/services/app_services_mixin.dart';
import 'core/services/messenger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await configureDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: LocalizationService.supportedLocale,
      fallbackLocale: LocalizationService.fallbackLocale,
      startLocale: LocalizationService.startLocale,
      path: LocalizationService.localeAssetsPath,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, Widget? __) => MaterialApp(
        title: 'Flutter Demo',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(primarySwatch: Colors.blue),
        scaffoldMessengerKey:
            getIt<MessengerService>().rootScaffoldMessengerKey,
        home: Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) => const MyHomePage(
                title: 'Flutter Demo Home Page',
              ),
            ),
          ],
        ),
        builder: (context, child) {
          getIt<LocalizationService>().setCurrentLocale(context.locale);
          return child ?? const SizedBox();
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AppServicesMixin {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
