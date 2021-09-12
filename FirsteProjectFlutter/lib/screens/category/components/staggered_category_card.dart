// import 'package:flutter/material.dart';

// class CategoryCard extends StatelessWidget {
  

//   // This function is called each time the controller "ticks" a new frame.
//   // When it runs, all of the animation's values will have been
//   // updated to reflect the controller's current value.
//   Widget _buildAnimation(BuildContext context, Widget child) {
//     return Container(
//       //height: ,
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//           gradient: LinearGradient(
//              // colors: ,
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight),
//           borderRadius: BorderRadius.all(Radius.circular(10))),
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Align(
//               alignment: Alignment(-1, 0),
//               child: Text(
//                // categoryName,
//                '',
//                 style: TextStyle(
//                     fontSize: 22,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//               )),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.end,
// //        mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Container(
//                 padding: EdgeInsets.only(bottom: 16.0),
//                // height: itemHeight.value,
//                 child: Image.asset(
//                   ''
//                  // assetPath,
//                 ),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.all(Radius.circular(24))),
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: Text(
//                   'View more',
//                  // style: TextStyle(color: black, fontWeight: FontWeight.bold),
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       builder: _buildAnimation,
//       //animation: controller,
//     );
//   }
// }

// class StaggeredCardCard extends StatefulWidget {
//   final Color begin;
//   final Color end;
//   final String categoryName;
//   final String assetPath;

//   const StaggeredCardCard(
//       {Key key, this.begin, this.end, this.categoryName, this.assetPath})
//       : super(key: key);

//   @override
//   _StaggeredCardCardState createState() => _StaggeredCardCardState();
// }

// class _StaggeredCardCardState extends State<StaggeredCardCard>
//     with TickerProviderStateMixin {
//   AnimationController _controller;
//   bool isActive = false;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//         duration: const Duration(milliseconds: 300), vsync: this);
//   }

//   Future<void> _playAnimation() async {
//     try {
//       await _controller.forward().orCancel;
//     } on TickerCanceled {
//       // the animation got canceled, probably because we were disposed
//     }
//   }

//   Future<void> _reverseAnimation() async {
//     try {
//       await _controller.reverse().orCancel;
//     } on TickerCanceled {
//       // the animation got canceled, probably because we were disposed
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var timeDilation = 10.0; // 1.0 is normal animation speed.
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () {
//         if (isActive) {
//           isActive = !isActive;
//           _reverseAnimation();
//         } else {
//           isActive = !isActive;
//           _playAnimation();
//         }
//       },
//       child: CategoryCard(
      
//       ),
//     );
//   }
// }
