import 'package:flutter/foundation.dart';

class ServiceItem {
  final id;
  final photo;
  final String nom, description;
  final price;
  final int quantity;

  ServiceItem(this.id, this.photo,this.nom,this.description,
       this.price,{this.quantity});
}

// class Cart with ChangeNotifier {
//   Map<String, ServiceItem> _items = {};

//   Map<String, ServiceItem> get items {
//     return {..._items};
//   }

//   int get itemCount {
//     return _items.length;
//   }

//   void addItem(String serviceid, String nom, double price,String photo) {
//     if (_items.containsKey(serviceid)) {
//       _items.update(
//           serviceid,
//           (existingCartItem) => ServiceItem(
//               id: DateTime.now().toString(),
//               nom: existingCartItem.nom,
//               quantity: existingCartItem.quantity + 1,
//               price: existingCartItem.price,
//               photo: existingCartItem.photo));
//     } else {
//       _items.putIfAbsent(
//           serviceid,
//           () => ServiceItem(
//                 nom: nom,
//                 id: DateTime.now().toString(),
//                 quantity: 1,
//                 price: price,
//                 photo: photo
//               ));
//     }
//     notifyListeners();
//   }

//   void removeItem(String id) {
//     _items.remove(id);
//     notifyListeners();
//   }

//   void removeSingleItem(String id) {
//     if (!_items.containsKey(id)) {
//       return;
//     }
//     if (_items[id].quantity > 1) {
//       _items.update(
//           id,
//           (existingCartItem) => ServiceItem(
//               id: DateTime.now().toString(),
//               nom: existingCartItem.nom,
//               quantity: existingCartItem.quantity - 1,
//               price: existingCartItem.price,
//               photo: existingCartItem.photo));
//     }
//     notifyListeners();
//   }



//   void clear() {
//     _items = {};
//     notifyListeners();
//   }
// }