import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/db/database_provider.dart';
import 'package:notes_app/screens/add_note.dart';
import 'package:notes_app/util/my_colors.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getNotes() async {
    final notes = await DatabaseProvider.db.getNotes();
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 10.0,
        centerTitle: true,
        title: 'Notes'.text.xl4.bold.white.make().shimmer(
              primaryColor: Vx.amber900,
              secondaryColor: Colors.white,
            ),
      ),
      drawer: Drawer(),
      body: Container(
        child: FutureBuilder(
          builder: (context, noteData) {
            switch (noteData.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case ConnectionState.done:
                {
                  if (noteData.data == Null || !noteData.hasData) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "You don't have any notes yet, create one!",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    var note = noteData.data as List<dynamic>;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: note.length,
                        itemBuilder: (context, index) {
                          String? title = note[index]['title'];
                          String? body = note[index]['body'];
                          String? creationDate = note[index]['creationDate'];
                          int? id = note[index]['id'];

                          return Card(
                            elevation: 12,
                            color: Colors.lime.shade200,
                            child: ListTile(
                              trailing: Icon(Icons.delete_forever),
                              title: Text(title!,
                                  style: GoogleFonts.abelTextTheme()
                                      .headline6!
                                      .copyWith(
                                          fontSize: 24,
                                          color: Colors.grey.shade800,
                                          fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                body!,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
              default:
                return Center();
            }
          },
          future: getNotes(),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              MyColors.primaryColor1,
              MyColors.primaryColor2,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      floatingActionButton: AddNote(),
    );
  }
}
