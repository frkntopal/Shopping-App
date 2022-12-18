import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product.dart';
import '../screens/product_detail_screen.dart';
import '../providers/cart.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
//   final String id;
//   final String title;
//   final String imagesUrl;

//   const ProductItem(this.id, this.title, this.imagesUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: ((ctx, product, _) => IconButton(
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: () {
                    product.toggleFavoriteStatus();
                  },
                  color: Colors.redAccent,
                )),
          ),
          backgroundColor: Colors.black54,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.add_shopping_cart,
            ),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added item to cart!',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ), //Snackbar bilgi penceresi açmaya yarıyor. Ürün eklendi gibi.
                ),
              );
            },
            color: Colors.redAccent,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imagesUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
