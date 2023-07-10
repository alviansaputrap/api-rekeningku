import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RekeningkuData {
  final String accid;
  final String code;
  final String changepct;
  final String bid;
  final String ask;

  RekeningkuData({
    required this.accid,
    required this.code,
    required this.changepct,
    required this.bid,
    required this.ask,
  });

  factory RekeningkuData.fromJson(Map<String, dynamic> json) {
    return RekeningkuData(
      accid: json['accid'],
      code: json['code'],
      changepct: json['changepct'],
      bid: json['bid'],
      ask: json['ask'],
    );
  }
}

class RekeningkuList extends StatefulWidget {
  @override
  _RekeningkuListState createState() => _RekeningkuListState();
}

class _RekeningkuListState extends State<RekeningkuList> {
  List<RekeningkuData> rekeningkuList = [];

  Future<List<RekeningkuData>> fetchRekeningku() async {
    final response = await http.get(
      Uri.parse('https://api.reku.id/v2/bidask'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => RekeningkuData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load rekeningku');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRekeningku().then((value) {
      setState(() {
        rekeningkuList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('RekeningKu'),
        ),
        body: Column(
          children: [
            Divider(), // Garis pertama
            Expanded(
              child: ListView.builder(
                itemCount: rekeningkuList.length,
                itemBuilder: (context, index) {
                  final rekeningku = rekeningkuList[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(rekeningku.accid),
                        subtitle: Text('Code: ${rekeningku.code}'),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Change Pct: ${rekeningku.changepct}'),
                            Text('Bid: ${rekeningku.bid}'),
                            Text('Ask: ${rekeningku.ask}'),
                          ],
                        ),
                      ),
                      Divider(), // Garis setiap item
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(RekeningkuList());
}
