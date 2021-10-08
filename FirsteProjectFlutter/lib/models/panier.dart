class Panier{
  int id;
  String nomService;
  String description;
  var prix;
  var nbPoints;
  int categorieId;
  String image;
  int serviceId; 
  int clientId;
  var dateTime;
  Panier(
  this.id, 
  this.nomService, 
  this.description, 
  this.prix, 
  this.nbPoints, 
  this.categorieId,
  this.image, 
  this.serviceId, 
  this.clientId,
  this.dateTime
  );
}