// import 'package:creating_api/model/model.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/api model.dart';

// ignore: constant_identifier_names
enum Providerstatus { LOADING, COMPLETED }

class DataProvider extends ChangeNotifier {
  late Ecommace data;
  Providerstatus status = Providerstatus.LOADING;
  late SharedPreferences _preference;

  fetchQuestion() async {
    final response =
        await http.get(Uri.parse("https://dummyjson.com/products"));
    (response.toString());
    if (response.statusCode == 200) {
      data = ecommaceFromJson(response.body);
      status = Providerstatus.COMPLETED;
      // return welcomeFromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
    notifyListeners();
  }

  //remove cart item
  removeitem(int index) async {
    CartSample.removeAt(index);
    await saveSF();
    notifyListeners();
  }

  // ignore: non_constant_identifier_names
  List<int> CartSample = [];

  Future<void> saveSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringNumbers = CartSample.map(
      // ignore: non_constant_identifier_names
      (CartSample) => CartSample.toString(),
    ).toList();
    await prefs.setStringList("number", stringNumbers);
  }

  loadSF() async {
    _preference = await SharedPreferences.getInstance();
    List<String>? stringNumbers = _preference.getStringList("number");
    if (stringNumbers != null) {
      List<int> numbers = stringNumbers
          .map((stringNumbers) => int.parse(stringNumbers))
          .toList();
      CartSample = numbers;
    }
  }
}
