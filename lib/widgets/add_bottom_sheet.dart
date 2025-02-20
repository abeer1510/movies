
import 'package:flutter/material.dart';


class AddBottomSheet extends StatefulWidget {
  int avaterId ;
   AddBottomSheet({required this.avaterId,super.key});

  @override
  State<AddBottomSheet> createState() => _AddBottomSheetState();
}

class _AddBottomSheetState extends State<AddBottomSheet> {
  List<String> imgList=[
    "assets/images/gamer0.png",
    "assets/images/gamer1.png",
    "assets/images/gamer2.png",
    "assets/images/gamer3.png",
    "assets/images/gamer4.png",
    "assets/images/gamer5.png",
    "assets/images/gamer6.png",
    "assets/images/gamer7.png",
    "assets/images/gamer8.png",
  ];
  int currentIndex = 0;


  @override
  Widget build(BuildContext context) {

     return Container(
       height: 350,
      decoration: BoxDecoration(
        color: Color(0xFF282A28),
        borderRadius: BorderRadius.circular(40)
      ),
      child:
      Padding(
        padding:  EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Expanded(
              child: _buildGridView(imgList),
            ),

          ],


    )));
  }

   Widget _buildGridView(List<String> imgLis) {
     return GridView.builder(
       padding: EdgeInsets.all(8),
       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
         crossAxisCount: 3,
         childAspectRatio: 1,
         crossAxisSpacing: 8,
         mainAxisSpacing: 8,
       ),
       itemCount: imgLis.length,
       itemBuilder: (context, index) {
         bool isSelected = index == currentIndex;
         return InkWell(
           onTap:(){
             setState(() {
               currentIndex = index; // تحديث العنصر المحدد
             });
             Navigator.pop(context,index);
           },
           child: Container(
             width: 80,height: 80,
             decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(20),
                 color: isSelected?Color(0xFFF6BD00).withOpacity(.56):Colors.transparent,
                 border: Border.all(width: 1,color: Theme.of(context).primaryColor)
             ),
             child: ClipRRect(
                 borderRadius: BorderRadius.circular(20),
                 child: Image.asset(imgLis[index],
                 )),
           ),
         )
         ;
       },
     );
   }

}