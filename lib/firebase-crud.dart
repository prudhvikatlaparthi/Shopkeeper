import 'package:cloud_firestore/cloud_firestore.dart';

Stream<QuerySnapshot> fetchData(collectionName, orderBy,
    {isDescending = false}) {
  var fireStore = Firestore.instance;
  Stream<QuerySnapshot> products = fireStore
      .collection(collectionName)
      .orderBy(orderBy, descending: isDescending)
      .snapshots();
  print(products);
  return products;
}

Stream<QuerySnapshot> fetchSubData(mainCollectionDoc, collectionData, orderBy,
    {isDescending = false}) {
  var fireStore = Firestore.instance;
  var documentRef = fireStore.document(mainCollectionDoc);
  Stream<QuerySnapshot> products = documentRef
      .collection(collectionData)
      .orderBy(orderBy, descending: isDescending)
      .snapshots();
  print(products);
  return products;
}

updateData(collectionName, documentID, data) async {
  var fireStore = Firestore.instance;
  await fireStore
      .collection(collectionName)
      .document(documentID)
      .updateData(data)
      .catchError((onError) => print(onError));
}

createData(collectionName, data) async {
  var fireStore = Firestore.instance;
  await fireStore
      .collection(collectionName)
      .add(data)
      .catchError((onError) => print(onError))
      .then((value) => print(value.documentID));
}

createsubData(collectionName, data, subdata) async {
  var fireStore = Firestore.instance;
  await fireStore
      .collection(collectionName)
      .add(data)
      .catchError((onError) => print(onError))
      .then((value) async {
    print(value.documentID);
    subdata.map((e) async {
      await fireStore
          .collection(collectionName)
          .document(value.documentID)
          .collection("items")
          .add(e.toJson())
          .catchError((onError) => print(onError))
          .then((value) => print(value));
    }).toList();
  });
}

deleteData(collectionName, documentID) async {
  var fireStore = Firestore.instance;
  await fireStore.collection(collectionName).document(documentID).delete();
}
