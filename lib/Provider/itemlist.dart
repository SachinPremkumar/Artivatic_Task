
import 'dart:convert';
import 'dart:async';
import 'package:artivatic_task/Model/itemfields.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class ItemList with ChangeNotifier {
  List<Items> _itemList =[];

  //for fetch the item
  Future<List<Items>> fecthList() async {
    try {
      _itemList.clear();
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

      final responseJson = json.decode(response.body);

      List data = [];
      responseJson.asMap().forEach((index, value) {
        _itemList.add(Items.fromJson(responseJson[index] as Map<String, dynamic>));
      }
      );
      notifyListeners();
      return _itemList;
    }catch (error){
      throw error;
    }
  }

  //for adding the item
  Future<List<Items>> AddList(String title, String body) async {
    debugPrint("ad...."+items.length.toString());
    _itemList.add(Items(id: items.length+1,userId: 1,title: title,body: body));
    notifyListeners();
    return _itemList;
  }

  //for removing the item
  Future<List<Items>> RemoList(int index) async {
    debugPrint("ad...."+items.length.toString());
    //_itemList.add(Items(id: items.length+1,userId: 1,title: title,body: body));
    _itemList.removeAt(index);
    notifyListeners();
    return _itemList;
  }

  List<Items> get items {
    return [..._itemList];
  }
}