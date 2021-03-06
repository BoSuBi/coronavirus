import 'package:coronavirus/app/repositories/data_repository.dart';
import 'package:coronavirus/app/services/api.dart';
import 'package:coronavirus/app/ui/endpoint_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int? _cases;
  
  @override
  void initState() {
    super.initState();
    _updateData();
  }

  Future<void> _updateData() async {
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    final cases = await dataRepository.getEndpointData(Endpoint.cases);
    setState(() => _cases = cases);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Corona Tracker"),
      ),
      body: RefreshIndicator(
              onRefresh: _updateData,
              child: ListView(
          children: <Widget>[
            EndpointCard(
              endpoint: Endpoint.cases,
              value: _cases,
            )
          ],
        ),
      ),
    );
  }
}