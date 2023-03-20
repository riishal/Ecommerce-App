// ignore_for_file: file_names

import 'package:ecommerce_app/controller/provider.dart';
import 'package:ecommerce_app/views/Homepage/drawerpage.dart';
import 'package:ecommerce_app/views/item_page/itempage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

int buttonindex = 0;

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  // ignore: recursive_getters
  get index => index;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, getdata, child) {
      getdata.fetchQuestion();
      if (getdata.status == Providerstatus.COMPLETED) {
        return Scaffold(
            drawer: const DrawerPage(),
            backgroundColor: const Color.fromARGB(255, 1, 5, 3),
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 1, 5, 3),
              elevation: 0,
              leading: Builder(
                builder: (context) {
                  return IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(Icons.menu));
                },
              ),
              actions: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                      FirebaseAuth.instance.currentUser!.photoURL ?? ""),
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: SizedBox(
                        height: 40,
                        width: 300,
                        child: TextField(
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(6)),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              hintText: 'What are you looking for ?',
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 129, 125, 125))),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      child: SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(6),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: .7,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 10),
                          itemCount: getdata.data.products.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                buttonindex = index;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Itempage(index: index),
                                    ));
                              },
                              child: Stack(children: [
                                Container(
                                    decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.white,
                                )),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(getdata.data
                                                .products[index].thumbnail),
                                            fit: BoxFit.fill),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5,
                                      width: MediaQuery.of(context).size.width /
                                          2.4),
                                ),
                                Positioned(
                                    bottom: 60,
                                    right: 10,
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              22,
                                      width: MediaQuery.of(context).size.width /
                                          2.4,
                                      color: Colors.white,
                                      child: Center(
                                        child: Text(
                                          ' ${getdata.data.products[index].title}',
                                          style: GoogleFonts.acme(),
                                        ),
                                      ),
                                    )),
                                Positioned(
                                    bottom: 40,
                                    left: 15,
                                    child: Text(
                                      '\$${getdata.data.products[index].price}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Positioned(
                                    bottom: 5,
                                    right: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadiusDirectional.circular(
                                                  10)),
                                      height:
                                          MediaQuery.of(context).size.height /
                                              23,
                                      width:
                                          MediaQuery.of(context).size.width / 6,
                                      child: const Center(child: Text('Buy')),
                                    )),
                                Positioned(
                                    bottom: 28,
                                    left: 15,
                                    child: Text(
                                      '${getdata.data.products[index].discountPercentage}% Off',
                                      style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w700),
                                    )),
                                Positioned(
                                    bottom: -10,
                                    child: IconButton(
                                        onPressed: () {
                                          buttonindex = index;
                                        },
                                        icon: Icon(
                                          Icons.favorite,
                                          color: index == buttonindex
                                              ? Colors.red
                                              : Colors.black,
                                        )))
                              ]),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      } else {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      }
    });
  }
}
