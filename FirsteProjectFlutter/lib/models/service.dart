import 'package:json_annotation/json_annotation.dart';
part 'service.g.dart';
@JsonSerializable()
class Service{
  int id;
  String nomService;
  String description;
  var prix;	
  var nbPoints;
  int categorieId;
  String image;
  Service(
   { this.id,
  this.nomService,
  this.description,
  this.prix,
  this.nbPoints,
  this.categorieId,
  this.image,
  });
  factory Service.formJson(Map <dynamic,dynamic> data)=> _$ServiceFromJson(data);
  Map<dynamic,dynamic> toJson()=>_$ServiceToJson(this);
}