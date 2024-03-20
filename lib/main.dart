import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traffic/models.dart';
import 'package:traffic/network_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'SMART Traffic Monitoring System'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isRefreshing = false;
  bool hasUpdatedData = false;

  int previousReadId = 0;
  int numberOfRefreshes = 0;

  late NetworkHandler networkHandler;

  dynamic valueGotten = 0;
  String traficStatus = '';

  getUpdatedInfo() async {
    setState(() {
      isRefreshing = true;
      hasUpdatedData = false;
    });

    await Future.delayed(const Duration(milliseconds: 1000));
    final resp = await networkHandler.makeAPICall();

    if (!resp.$2) {
      setState(() {
        isRefreshing = false;
        hasUpdatedData = false;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error fetching data'),
          ),
        );
      }

      return;
    }

    final trafficInfo = resp.$1;

    if (trafficInfo!.feeds.isNotEmpty) {
      final currentFeed = resp.$1!.feeds.last;

      if (currentFeed.entryId > previousReadId) {
        if (numberOfRefreshes > 0) {
          traficStatus = resp.$1!.feeds.last.field1;
        }
        previousReadId = currentFeed.entryId;
      } else {
        // traficStatus = '';
      }
    } else {
      traficStatus = '';
    }

    numberOfRefreshes += 1;
    setState(() {
      isRefreshing = false;
      hasUpdatedData = true;
    });
  }

  @override
  void initState() {
    super.initState();

    networkHandler = NetworkHandler(
        endpoint:
            'https://api.thingspeak.com/channels/2431842/feeds.json?api_key=02RTGPILL631LICX&results=2');

    //  Make a call every 3 seconds
    getUpdatedInfo();
    Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        getUpdatedInfo();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            // if (!hasUpdatedData)
            // Positioned(
            //   left: 10,
            //   top: 10,
            //   child: AnimatedOpacity(
            //     duration: const Duration(milliseconds: 300),
            //     opacity: hasUpdatedData ? 0 : 1,
            //     child: Text(
            //       'NB: Data isn\'t most recent',
            //       style: Theme.of(context).textTheme.titleMedium?.copyWith(
            //             color: Colors.redAccent,
            //           ),
            //     ),
            //   ),
            // ),

            Positioned(
              left: 10,
              top: 20,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isRefreshing ? 1 : 0,
                child: Row(
                  children: [
                    const CupertinoActivityIndicator(),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Refreshing data',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, -0.5),
              child: Image.asset(
                'assets/car_location_1.png',
                height: 200,
              ),
            ),
            Positioned(
              top: 70,
              left: 10,
              child: Column(
                children: [
                  Text(
                    'Location: Futa South gate',
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Traffic Status',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 20),
                  ),
                  Text(
                    traficStatus.isEmpty ? '...' : '$traficStatus traffic',
                  ),
                  // Text(
                  //   'approx less than ${valueGotten.toString()} vehicles',
                  //   style: Theme.of(context).textTheme.headlineMedium,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getUpdatedInfo,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
