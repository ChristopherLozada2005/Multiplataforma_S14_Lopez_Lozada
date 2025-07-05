import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color textColor = Colors.grey[800]!;
    final Color subTextColor = Colors.grey[600]!;
    final Color badgeColor = product.isAvailable ? Colors.green[100]! : Colors.red[100]!;
    final Color badgeTextColor = product.isAvailable ? Colors.green[800]! : Colors.red[800]!;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre y disponibilidad
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.isAvailable ? 'Disponible' : 'No disponible',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: badgeTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Precio
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: 6),

              // Descripción
              Text(
                product.description,
                style: TextStyle(
                  fontSize: 14,
                  color: subTextColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),

              // Fechas
              Row(
                children: [
                  Icon(Icons.event, size: 16, color: Colors.grey[500]),
                  SizedBox(width: 6),
                  Text(
                    'Evento: ${product.eventDate.day}/${product.eventDate.month}/${product.eventDate.year}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[400]),
                  SizedBox(width: 6),
                  Text(
                    'Creado: ${product.createdDate.day}/${product.createdDate.month}/${product.createdDate.year}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
