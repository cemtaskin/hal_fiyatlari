import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hal_fiyatlari/main.dart';
import 'package:hal_fiyatlari/model/hal_fiyat_listesi.dart';
import 'package:hal_fiyatlari/model/hal_fiyatlari.dart';
import 'package:http/http.dart' as http;

class PriceListScreen extends StatefulWidget {
  const PriceListScreen({super.key});

  @override
  State<PriceListScreen> createState() => _PriceListScreenState();
}

class _PriceListScreenState extends State<PriceListScreen> {
  bool _isWorking = true;
  String _selectedDate = '';

  var url =
      Uri.https('openapi.izmir.bel.tr', 'api/ibb/halfiyatlari/sebzemeyve/');

  Future<HalFiyatlari> getFromWebService() async {
    var url = Uri.https('openapi.izmir.bel.tr',
        'api/ibb/halfiyatlari/sebzemeyve/' + _selectedDate);

    var value = await http.get(url);
    return HalFiyatlari.fromJson(jsonDecode(value.body));
  }

  HalFiyatlari halFiyatlari = HalFiyatlari();
  List<HalFiyatListesi> halFiyatListesi =
      List.generate(0, (index) => HalFiyatListesi());
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    DateTime today = DateTime.now();
    _selectedDate = "${today.year}-${today.month}-${today.day}";

    getFromWebService().then((value) {
      setState(() {
        _isWorking = false;
        halFiyatlari = value;
        halFiyatListesi = value!.halFiyatListesi!;
      });
    });
  }

  void search(String filter) {
    halFiyatListesi = halFiyatlari!.halFiyatListesi!
        .where((p) => p.malAdi!.toUpperCase().contains(filter.toUpperCase()))
        .toList();

    setState(() {});
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: DateTimePicker(
              initialValue: _selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              dateLabelText: 'Date',
              onChanged: (val) {
                Navigator.of(context).pop();
                _selectedDate = val;
                setState(() {
                  _isWorking = true;
                });
                getFromWebService().then((value) {
                  setState(() {
                    _isWorking = false;
                    halFiyatlari = value;
                  });
                });
              },
              validator: (val) {
                search(val!);
              },
              onSaved: (val) => print(val),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hal Fiyat Listesi'),
          actions: [
            InkWell(
              child: Icon(Icons.date_range),
              onTap: () async {
                await _showMyDialog();
              },
            )
          ],
        ),
        body: _isWorking
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'ARAMAK ??STED??????N??Z MEYVE/SEBZE',
                      ),
                      onSubmitted: (value) {
                        search(value);
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: halFiyatListesi!.length,
                        itemBuilder: (BuildContext context, int index) {
                          HalFiyatListesi fiyatListesi =
                              halFiyatListesi![index];
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Card(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        fiyatListesi!.malAdi!,
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      Text(
                                        fiyatListesi!.ortalamaUcret!,
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                    ],
                                  ),
                                  Image.network(
                                    'https://eislem.izmir.bel.tr/YuklenenDosyalar/HalGorselleri/' +
                                        fiyatListesi!.gorsel!,
                                    width: 120,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
      ),
    );
  }
}
