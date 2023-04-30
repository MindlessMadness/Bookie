import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/info.dart';

class Overview extends StatefulWidget {
  const Overview({super.key, required this.book, this.bkey});
  final Map<String, dynamic> book;
  final bkey;

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  var _did = false;
  var requested = false;
  @override
  void didChangeDependencies() {
    if (!_did) {
      Provider.of<Info>(context, listen: false).getUserRequests().then((value) {
        _did = !_did;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var requests = Provider.of<Info>(context).userRequests;
    requested = requests.any(
      (element) => element["key"] == widget.bkey,
    );
    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.brown.shade900),
            title: Text(
              "Request A Book",
              style: TextStyle(fontSize: 28, fontFamily: "veteran"),
            )),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                widget.book['title'],
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Genre: ",
                style: TextStyle(fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "${widget.book['genre'].join(', ')}",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "description: \"${widget.book['desc']}\"",
                style: TextStyle(fontSize: 20),
              ),
            ),
            if (!requested)
              Padding(
                padding: const EdgeInsets.only(left: 300),
                child: ElevatedButton(
                  child: Text("Request"),
                  style: ButtonStyle(
                      alignment: Alignment.centerRight,
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          Colors.brown.shade900)),
                  onPressed: () async {
                    if (requests.length < 2) {
                      await Provider.of<Info>(context, listen: false)
                          .requestABook(
                              widget.book['desc'],
                              widget.book['genre'],
                              widget.book['title'],
                              widget.book['owner'],
                              widget.book['owned'],
                              widget.bkey);
                      setState(() {
                        _did = !_did;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Maximum Requests Reached")));
                    }
                  },
                ),
              ),
            if (requested)
              Padding(
                padding: const EdgeInsets.only(left: 300),
                child: ElevatedButton(
                  child: Text("Cancel"),
                  style: ButtonStyle(
                      alignment: Alignment.centerRight,
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          Colors.brown.shade900)),
                  onPressed: () async {
                    await Provider.of<Info>(context, listen: false)
                        .cancelRequest(
                            widget.book['desc'],
                            widget.book['genre'],
                            widget.book['title'],
                            widget.book['owner'],
                            widget.book['owned'],
                            widget.bkey);
                    setState(() { _did = !_did;});
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Maximum requests: 2\nYour requests: ${requests.length}\nRemaining: ${2 - requests.length}",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ));
  }
}
