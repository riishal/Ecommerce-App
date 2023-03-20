import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_app/controller/provider.dart';
import 'package:ecommerce_app/views/cart_page/cartpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../Homepage/Homepage.dart';

class Itempage extends StatelessWidget {
  
  const Itempage({
    super.key,
    required this.index,
  });
  final int index;
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, getdata, child) {
      return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(elevation: 0, backgroundColor: Colors.black, actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Cartpage(),
                      ));
                },
                icon: const Icon(Icons.shopping_cart_checkout))
          ]),
          body: Stack(
            children: [
              Positioned(
                top: 15,
                width: 350,
                child: CarouselSlider(
                  items: <Widget>[
                    for (var i = 0;
                        i < getdata.data.products[buttonindex].images.length;
                        i++)
                      Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            image: DecorationImage(
                                image: NetworkImage(getdata
                                    .data.products[buttonindex].images[i]),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(20)),
                      )
                  ],
                  options: CarouselOptions(
                    aspectRatio: 3 / 4,
                    height: 190,
                    viewportFraction: 0.9,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 1000),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
              Positioned(
                top: 230,
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 218, 217, 224),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50))),
                    child: Padding(
                      padding: const EdgeInsets.all(35.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getdata.data.products[buttonindex].title,
                            style: const TextStyle(
                                fontSize: 27, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              RatingBar.builder(
                                initialRating:
                                    getdata.data.products[buttonindex].rating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 20,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                },
                              ),
                              Text(
                                  '(${getdata.data.products[buttonindex].rating})',
                                  style: const TextStyle(color: Colors.blue)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '\$${getdata.data.products[index].price}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Row(
                            children: [
                              const Text(
                                'Discount',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 17),
                              ),
                              const Icon(
                                Icons.discount,
                                color: Colors.red,
                                size: 20,
                              ),
                              Text(
                                '${getdata.data.products[buttonindex].discountPercentage}%',
                                style: const TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 19,
                          ),
                          const Divider(
                            color: Colors.black,
                            indent: 1,
                            thickness: 1,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          const Text(
                            'Description',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            getdata.data.products[buttonindex].description,
                            style: const TextStyle(
                                fontSize: 15, fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )),
              ),
              Positioned(
                  bottom: 10,
                  left: 35,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 60,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey),
                            onPressed: () {
                              buttonindex = index;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    
                                    builder: (context) => const Cartpage(),
                                  ));

                              getdata.saveSF();
                              var existingIndex = getdata.CartSample.indexWhere(
                                  (id) =>
                                      id ==
                                      getdata.data.products[index].id - 1);
                              
                              if (existingIndex != -1) {
                                return;
                              } else {
                                getdata.CartSample.add(
                                    getdata.data.products[index].id - 1);
                                getdata.saveSF();
                              }
                            },
                            child: const Text('  Add to Cart   ')),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      SizedBox(
                        height: 60,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber),
                            onPressed: () {},
                            child: const Text(
                              '    Buy Now     ',
                              style: TextStyle(color: Colors.black),
                            )),
                      ),
                    ],
                  ))
            ],
          ));
    });
  }
}
