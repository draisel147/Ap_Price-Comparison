import 'package:flutter/material.dart';

void main() {
  runApp(PriceComparisonApp());
}

class PriceComparisonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price Comparison',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor:
              Color.fromARGB(255, 193, 240, 237), 
        ),
        useMaterial3: true,
      ),
      home: PriceComparisonScreen(),
    );
  }
}

class PriceComparisonScreen extends StatefulWidget {
  @override
  _PriceComparisonScreenState createState() => _PriceComparisonScreenState();
}

class _PriceComparisonScreenState extends State<PriceComparisonScreen> {
  List<ProductInput> productInputs = [];

  double percentDifference = 0.0;
  String cheaperProduct = '';

  @override
  void initState() {
    super.initState();
    addProductInput('A');
    addProductInput('B');
  }

  void addProductInput(String productName) {
    setState(() {
      productInputs.add(ProductInput(productName));
    });
  }

  void removeProductInput() {
    setState(() {
      if (productInputs.length > 2) {
        productInputs.removeLast();
      }
    });
  }

  void calculatePercentages() {
    List<double> productPercentages = [];
    List<double> productPrices = [];

    productInputs.forEach((productInput) {
      double quantity =
          double.tryParse(productInput.quantityController.text) ?? 0.0;
      double price = double.tryParse(productInput.priceController.text) ?? 0.0;

      if (price != 0) {
        double percent = quantity / price * 100;
        productPercentages.add(percent);
        productPrices.add(price);
      }
    });

    if (productPercentages.isNotEmpty) {
      double maxPercent = productPercentages
          .reduce((value, element) => value > element ? value : element);
      int maxIndex = productPercentages.indexOf(maxPercent);
      cheaperProduct = productInputs[maxIndex].productName;

      double maxPrice = productPrices[maxIndex];
      percentDifference = ((productPrices.reduce(
                      (value, element) => value > element ? value : element) -
                  maxPrice) /
              productPrices.reduce(
                  (value, element) => value > element ? value : element)) *
          100;
    } else {
      cheaperProduct = 'ไม่มีสินค้าที่ถูกกว่า';
      percentDifference = 0.0;
    }

    setState(() {});
  }

  void resetInputs() {
    setState(() {
      productInputs.clear();
      addProductInput('A');
      addProductInput('B');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Price Comparison'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...productInputs,
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: calculatePercentages,
                    child: Text('คำนวณ'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      resetInputs();
                    },
                    child: Text('Reset'),
                  ),
                  SizedBox(width: 8),
                  FloatingActionButton(
                    onPressed: () {
                      addProductInput(
                          String.fromCharCode(65 + productInputs.length));
                    },
                    child: Icon(Icons.add),
                  ),
                  if (productInputs.length >
                      2) // เพิ่มเงื่อนไขตรวจสอบว่ามีสินค้ามากกว่า 2 ชิ้นหรือไม่
                    FloatingActionButton(
                      // ถ้ามีให้แสดงปุ่มลบ
                      onPressed: () {
                        removeProductInput();
                      },
                      child: Icon(Icons.remove),
                    ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                cheaperProduct.isNotEmpty
                    ? 'สินค้า $cheaperProduct ที่สุด '
                    : '',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                'หากซื้อสินค้าแต่ละชิ้นด้วยราคา 1 บาท คุณจะได้ปริมาณต่อชิ้นดังนี้:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: productInputs.map((product) {
                  double quantity =
                      double.tryParse(product.quantityController.text) ?? 0.0;
                  double price =
                      double.tryParse(product.priceController.text) ?? 0.0;
                  double perBaht = quantity / price;
                  return Text(
                    'สินค้า ${product.productName} ราคา 1 บาทซื้อได้ปริมาณ ${perBaht.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 14),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductInput extends StatelessWidget {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final String productName;

  ProductInput(this.productName);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'ปริมาณสินค้า $productName'),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'ราคาสินค้า $productName'),
          ),
        ),
        SizedBox(width: 16),
      ],
    );
  }
}
