import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:Todoo/Boxes.dart';

import 'package:Todoo/Fun/getTextFormField.dart';
import 'package:Todoo/Model/userModel.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Anotacoes extends StatefulWidget {
  const Anotacoes({Key? key}) : super(key: key);

  @override
  State<Anotacoes> createState() => _AnotacoesState();
}

class _AnotacoesState extends State<Anotacoes> {
  final _formKey = GlobalKey<FormState>();

  final conId = TextEditingController();
  final conDesc = TextEditingController();

  @override
  void dispose() {
    Hive.close(); // Closing All Boxes

    super.dispose();
  }

  Future<void> addUser(String uId, String uDesc) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = UserModel()
        ..user_id = uId
        ..user_Desc = uDesc;

      final box = Boxes.getUsers();

      box.add(user).then((value) => clearPage());
    }
  }

  Future<void> editUser(UserModel userModel) async {
    conId.text = userModel.user_id;
    conDesc.text = userModel.user_Desc;

    deleteUser(userModel);
  }

  Future<void> deleteUser(UserModel userModel) async {
    userModel.delete();
  }

  clearPage() {
    conId.text = '';
    conDesc.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          title: Center(
            child: Text('ANOTAÇÕES'),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                genTextFormField(
                    controller: conId,
                    hintName: "Adicione",
                    iconData: Icons.note),
                SizedBox(height: 20),
                genTextFormField(
                    controller: conDesc,
                    hintName: "Descrição",
                    iconData: Icons.description),
                SizedBox(height: 20),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          onPressed: () => addUser(conId.text, conDesc.text),
                          child: Text("Adicionar"),
                          color: Colors.black26,
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Expanded(
                        child: FlatButton(
                          onPressed: clearPage,
                          child: Text("Limpar"),
                          color: Colors.black26,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                    height: 500,
                    child: ValueListenableBuilder(
                      valueListenable: Boxes.getUsers().listenable(),
                      builder: (BuildContext context, Box box, Widget? child) {
                        final users = box.values.toList().cast<UserModel>();

                        return genContent(users);
                      },
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget genContent(List<UserModel> user) {
    if (user.isEmpty) {
      return Center(
        child: Text(
          "Não possui anotações",
          style: TextStyle(fontSize: 20),
        ),
      );
    } else {
      return ListView.builder(
          itemCount: user.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.white,
              child: ExpansionTile(
                title: Text(
                  "${user[index].user_id})",
                  maxLines: 2,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text(user[index].user_Desc),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        onPressed: () => editUser(user[index]),
                        icon: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                        label: Text(
                          "Editar",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => deleteUser(user[index]),
                        icon: Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                        label: Text(
                          "Deletar",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      StarButton(
                        isStarred: null,
                        valueChanged: (_isStarred) {
                          print(
                            'Completa $_isStarred)',
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          });
    }
  }
}
