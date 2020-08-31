import 'package:shopkeeper/constants/firebase-collections.dart';

class OrderItem {
  String productCode;
  String productName;
  double purchasePrice;
  String gstSlab;
  double sellingPrice;
  int quantity;

  Map<String, dynamic> toJson() => {
        'product_code': productCode,
        'product_name': productName,
        productPurchasePrice: purchasePrice.toString(),
        productGSTSlab: gstSlab,
        productSellingPrice: sellingPrice.toString(),
        'quantity': quantity.toString()
      };
  String get getProductCode => productCode;

  set setProductCode(String productCode) => this.productCode = productCode;

  String get getProductName => productName;

  set setProductName(String productName) => this.productName = productName;

  double get getPurchasePrice => purchasePrice;

  set setPurchasePrice(double purchasePrice) =>
      this.purchasePrice = purchasePrice;

  String get getGstSlab => gstSlab;

  set setGstSlab(String gstSlab) => this.gstSlab = gstSlab;

  double get getSellingPrice => sellingPrice;

  set setSellingPrice(double sellingPrice) => this.sellingPrice = sellingPrice;

  int get getQuantity => quantity;

  set setQuantity(int quantity) => this.quantity = quantity;
}
