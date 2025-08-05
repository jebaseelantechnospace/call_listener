import 'package:flutter/material.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:call_state_listener/call_state_listener.dart';

Future<void> requestPhonePermission() async {
  var status = await Permission.phone.status;
  if (!status.isGranted) {
    await Permission.phone.request();
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _callStatus = 'Unknown';
  StreamSubscription<String>? _subscription;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await requestPhonePermission();
    _startListening();
  }

  void _startListening() {
    _subscription = CallStateListener.callStateStream.listen((status) {
      setState(() {
        _callStatus = status;
        print('Current call status $_callStatus');
      });
    }, onError: (error) {
      setState(() {
        _callStatus = 'Error: $error';
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Call State Listener'),
        ),
        body: Center(
          child: Text(
            'Call Status: $_callStatus',
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:flutter/services.dart';

// void main() {
//   runApp(MaterialApp(home: CallStatePage()));
// }

// class CallStatePage extends StatefulWidget {
//   @override
//   _CallStatePageState createState() => _CallStatePageState();
// }

// class _CallStatePageState extends State<CallStatePage> {
//   static const EventChannel _channel = EventChannel('phone_state_channel');
//   late StreamSubscription _sub;
//   String _status = 'NONE';
//   int _duration = 0;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsFlutterBinding.ensureInitialized();
//     _sub = _channel.receiveBroadcastStream().listen((dynamic data) {
//       final map = data as Map<dynamic, dynamic>;
//       setState(() {
//         _status = map['status'] ?? 'UNKNOWN';
//         _duration = map['duration'] ?? 0;
//       });
//       print('Call state: $_status, duration: $_duration');
//     }, onError: (err) {
//       print('Stream error: $err');
//     });
//   }

//   @override
//   void dispose() {
//     _sub.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Call State Listener POC')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Status: $_status'),
//             SizedBox(height: 10),
//             Text('Duration: $_duration sec'),
//           ],
//         ),
//       ),
//     );
//   }
// }
