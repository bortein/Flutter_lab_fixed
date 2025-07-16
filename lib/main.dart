import 'package:flutter/material.dart';
import 'app_database.dart';
import 'shopping_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('shopping.db').build();
  runApp(MyApp(database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp(this.database, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Shopping List', database: database),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final AppDatabase database;

  const MyHomePage({super.key, required this.title, required this.database});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _itemController;
  late TextEditingController _quantityController;

  List<ShoppingItem> items = [];
  ShoppingItem? selectedItem;

  @override
  void initState() {
    super.initState();
    _itemController = TextEditingController();
    _quantityController = TextEditingController();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final dao = widget.database.itemDao;
    final loadedItems = await dao.findAllItems();
    setState(() => items = loadedItems);
  }

  Future<void> _addItem(String name, String qty) async {
    final dao = widget.database.itemDao;
    final newItem = ShoppingItem(name: name, quantity: qty);
    await dao.insertItem(newItem);
    _itemController.clear();
    _quantityController.clear();
    await _loadItems();
  }

  Future<void> _deleteItem(ShoppingItem item) async {
    final dao = widget.database.itemDao;
    await dao.deleteItem(item);
    setState(() {
      if (selectedItem?.id == item.id) selectedItem = null;
    });
    await _loadItems();
  }

  void _selectItem(ShoppingItem item) {
    setState(() {
      selectedItem = item;
    });
  }

  void _closeDetails() {
    setState(() {
      selectedItem = null;
    });
  }

  @override
  void dispose() {
    _itemController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth >= 600;
        return Scaffold(
          appBar: AppBar(title: Text(widget.title)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _itemController,
                      decoration: InputDecoration(labelText: 'Item'),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _quantityController,
                      decoration: InputDecoration(labelText: 'Quantity'),
                    ),
                  ),
                  ElevatedButton(
                    child: Text("Add"),
                    onPressed: () {
                      final name = _itemController.text.trim();
                      final qty = _quantityController.text.trim();
                      if (name.isNotEmpty && qty.isNotEmpty) {
                        _addItem(name, qty);
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: isWide
                    ? Row(
                  children: [
                    Expanded(child: _buildItemList(isWide)),
                    VerticalDivider(),
                    Expanded(child: selectedItem != null ? _buildDetailsPage() : Container()),
                  ],
                )
                    : selectedItem == null
                    ? _buildItemList(isWide)
                    : _buildDetailsPage(),
              ),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildItemList(bool isWide) {
    return items.isEmpty
        ? Center(child: Text("No items added."))
        : ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => _selectItem(item),
          child: Card(
            child: ListTile(
              title: Text(item.name),
              trailing: Text('Qty: ${item.quantity}'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailsPage() {
    if (selectedItem == null) return SizedBox.shrink();
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Item: ${selectedItem!.name}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text("Quantity: ${selectedItem!.quantity}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("ID: ${selectedItem!.id}", style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _deleteItem(selectedItem!),
                  child: Text("Delete"),
                ),
                SizedBox(width: 16),
                OutlinedButton(
                  onPressed: _closeDetails,
                  child: Text("Close"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
