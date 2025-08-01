import 'package:flutter/material.dart';

class Orderscreen extends StatelessWidget {
  const Orderscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length:2,
      child:Scaffold(
      appBar:AppBar(
        title:Text('OrderScreen',style:TextStyle(fontSize:22,fontWeight:FontWeight.w700),),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        bottom:
        TabBar(
          labelColor:Colors.white,
          labelStyle:TextStyle(fontSize:24,),
          unselectedLabelStyle: TextStyle(fontSize: 16,),
          indicatorColor:Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          tabs:[
            Tab(icon:Icon(Icons.local_gas_station),text:('Fuel'),),
            Tab(icon:Icon(Icons.handyman),text:('Parts'),),
          ],
        ),
      ),
      body:
      TabBarView(
        children:[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Icon(Icons.local_gas_station),
              SizedBox(height:12),
              Text('No fuel is Ordered.'),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Icon(Icons.handyman),
            SizedBox(height: 12,),
            Text('No item is Ordered.'),
          ],),
        ],
      ),
    ),
    );
  }
}