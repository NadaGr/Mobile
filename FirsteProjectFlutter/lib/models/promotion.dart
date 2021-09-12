import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Promotion {
  int id;
  String nomservice, description;
  int prix;
  double nbpoints;
  int categorieid;
  String image;
  int idpromo;
  String nom, datedebut, datefin;
  int pourcentage;
  String imageP;

  Promotion(
      this.id,
      this.nomservice,
      this.description,
      this.prix,
      this.nbpoints,
      this.categorieid,
      this.image,
      this.idpromo,
      this.nom,
      this.datedebut,
      this.datefin,
      this.pourcentage,
      this.imageP);
}
// info[i]['id'],
// info[i]['nom_service'],
// info[i]['description'],
// info[i]['prix'],
// info[i]['nb_points'],
// info[i]['categorie_id'],
// info[i]['image'],
// info[i]['promotions']['id'],
//info[i]['promotions']['nom'], 
//info[i]['promotions']['date_debut'],
// info[i]['promotions']['date_fin'],
//        info[i]['promotions']['pourcentage'],info[i]['promotions']['image']