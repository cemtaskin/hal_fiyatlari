class HalFiyatListesi {
  String? ortalamaUcret;
  String? malAdi;
  String? birim;
  String? asgariUcret;
  String? azamiUcret;
  String? malId;
  String? tarih;
  String? halTuru;
  String? malTipId;
  String? malTipAdi;
  String? gorsel;

  HalFiyatListesi(
      {this.ortalamaUcret,
      this.malAdi,
      this.birim,
      this.asgariUcret,
      this.azamiUcret,
      this.malId,
      this.tarih,
      this.halTuru,
      this.malTipId,
      this.malTipAdi,
      this.gorsel});

  HalFiyatListesi.fromJson(Map<String, dynamic> json) {
    ortalamaUcret = json['OrtalamaUcret'].toString();
    malAdi = json['MalAdi'].toString();
    birim = json['Birim'];
    asgariUcret = json['AsgariUcret'].toString();
    azamiUcret = json['AzamiUcret'].toString();
    malId = json['MalId'].toString();
    tarih = json['tarih'].toString();
    halTuru = json['HalTuru'].toString();
    malTipId = json['MalTipId'].toString();
    malTipAdi = json['MalTipAdi'].toString();
    gorsel = json['Gorsel'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrtalamaUcret'] = this.ortalamaUcret;
    data['MalAdi'] = this.malAdi;
    data['Birim'] = this.birim;
    data['AsgariUcret'] = this.asgariUcret;
    data['AzamiUcret'] = this.azamiUcret;
    data['MalId'] = this.malId;
    data['tarih'] = this.tarih;
    data['HalTuru'] = this.halTuru;
    data['MalTipId'] = this.malTipId;
    data['MalTipAdi'] = this.malTipAdi;
    data['Gorsel'] = this.gorsel;
    return data;
  }
}
