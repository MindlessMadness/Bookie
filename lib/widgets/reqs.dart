import 'package:bookie/providers/info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/overview.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  var _did = false;
  @override
  void didChangeDependencies() {
    if (!_did) {
      Provider.of<Info>(context).getUserRequests().then(
        (value) {
          _did = !_did;
        },
      );
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var requests = Provider.of<Info>(context).userRequests;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Maximum requests: 2\nYour requests: ${requests.length}\nRemaining: ${2 - requests.length}",
            style: TextStyle(fontSize: 20),
          ),
        ),
        ...requests.map(
          (e) {
            return Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Overview(book:e, bkey:e["key"]),
                    ));
                  },
                  title: Text(e['title']),
                  subtitle: Text(e['desc']),
                ),
                Divider()
              ],
            );
          },
        ).toList()
      ],
    );
  }
}
