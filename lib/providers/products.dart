import 'dart:convert';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/http_exception.dart';

import './product.dart';

class Products with ChangeNotifier {
  //ChangeNotifier temelde provider paketinin perde arkasında kullandığı miras alınan widget ile ilgilidir.
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Nike Air Max 270 React Sneaker',
    //   description: 'Colors : Yellow,black,white,purple',
    //   price: 99.99,
    //   imagesUrl:
    //       'https://static.nike.com/a/images/c_limit,w_592,f_auto/t_product_v1/1aa3abc4-692e-466b-b985-570a178f25ef/air-force-1-gen%C3%A7-ayakkab%C4%B1s%C4%B1-1hqfHl.png',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Nike React Element',
    //   description: 'White and Black',
    //   price: 57.99,
    //   imagesUrl:
    //       'https://cdn-ss.akinon.net/products/2021/11/30/175578/bb2db846-1778-45ac-9941-cba27fa78c85.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Air Zoom Superrep',
    //   description: 'Very comfortable',
    //   price: 129.99,
    //   imagesUrl:
    //       'https://cdn-ss.akinon.net/products/2021/07/28/338629/739b8b5d-55dc-49fa-8402-b513232a1f81_size1400x1400_quality100_cropCenter.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Nike Court Air Max',
    //   description: 'Colors : Purple and grey',
    //   price: 39.99,
    //   imagesUrl:
    //       'https://img-s1.onedio.com/id-6116544d1410bc294bc4e25e/rev-0/w-620/f-jpg/s-49136610e6acc42a54ab76512c88d7f4285d4928.jpg',
    // ),
  ];
  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
    // ... => yayma operatörüdür. Bu operatörle beraber bunların kopyasını döndürebiliyoruz.
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String? id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts() async {
    //firebaseden ürünlerimizi bu şekilde çekiyoruz
    final url = Uri.parse(
        'https://flutter-apps-4cc2f-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  } //Uri.parse kullanırken girilen url'yi bölmüyoruz.

  Future<void> addProduct(Product product) async {
    //Eğer biz projemizin herhangi bir yerinde bir kodu değiştirirsek veya yeni bir kod eklersek bu kodları ilgilendiren kısımlara nasıl temasta bulunabileceğimizin farkına varmak için ChangeNotifier'i eklemiş olduk,
    //Widgetlere yaptığımız değişiklikler veya güncellemeleri notifyListeners'a bildirmemiz gerekiyor
    // ignore: unused_local_variable

    final url = Uri.https(
        'flutter-apps-4cc2f-default-rtdb.firebaseio.com', '/products.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );

      _items.add(newProduct);

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://flutter-apps-4cc2f-default-rtdb.firebaseio.com/products/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://flutter-apps-4cc2f-default-rtdb.firebaseio.com/products/$id.json');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }

    existingProduct = null;
  }
}
