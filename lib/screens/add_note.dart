import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/db/database_provider.dart';
import 'package:notes_app/models/note_model.dart';

import '../util/hero_dialog_route.dart';
import '../util/custom_tween.dart';
import '../util/my_colors.dart';

class AddNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return _AddNotePopupCard();
          }));
        },
        child: Hero(
          tag: _heroAddNote,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: MyColors.accentColor,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: const Icon(
              Icons.add,
              size: 56,
            ),
          ),
        ),
      ),
    );
  }
}

const String _heroAddNote = 'add-note-hero';

/// {@template add_Note_popup_card}
/// Popup card to add a new [note]. Should be used in conjuction with
/// [HeroDialogRoute] to achieve the popup effect.
///
/// Uses a [Hero] with tag [_heroAddNote].
/// {@endtemplate}
class _AddNotePopupCard extends StatefulWidget {
  /// {@macro add_Note_popup_card}

  @override
  __AddNotePopupCardState createState() => __AddNotePopupCardState();
}

class __AddNotePopupCardState extends State<_AddNotePopupCard> {
  String? _title;
  String? _body;
  DateTime? _date;

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  addNote(NoteModel note) {
    DatabaseProvider.db.addNewNote(note);
    print('Note added successfuly');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroAddNote,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: MyColors.accentColor,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      style: GoogleFonts.abelTextTheme().headline6!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                      decoration: InputDecoration(
                        hintText: 'New Note',
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.black,
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                    TextField(
                      controller: bodyController,
                      decoration: InputDecoration(
                        hintText: 'Write a note',
                        border: InputBorder.none,
                      ),
                      enableSuggestions: true,
                      keyboardType: TextInputType.multiline,
                      style: GoogleFonts.shadowsIntoLightTextTheme()
                          .bodyText1!
                          .copyWith(fontSize: 24),
                      cursorColor: Colors.black,
                      maxLines: 6,
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _title = titleController.text;
                          _body = bodyController.text;
                          _date = DateTime.now();
                        });
                        NoteModel note = NoteModel(
                            id: _date!.day,
                            title: _title!,
                            body: _body!,
                            creationDate: _date!);
                        addNote(note);
                        Navigator.pushNamedAndRemoveUntil(
                            context, "home", (route) => false);
                      },
                      child: Text(
                        'Add',
                        style: GoogleFonts.cabinCondensedTextTheme()
                            .bodyText1!
                            .copyWith(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
