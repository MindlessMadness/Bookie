import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/info.dart';

class YourBooks extends StatefulWidget {
  const YourBooks({super.key});

  @override
  State<YourBooks> createState() => _YourBooksState();
}

class _YourBooksState extends State<YourBooks> {
  var _did = false;
  @override
  void didChangeDependencies() {
    if (!_did) {
      Provider.of<Info>(context, listen: false).getUserBooks().then(
        (value) {
          _did = !_did;
        },
      );
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var YourBooks = Provider.of<Info>(context).userBooks;
    var size = MediaQuery.of(context).size;
    var appbarHeight = AppBar().preferredSize.height;
    var bottomPadding = MediaQuery.of(context).padding.bottom;
    var availableHeight = size.height - appbarHeight - bottomPadding;

    return Container(
      width: size.width / 1.1,
      height: availableHeight*3/4,
      child: ListView.builder(
          itemCount: YourBooks.length,
          itemBuilder: (context, i) {
            return Column(
              children: [
                ListTile(
                  title: Text(YourBooks[i]['title']), 
                  subtitle: Text(YourBooks[i]['desc']),
                ),
                Divider()
              ],
            );
          }),
    );
  }
}
