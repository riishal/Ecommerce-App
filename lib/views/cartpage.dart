import 'package:ecommerce_app/controller/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_selection/number_selection.dart';
import 'package:provider/provider.dart';

class Cartpage extends StatelessWidget {
  const Cartpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, getdata, child) {
      getdata.fetchQuestion();
      getdata.loadSF();
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.black,
          title: const Text('My cart',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: getdata.CartSample.length,
                  padding: const EdgeInsets.all(15),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        height: 125,
                        width: 250,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromARGB(255, 223, 222, 222),
                                width: 1),
                            color: Colors.white,
                            boxShadow: const [BoxShadow(blurRadius: 10)],
                            borderRadius: BorderRadius.circular(30)),
                        child: Stack(children: [
                          Positioned(
                            left: 15,
                            top: 10,
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(getdata
                                          .data
                                          .products[getdata.CartSample[index]]
                                          .thumbnail),
                                      fit: BoxFit.fill),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                          Positioned(
                              left: 130,
                              top: 10,
                              child: SizedBox(
                                width: 150,
                                child: Text(
                                    getdata
                                        .data
                                        .products[getdata.CartSample[index]]
                                        .title,
                                    style: GoogleFonts.aBeeZee(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              )),
                          Positioned(
                              left: 136,
                              top: 50,
                              child: Text(
                                '\$${getdata.data.products[getdata.CartSample[index]].price}',
                                style: const TextStyle(fontSize: 18),
                              )),
                          Positioned(
                              bottom: 5,
                              left: 130,
                              child: IconButton(
                                  onPressed: () {
                                    getdata.removeitem(index);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                    size: 30,
                                  ))),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: SizedBox(
                              height: 100,
                              child: NumberSelection(
                                theme: NumberSelectionTheme(
                                    draggableCircleColor: Colors.white,
                                    iconsColor: Colors.black,
                                    numberColor: Colors.black,
                                    backgroundColor: const Color.fromARGB(
                                        255, 150, 153, 155)),
                                initialValue: 1,
                                minValue: 0,
                                maxValue: 10,
                                direction: Axis.vertical,
                                withSpring: true,
                                onChanged: (int initialValue) {
                                  if (initialValue == 0) {
                                    getdata.removeitem(index);
                                  }
                                  true;
                                },
                              ),
                            ),
                          )
                        ]),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        )),
      );
    });
  }
}
