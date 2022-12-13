import 'dart:convert';

import 'package:flutter/material.dart';
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

  HalFiyatlari halFiyatlari = HalFiyatlari();
  @override
  void initState() {
    super.initState();

    var url = Uri.https(
        'openapi.izmir.bel.tr', 'api/ibb/halfiyatlari/sebzemeyve/2022-01-15');
    http.get(url).then((value) {
      halFiyatlari = HalFiyatlari.fromJson(jsonDecode(value.body));
      setState(() {
        _isWorking = false;
      });
    });
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
              onTap: () {
                print('clicked');
              },
            )
          ],
        ),
        body: _isWorking
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: halFiyatlari.halFiyatListesi!.length,
                itemBuilder: (BuildContext context, int index) {
                  HalFiyatListesi halFiyatListesi =
                      halFiyatlari.halFiyatListesi![index];
                  return ListTile(
                    leading: const Icon(Icons.list),
                    title: Text(halFiyatListesi!.malAdi!),
                    subtitle: Text(halFiyatListesi!.ortalamaUcret! + "TL"),
                  );
                }),
      ),
    );
  }
}
