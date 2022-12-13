import 'package:flutter/material.dart';
import './product.dart';

class Products with ChangeNotifier {
  //ChangeNotifier temelde provider paketinin perde arkasında kullandığı miras alınan widget ile ilgilidir.
  final List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Nike Air Max 270 React Sneaker',
      description: 'Colors : Yellow,black,white,purple',
      price: 99.99,
      imagesUrl:
          'https://static.nike.com/a/images/c_limit,w_592,f_auto/t_product_v1/1aa3abc4-692e-466b-b985-570a178f25ef/air-force-1-gen%C3%A7-ayakkab%C4%B1s%C4%B1-1hqfHl.png',
    ),
    Product(
      id: 'p2',
      title: 'Nike React Element',
      description: 'White and Black',
      price: 57.99,
      imagesUrl:
          'https://cdn-ss.akinon.net/products/2021/11/30/175578/bb2db846-1778-45ac-9941-cba27fa78c85.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Air Zoom Superrep',
      description: 'Very comfortable',
      price: 129.99,
      imagesUrl:
          'https://cdn-ss.akinon.net/products/2021/07/28/338629/739b8b5d-55dc-49fa-8402-b513232a1f81_size1400x1400_quality100_cropCenter.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Nike Court Air Max',
      description: 'Colors : Purple and grey',
      price: 39.99,
      imagesUrl:
          'https://img-s1.onedio.com/id-6116544d1410bc294bc4e25e/rev-0/w-620/f-jpg/s-49136610e6acc42a54ab76512c88d7f4285d4928.jpg',
    ),
  ];
  var _showFavoritesOnly = false;

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

  Product findById(String id) {
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

  void addProduct() {
    //Eğer biz projemizin herhangi bir yerinde bir kodu değiştirirsek veya yeni bir kod eklersek bu kodları ilgilendiren kısımlara nasıl temasta bulunabileceğimizin farkına varmak için ChangeNotifier'i eklemiş olduk,
    //Widgetlere yaptığımız değişiklikler veya güncellemeleri notifyListeners'a bildirmemiz gerekiyor

    //_items.add(value);
    notifyListeners();
  }
}
