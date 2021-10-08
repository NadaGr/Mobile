import 'package:FirsteProjectFlutter/models/service.dart';
import 'service.dart';
import 'package:json_annotation/json_annotation.dart';
part 'promotion.g.dart';
@JsonSerializable(explicitToJson: true)
class Promotion {
  int id;
  Service service;
  int idpromo;
  String nom, datedebut, datefin;
  int pourcentage;
  String imageP;

  Promotion(
      {this.id,
      this.service,
      this.nom,
      this.datedebut,
      this.datefin,
      this.pourcentage,
      this.imageP});
    factory Promotion.formJson(Map <dynamic,dynamic> data)=> _$PromotionFromJson(data);
    Map<dynamic,dynamic> toJson()=>_$PromotionToJson(this);
}
