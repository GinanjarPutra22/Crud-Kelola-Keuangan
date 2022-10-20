import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:crud_pencatatan_keuangan_052/db/database_instance.dart';

class buat_screen extends StatefulWidget {
  const buat_screen({Key? key}) : super(key: key);

  @override
  State<buat_screen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<buat_screen> {
  DatabaseInstance databaseInstance = DatabaseInstance();
  TextEditingController nameController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  int _value = 1;

  @override
  void initState() {
    // TODO: implement initState
    databaseInstance.database();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Catatan"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nama"),
                TextField(
                  controller: nameController,
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Tipe Transaksi"),
                ListTile(
                  title: Text("Pemasukan"),
                  leading: Radio(
                      groupValue: _value,
                      value: 1,
                      onChanged: (value) {
                        setState(() {
                          _value = int.parse(value.toString());
                        });
                      }),
                ),
                ListTile(
                  title: Text("Pengeluaran"),
                  leading: Radio(
                      groupValue: _value,
                      value: 2,
                      onChanged: (value) {
                        setState(() {
                          _value = int.parse(value.toString());
                        });
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Total"),
                TextField(
                  controller: totalController,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      onPressed: () async {
                        int idInsert = await databaseInstance.insert({
                          'name': nameController.text,
                          'type': _value,
                          'total': totalController.text,
                          'created_at': DateTime.now().toString(),
                          'updated_at': DateTime.now().toString(),
                        });
                        print("sudah masuk : " + idInsert.toString());
                        Navigator.pop(context);
                      },
                      child: Text("Simpan")),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
