import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';

class CartIconBadge extends StatelessWidget {
  final Color? color;
  const CartIconBadge({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          color: color,
          onPressed: () => Navigator.of(context).pushNamed('/cart'),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Consumer<CartViewModel>(
            builder: (_, cart, __) {
              if (cart.totalItems == 0) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${cart.totalItems}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
