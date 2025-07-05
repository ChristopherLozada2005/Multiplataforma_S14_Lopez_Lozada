import 'package:flutter/material.dart';
import '../models/product.dart';
import '../database/product_database.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({Key? key, this.productId}) : super(key: key);

  final int? productId;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final productDatabase = ProductDatabase.instance;
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  late Product product;
  bool isLoading = false;
  bool isNewProduct = false;
  bool isAvailable = true;
  DateTime selectedEventDate = DateTime.now();

  final Color primaryColor = Colors.teal;
  final Color backgroundColor = Colors.grey[100]!;
  final Color cardColor = Colors.white;
  final Color textColor = Colors.grey[800]!;

  @override
  void initState() {
    super.initState();
    refreshProduct();
  }

  Future<void> refreshProduct() async {
    if (widget.productId == null) {
      setState(() {
        isNewProduct = true;
      });
      return;
    }

    try {
      final productData = await productDatabase.read(widget.productId!);
      setState(() {
        product = productData;
        nameController.text = product.name;
        priceController.text = product.price.toString();
        descriptionController.text = product.description;
        isAvailable = product.isAvailable;
        selectedEventDate = product.eventDate;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar el producto')),
      );
    }
  }

  Future<void> _selectEventDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedEventDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: textColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedEventDate) {
      setState(() {
        selectedEventDate = picked;
      });
    }
  }

  Future<void> saveProduct() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final price = double.parse(priceController.text);
      final productModel = Product(
        id: isNewProduct ? null : product.id,
        name: nameController.text,
        price: price,
        description: descriptionController.text,
        isAvailable: isAvailable,
        createdDate: isNewProduct ? DateTime.now() : product.createdDate,
        eventDate: selectedEventDate,
      );

      if (isNewProduct) {
        await productDatabase.create(productModel);
      } else {
        await productDatabase.update(productModel);
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el producto')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteProduct() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de que quieres eliminar este producto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await productDatabase.delete(product.id!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(isNewProduct ? 'Nuevo Producto' : 'Editar Producto'),
        backgroundColor: primaryColor,
        actions: [
          if (!isNewProduct)
            IconButton(
              onPressed: deleteProduct,
              icon: Icon(Icons.delete, color: Colors.red[300]),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: saveProduct,
        icon: Icon(Icons.save),
        label: Text('Guardar'),
        backgroundColor: primaryColor,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    controller: nameController,
                    label: 'Nombre del producto',
                    hint: 'Ingresa el nombre',
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: priceController,
                    label: 'Precio',
                    hint: '0.00',
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: descriptionController,
                    label: 'Descripción',
                    hint: 'Describe el producto',
                    maxLines: 3,
                  ),
                  SizedBox(height: 16),
                  _buildDateSelector(),
                  SizedBox(height: 24),
                  _buildAvailabilitySwitch(),
                ],
              ),
            ),
    );
  }

  Widget _buildAvailabilitySwitch() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: cardColor,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Disponibilidad',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            SizedBox(height: 8),
            SwitchListTile(
              title: Text('Producto disponible'),
              value: isAvailable,
              onChanged: (value) {
                setState(() {
                  isAvailable = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: cardColor,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fecha de Vencimiento',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            SizedBox(height: 8),
            InkWell(
              onTap: _selectEventDate,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.grey[600]),
                    SizedBox(width: 12),
                    Text(
                      '${selectedEventDate.day}/${selectedEventDate.month}/${selectedEventDate.year}',
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: cardColor,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              maxLines: maxLines,
              decoration: Input