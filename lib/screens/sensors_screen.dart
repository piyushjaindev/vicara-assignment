import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/login_cubit/login_cubit.dart';
import '../services/websocket.dart';
import '../blocs/sensor_cubit/sensor_cubit.dart';

class SensorsScreen extends StatefulWidget {
  SensorsScreen({Key? key}) : super(key: key);

  @override
  _SensorsScreenState createState() => _SensorsScreenState();
}

class _SensorsScreenState extends State<SensorsScreen> {
  late WebSocket _socket;
  List<String> _socketResponse = [];

  void signOut() {
    context.read<LoginCubit>().signOut();
  }

  @override
  void initState() {
    super.initState();
    _socket = RepositoryProvider.of<WebSocket>(context);
  }

  @override
  void dispose() {
    _socket.dispose();
    super.dispose();
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
      BlocBuilder<SensorCubit, SensorStates>(
          buildWhen: (oldState, newState) => newState is AccelerometerState,
          builder: (context, state) {
            if (state is AccelerometerState)
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
                    DataCell(Text(
                        state.accelerometerReading.x.toStringAsFixed(5) ?? '')),
                    DataCell(Text(
                        state.accelerometerReading.y.toStringAsFixed(5) ?? '')),
                    DataCell(Text(
                        state.accelerometerReading.z.toStringAsFixed(5) ?? '')),
                  ]),
                ],
              );
            else
              return Container();
          }),
    ];
  }

  List<Widget> _buildGyroscopeSection() {
    return [
      Text(
        'Gyroscope',
        style: Theme.of(context).textTheme.headline4,
      ),
      SizedBox(height: 10),
      BlocBuilder<SensorCubit, SensorStates>(
        buildWhen: (oldState, newState) => newState is GyroscopeState,
        builder: (context, state) {
          if (state is GyroscopeState)
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
                  DataCell(
                      Text(state.gyroscopeReading.x.toStringAsFixed(5) ?? '')),
                  DataCell(
                      Text(state.gyroscopeReading.y.toStringAsFixed(5) ?? '')),
                  DataCell(
                      Text(state.gyroscopeReading.z.toStringAsFixed(5) ?? '')),
                ]),
              ],
            );
          else
            return Container();
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
