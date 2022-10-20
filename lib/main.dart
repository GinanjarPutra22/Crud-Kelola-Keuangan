import 'package:crud_pencatatan_keuangan_052/models/transaksi_model.dart';
import 'package:crud_pencatatan_keuangan_052/screen/buat_screen.dart';
import 'package:crud_pencatatan_keuangan_052/screen/update_screen.dart';
import 'package:crud_pencatatan_keuangan_052/db/database_instance.dart';
import 'package:flutter/material.dart';
import 'package:crud_pencatatan_keuangan_052/screen/buat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.amber),
      title: "Kelola Keuangan",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseInstance? databaseInstance;

  Future _refresh() async {
    setState(() {});
  }

  @override
  void initState() {
    databaseInstance = DatabaseInstance();
    initDatabase();
    super.initState();
  }

  Future initDatabase() async {
    await databaseInstance!.database();
    setState(() {});
  }

  showAlertDialog(BuildContext contex, int idTransaksi) {
    Widget okButton = FlatButton(
      child: Text("Yakin"),
      onPressed: () {
        //delete disini
        databaseInstance!.hapus(idTransaksi);
        Navigator.of(contex, rootNavigator: true).pop();
        setState(() {});
      },
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text("Peringatan !"),
      content: Text("Anda yakin akan menghapus ?"),
      actions: [okButton],
    );

    showDialog(
        context: contex,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Color.fromARGB(255, 255, 187, 0),
          title: Text("Kelola Keuanganku"),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: databaseInstance!.totalPemasukan(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("-");
                      } else {
                        if (snapshot.hasData) {
                          return Text(
                            "Total Pemasukan = Rp. ${snapshot.data.toString()}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          );
                        } else {
                          return Text("");
                        }
                      }
                    }),
                SizedBox(
                  height: 15,
                ),
                FutureBuilder(
                    future: databaseInstance!.totalPengeluaran(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("-");
                      } else {
                        if (snapshot.hasData) {
                          return Text(
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              "Total Pengeluaran = Rp. ${snapshot.data.toString()}");
                        } else {
                          return Text("");
                        }
                      }
                    }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 1000,
                  padding: EdgeInsets.only(right: 20),
                  child: Divider(
                    height: 20,
                    thickness: 2,
                    indent: 20,
                    // endIndent: 0,
                    color: Colors.amber,
                  ),
                  alignment: Alignment.center,
                ),
                // SizedBox(
                //   height: 5,
                // ),
                FutureBuilder<List<TransaksiModel>>(
                    future: databaseInstance!.getAll(),
                    builder: (context, snapshot) {
                      print('HASIL : ' + snapshot.data.toString());
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      } else {
                        if (snapshot.hasData) {
                          return Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          snapshot.data![index].name!,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),

                                        subtitle: Text(
                                          snapshot.data![index].total!
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),

                                        leading: snapshot.data![index].type == 1
                                            ? Icon(
                                                Icons.download,
                                                color: Color.fromARGB(
                                                    255, 39, 215, 45),
                                              )
                                            : Icon(
                                                Icons.upload,
                                                color: Colors.red,
                                              ),

                                        // Trailing untuk Icon Update dan Hapus

                                        trailing: Wrap(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  update_screen(
                                                                    transaksiMmodel:
                                                                        snapshot
                                                                            .data![index],
                                                                  )))
                                                      .then((value) {
                                                    setState(() {});
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: Colors.grey,
                                                )),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  showAlertDialog(
                                                      context,
                                                      snapshot
                                                          .data![index].id!);
                                                },
                                                icon: Icon(Icons.delete,
                                                    color: Colors.red))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ));
                                }),
                          );
                        } else {
                          return Text("Tidak ada data");
                        }
                      }
                    })
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          // backgroundColor: Color.fromARGB(255, 255, 187, 0),
          child: const Icon(Icons.add),
          onPressed: (() {
            backgroundColor:
            // Color.fromARGB(255, 255, 187, 0);
            // print('object');
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => buat_screen()))
                .then((value) {
              setState(() {});
            });
          }),
        ));
  }
}
