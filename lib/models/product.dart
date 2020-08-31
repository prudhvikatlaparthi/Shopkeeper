class Product {
  String productCode;
  String productName;
  String purchasePrice;
  String gstSlab;
  String sellingPrice;
  String get getProductCode => productCode;

  set setProductCode(String productCode) => this.productCode = productCode;

  String get getProductName => productName;

  set setProductName(String productName) => this.productName = productName;

  String get getPurchasePrice => purchasePrice;

  set setPurchasePrice(String purchasePrice) =>
      this.purchasePrice = purchasePrice;

  String get getGstSlab => gstSlab;

  set setGstSlab(String gstSlab) => this.gstSlab = gstSlab;

  String get getSellingPrice => sellingPrice;

  set setSellingPrice(String sellingPrice) => this.sellingPrice = sellingPrice;
}
