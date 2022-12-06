import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShopDetailsScreen extends StatefulWidget {
  final String id;

  const ShopDetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  var _itemTitle = '';
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('shop')
          .doc(widget.id)
          .snapshots(),
      builder: (ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(snapshot.data!['name']),
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('shop')
                .doc(widget.id)
                .collection('items')
                .orderBy('checked', descending: false)
                .snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final documents = snapshot.data?.docs;
              return ListView.builder(
                itemCount: documents?.length,
                itemBuilder: (ctx, index) => Container(
                  child: Card(
                    child: Dismissible(
                      key: ValueKey(documents![index].id),
                      onDismissed: (direction) {
                        FirebaseFirestore.instance
                            .collection('shop')
                            .doc(widget.id)
                            .collection('items')
                            .doc(documents[index].id)
                            .delete()
                            .then((value) => FirebaseFirestore.instance
                                    .collection('shop')
                                    .doc(widget.id)
                                    .collection('items')
                                    .get()
                                    .then((value) {
                                  var checked = 0;
                                  value.docs.forEach((element) {
                                    if (element['checked']) {
                                      checked++;
                                    }
                                  });
                                  FirebaseFirestore.instance
                                      .collection('shop')
                                      .doc(widget.id)
                                      .update({
                                    'progress': checked / value.docs.length
                                  });
                                }));
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete),
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        title: Text(documents[index].id),
                        trailing: Checkbox(
                          value: documents[index]['checked'],
                          onChanged: (val) {
                            FirebaseFirestore.instance
                                .collection('shop')
                                .doc(widget.id)
                                .collection('items')
                                .doc(documents[index].id)
                                .update({'checked': val}).then((value) =>
                                    FirebaseFirestore.instance
                                        .collection('shop')
                                        .doc(widget.id)
                                        .collection('items')
                                        .get()
                                        .then((value) {
                                      var checked = 0;
                                      value.docs.forEach((element) {
                                        if (element['checked']) {
                                          checked++;
                                        }
                                      });
                                      FirebaseFirestore.instance
                                          .collection('shop')
                                          .doc(widget.id)
                                          .update({
                                        'progress': checked / value.docs.length
                                      });
                                    }));
                          },
                        ),
                        onTap: () {
                          _itemTitle = documents[index].id;
                          showDialog(
                            //allow user to edit the item and display current item name
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Edit'),
                                content: TextField(
                                  onChanged: (value) {
                                    _itemTitle = value;
                                  },
                                  controller:
                                      TextEditingController(text: _itemTitle),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('shop')
                                          .doc(widget.id)
                                          .collection('items')
                                          .doc(documents[index].id)
                                          .delete()
                                          .then((value) => FirebaseFirestore
                                                  .instance
                                                  .collection('shop')
                                                  .doc(widget.id)
                                                  .collection('items')
                                                  .doc(_itemTitle)
                                                  .set({
                                                'checked': false,
                                              }).then((value) =>
                                                      FirebaseFirestore.instance
                                                          .collection('shop')
                                                          .doc(widget.id)
                                                          .collection('items')
                                                          .get()
                                                          .then((value) {
                                                        var checked = 0;
                                                        value.docs
                                                            .forEach((element) {
                                                          if (element[
                                                              'checked']) {
                                                            checked++;
                                                          }
                                                        });
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('shop')
                                                            .doc(widget.id)
                                                            .update({
                                                          'progress': checked /
                                                              value.docs.length
                                                        });
                                                      })));
                                      Navigator.pop(context);
                                    },
                                    child: Text('Edit'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Add"),
                    content: TextField(
                      onChanged: (value) {
                        _itemTitle = value;
                      },
                      controller: TextEditingController(text: _itemTitle),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel")),
                      TextButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('shop')
                                .doc(widget.id)
                                .collection('items')
                                .doc(_itemTitle)
                                .set({'checked': false}).then((value) =>
                                    FirebaseFirestore.instance
                                        .collection('shop')
                                        .doc(widget.id)
                                        .collection('items')
                                        .get()
                                        .then((value) {
                                      var checked = 0;
                                      value.docs.forEach((element) {
                                        if (element['checked']) {
                                          checked++;
                                        }
                                      });
                                      FirebaseFirestore.instance
                                          .collection('shop')
                                          .doc(widget.id)
                                          .update({
                                        'progress': checked / value.docs.length
                                      });
                                    }));
                          },
                          child: Text("Add")),
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
