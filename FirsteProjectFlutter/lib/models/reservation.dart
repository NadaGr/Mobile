import 'package:json_annotation/json_annotation.dart';
import 'service.dart';
part 'reservation.g.dart';
@JsonSerializable(explicitToJson: true)
class Reservation{
    int id; 
    Service service;
    int clientId;
    String etat;
    var date;
    //Service service;
    Reservation({this.id,this.etat, this.date,this.service, this.clientId});
    factory Reservation.formJson(Map <dynamic,dynamic> data)=> _$ReservationFromJson(data);
    Map<dynamic,dynamic> toJson()=>_$ReservationToJson(this);
}

