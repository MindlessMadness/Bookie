import 'package:bookie/screens/Overview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/info.dart';

class Available extends StatefulWidget {
  const Available({super.key});

  @override
  State<Available> createState() => _AvailableState();
}

class _AvailableState extends State<Available> {
  var _did = false;
  @override
  void didChangeDependencies() {
    if (!_did) {
      Provider.of<Info>(context, listen: false).getAvailable().then(
        (value) {
          _did = !_did;
        },
      );
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var available = Provider.of<Info>(context).available;
    var keys = Provider.of<Info>(context).keys;
    var size = MediaQuery.of(context).size;
    var appbarHeight = AppBar().preferredSize.height;
    var bottomPadding = MediaQuery.of(context).padding.bottom;
    var availableHeight = size.height - appbarHeight - bottomPadding;

    return Container(
      width: size.width / 1.1,
      height: availableHeight,
      child: ListView.builder(
          itemCount: available.length,
          itemBuilder: (context, i) {
            return Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Overview(book:available[i], bkey:keys[i]),
                    ));
                  },
                  title: Text(available[i]['title']),
                  subtitle: Text(available[i]['desc']),
                ),
                Divider()
              ],
            );
          }),
    );
  }
}
