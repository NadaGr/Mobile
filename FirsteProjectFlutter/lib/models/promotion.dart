class Promotion {
  int id;
  int idpromo;
  String nom;
  var datedebut, datefin;
  int pourcentage;
  String imageP;
  String nomService;
  String description;
  var prix;	
  var nbPoints;
  String image;

  Promotion(
      this.id,
      this.nom,
      this.datedebut,
      this.datefin,
      this.pourcentage,
      this.imageP,
      this.nomService,
      this.description,
      this.prix,
      this.nbPoints,
      this.image);
}
