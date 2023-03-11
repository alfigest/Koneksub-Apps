import 'package:flutter/material.dart';

class ViewArticle extends StatefulWidget {
  final String imageLink;
  final String textJudul;
  final String textKeterangan;

  const ViewArticle(
      {Key? key,
      required this.imageLink,
      required this.textJudul,
      required this.textKeterangan})
      : super(key: key);

  @override
  State<ViewArticle> createState() => _ViewArticleState();
}

class _ViewArticleState extends State<ViewArticle> {
  @override
  Widget ImageView() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 350,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(widget.imageLink),
        ),
      ),
    );
  }

  Widget TextJudul() {
    return Padding(
        padding: EdgeInsets.all(35),
        child: Text(
          widget.textJudul,
          style: TextStyle(fontSize: 25),
        ));
  }

  Widget TextKeterangan() {
    return Padding(
        padding: EdgeInsets.all(35),
        child: Text(
          widget.textKeterangan,
          style: TextStyle(fontSize: 20),
        ));
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: SingleChildScrollView(
          child: Column(
            children: [ImageView(), TextJudul(), TextKeterangan()],
          ),
        )));
  }
}
