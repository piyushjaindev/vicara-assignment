import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vicara_assignment/blocs/login_cubit/login_cubit.dart';

import '../services/websocket.dart';

class SensorsScreen extends StatefulWidget {
  SensorsScreen({Key? key}) : super(key: key);

  @override
  _SensorsScreenState createState() => _SensorsScreenState();
}

class _SensorsScreenState extends State<SensorsScreen> {
  final WebSocket _socket = WebSocket();

  List<String> _socketResponse = [];

  void signOut() {
    _socket.dispose();
    context.read<LoginCubit>().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensors'),
        actions: [
          IconButton(onPressed: signOut, icon: Icon(Icons.logout_sharp))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Column(
          children: [
            ..._buildAccelerometerSection(),
            SizedBox(height: 10),
            ..._buildGyroscopeSection(),
            SizedBox(height: 10),
            Expanded(child: _buildWebsocketListView())
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAccelerometerSection() {
    return [
      Text(
        'Accelerometer',
        style: Theme.of(context).textTheme.headline4,
      ),
      SizedBox(height: 10),
      StreamBuilder<AccelerometerEvent>(
        stream: accelerometerEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData)
            _socket.addSocketEvent('accelerometer', {
              'x': snapshot.data!.x.toStringAsPrecision(5),
              'y': snapshot.data!.y.toStringAsPrecision(5),
              'z': snapshot.data!.z.toStringAsPrecision(5),
            });
          return DataTable(
            dataTextStyle: TextStyle(color: Colors.red),
            dividerThickness: 0,
            showBottomBorder: true,
            headingRowColor: MaterialStateProperty.all(Color(0xffDFECFF)),
            dataRowColor: MaterialStateProperty.all(Color(0xffF0F6FF)),
            columns: [
              DataColumn(label: Text('x')),
              DataColumn(label: Text('y')),
              DataColumn(label: Text('z')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text(snapshot.data?.x.toStringAsPrecision(5) ?? '')),
                DataCell(Text(snapshot.data?.y.toStringAsPrecision(5) ?? '')),
                DataCell(Text(snapshot.data?.z.toStringAsPrecision(5) ?? '')),
              ]),
            ],
          );
        },
      ),
    ];
  }

  List<Widget> _buildGyroscopeSection() {
    return [
      Text(
        'Gyroscope',
        style: Theme.of(context).textTheme.headline4,
      ),
      SizedBox(height: 10),
      StreamBuilder<GyroscopeEvent>(
        stream: gyroscopeEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData)
            _socket.addSocketEvent('gyroscope', {
              'x': snapshot.data!.x.toStringAsPrecision(5),
              'y': snapshot.data!.y.toStringAsPrecision(5),
              'z': snapshot.data!.z.toStringAsPrecision(5),
            });
          return DataTable(
            dataTextStyle: TextStyle(color: Colors.red),
            dividerThickness: 0,
            showBottomBorder: true,
            headingRowColor: MaterialStateProperty.all(Color(0xffDFECFF)),
            dataRowColor: MaterialStateProperty.all(Color(0xffF0F6FF)),
            columns: [
              DataColumn(label: Text('x')),
              DataColumn(label: Text('y')),
              DataColumn(label: Text('z')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text(snapshot.data?.x.toStringAsPrecision(5) ?? '')),
                DataCell(Text(snapshot.data?.y.toStringAsPrecision(5) ?? '')),
                DataCell(Text(snapshot.data?.z.toStringAsPrecision(5) ?? '')),
              ]),
            ],
          );
        },
      ),
    ];
  }

  Widget _buildWebsocketListView() {
    return Column(
      children: [
        Text(
          'Websocket',
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(height: 10),
        Expanded(
          child: StreamBuilder<String>(
            stream: _socket.getSocketEvents,
            builder: (context, snapshot) {
              if (snapshot.hasData) _socketResponse.add(snapshot.data!);
              print('length = ${_socketResponse.length}');
              return ListView.separated(
                itemCount: _socketResponse.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(_socketResponse[index]),
                ),
                separatorBuilder: (context, index) => Divider(
                  thickness: 0.5,
                  color: Colors.black54,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
