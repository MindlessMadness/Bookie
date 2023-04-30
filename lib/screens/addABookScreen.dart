import 'package:bookie/providers/info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddABook extends StatefulWidget {
  const AddABook({super.key});
  static String route = "addabook";
  @override
  State<AddABook> createState() => _AddABookState();
}

class _AddABookState extends State<AddABook> {
  var _genre = [];
  var _titleController = TextEditingController();
  var _descController = TextEditingController();
  var _genreController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var padding = MediaQuery.of(context).padding;
    var height = size.height - padding.top - padding.bottom;
    var addBooksToAvailable = Provider.of<Info>(context).addBookToAvailable;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.brown.shade900),
          title: Text(
            "Add a Book To Available Books",
            style: TextStyle(fontFamily: "Veteran", fontSize: 20),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: TextField(
                  controller: _titleController,
                  cursorColor: Colors.brown.shade100,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      label: Text(
                        "Enter Book Title",
                        style: TextStyle(color: Colors.brown.shade900),
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.brown.shade900)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.brown.shade900))),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: TextField(
                  controller: _descController,
                  minLines: 5,
                  maxLines: 5,
                  cursorColor: Colors.brown.shade100,
                  decoration: InputDecoration(
                      label: Text(
                        "Describe Book Status and Damages",
                        style: TextStyle(color: Colors.brown.shade900),
                        textAlign: TextAlign.start,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.brown.shade900)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.brown.shade900))),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    children: [
                      Text("Genre:"),
                      ..._genre.map((e) {
                        return ListTile(
                          title: Text(e),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _genre = _genre
                                    .where((element) => element != e)
                                    .toList();
                              });
                            },
                          ),
                        );
                      })
                    ],
                  )),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: _genreController,
                  onSubmitted: (value) {
                    if (_genreController.text != "") {
                      setState(() {
                        _genre.add(_genreController.text);
                        _genreController.text = "";
                      });
                    }
                  },
                  cursorColor: Colors.brown.shade100,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      label: Text(
                        "Add A Genre",
                        style: TextStyle(color: Colors.brown.shade900),
                        textAlign: TextAlign.start,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.brown.shade900)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.brown.shade900))),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        alignment: Alignment.centerRight,
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Colors.brown.shade900),
                        foregroundColor:
                            MaterialStatePropertyAll<Color>(Colors.white)),
                    child: Text("Done"),
                    onPressed: () {
                      if (_titleController.text != "" &&
                          _genre.length != 0 &&
                          _descController.text != "") {
                        addBooksToAvailable(_titleController.text, _genre,
                            _descController.text);
                        Navigator.of(context).pop();
                      }
                    },
                  )),
            ],
          ),
        ));
  }
}
