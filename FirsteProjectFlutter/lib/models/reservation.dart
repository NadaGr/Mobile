import 'service.dart';
class Reservation{
    int id; 
    int serviceId;
    int clientId;
    String etat;
    var date;
    //Service service;
    Reservation(this.id,this.etat, this.date,this.serviceId, this.clientId);
}

