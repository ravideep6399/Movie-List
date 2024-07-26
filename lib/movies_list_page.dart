import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movieslist/auth%20repo/user_services.dart';
import 'package:movieslist/movies.dart';
import 'package:provider/provider.dart';

class MoviesListPage extends StatefulWidget {
  const MoviesListPage({super.key});

  @override
  State<MoviesListPage> createState() => _MoviesListPageState();
}

class _MoviesListPageState extends State<MoviesListPage> {
  final formkey = GlobalKey<FormState>();
  Box? _moviesbox;
  final TextEditingController _moviesNameController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Hive.openBox("movies_box").then((box) {
      setState(() {
        _moviesbox = box;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<UserViewModel>(context);
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 205, 205, 205),
        appBar: AppBar(
          title: const Text("Movies List"),
          centerTitle: true,
          titleTextStyle: const TextStyle(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.w400),
          actions: [
            IconButton(
                onPressed: () {
                  auth.signOut(context);
                },
                icon: const Icon(
                  Icons.logout_outlined,
                  color: Colors.black,
                ))
          ],
        ),
        body: _buildUi(),
        floatingActionButton: FloatingActionButton(
          onPressed: displayTextInputDialog,
          child: const Icon(Icons.add),
        ));
  }

  Widget _buildUi() {
    if (_moviesbox == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ValueListenableBuilder(
          valueListenable: _moviesbox!.listenable(),
          builder: (context, box, widget) {
            return SizedBox.expand(
              child: ListView.builder(
                  itemCount: box.values.length,
                  itemBuilder: (context, index) {
                    final movie = box.getAt(index);
                    final imageBytes = base64Decode(movie.imageUrl);
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 5),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: SizedBox(
                        height: 600,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: MemoryImage(imageBytes),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(10)),
                                height: 500,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, right: 4),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 4.0),
                                          child: Text(
                                            movie.name,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          "Director: ${movie.director}",
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      box.delete(index);
                                    },
                                    icon: const Icon(
                                      Icons.delete_rounded,
                                      color: Colors.black,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          });
    }
  }

  Future<void> displayTextInputDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          File? imageU;
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              "Add a Movie",
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              Form(
                  key: formkey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        cursorColor: Colors.black,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a Movie name';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.black),
                        controller: _moviesNameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Movie name...",
                            hintStyle:
                                TextStyle(color: Color.fromARGB(79, 0, 0, 0))),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                          cursorColor: Colors.black,
                          style: const TextStyle(color: Colors.black),
                          controller: _directorController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a Director name';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Director's name...",
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(79, 0, 0, 0)))),
                      const SizedBox(
                        height: 15,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                        onPressed: () async {
                          ImagePicker imagePicker = ImagePicker();
                          XFile? image = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              imageU = File(image.path);
                            });
                          }
                        },
                        color: Colors.black,
                        textColor: Colors.white,
                        child: const Text("Add Image"),
                      )
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () async {
                  if (imageU == null) {
                    Fluttertoast.showToast(
                        msg: "Please upload an image",
                        backgroundColor: Colors.red,
                        textColor: Colors.white);
                    return;
                  }
                  if (formkey.currentState!.validate()) {
                    final bytes = await imageU!.readAsBytes();
                    final imageBase64 = base64Encode(bytes);
                    final name = _moviesNameController.text;
                    final director = _directorController.text;
                    final Movies model = Movies(
                        imageUrl: imageBase64, name: name, director: director);
                    _moviesbox?.add(model);
                    Navigator.pop(context);
                    _moviesNameController.clear();
                    _directorController.clear();
                  }
                },
                color: Colors.black,
                textColor: Colors.white,
                child: const Text("ADD"),
              )
            ],
          );
        });
  }
}
