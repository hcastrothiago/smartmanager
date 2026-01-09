import 'package:flutter/material.dart';
import '../widgets/menu_sanduwitch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingItem {
  final String? documentId;
  final String name;
  String category;
  int quantity;

  ShoppingItem({
    this.documentId,
    required this.name,
    this.category = 'Outros',
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'category': category, 'quantity': quantity};
  }

  factory ShoppingItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ShoppingItem(
      documentId: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? 'Outros',
      quantity: data['quantity'] ?? 1,
    );
  }
}

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final List<ShoppingItem> _shoppingList = [];
  final List<String> _suggestions = [
    'proteínas',
    'verduras',
    'frutas',
    'doces',
  ];
  final TextEditingController _itemInputController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadShoppingList();
  }

  @override
  void dispose() {
    _itemInputController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _loadShoppingList() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário não autenticado. Faça login novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('shopping_list')
          .where('userId', isEqualTo: currentUser.uid)
          .get();

      if (mounted) {
        setState(() {
          _shoppingList.clear();
          _shoppingList.addAll(
            querySnapshot.docs.map((doc) => ShoppingItem.fromFirestore(doc)),
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar lista: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String?> _saveItemToFirestore(ShoppingItem item) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário não autenticado. Faça login novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }

    try {
      final itemData = item.toMap();
      itemData['userId'] = currentUser.uid;

      if (item.documentId != null) {
        await FirebaseFirestore.instance
            .collection('shopping_list')
            .doc(item.documentId)
            .update(itemData);
        return item.documentId;
      } else {
        itemData['createdAt'] = FieldValue.serverTimestamp();
        final docRef = await FirebaseFirestore.instance
            .collection('shopping_list')
            .add(itemData);
        return docRef.id;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar item: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }

      _loadShoppingList();
      return null;
    }
  }

  Future<void> _deleteItemFromFirestore(String documentId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário não autenticado. Faça login novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('shopping_list')
          .doc(documentId)
          .delete();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir item: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }

      _loadShoppingList();
    }
  }

  void _showItemRegistrationModal(String itemName) {
    int tempQuantity = 1;
    _quantityController.text = tempQuantity.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            'Adicionar "$itemName"',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantidade',
                      hintText: 'Digite a quantidade (ex: 3)',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setModalState(() {
                            tempQuantity =
                                int.tryParse(_quantityController.text) ?? 1;
                            tempQuantity++;
                            _quantityController.text = tempQuantity.toString();
                          });
                        },
                      ),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setModalState(() {
                            tempQuantity =
                                int.tryParse(_quantityController.text) ?? 1;
                            if (tempQuantity > 1) tempQuantity--;
                            _quantityController.text = tempQuantity.toString();
                          });
                        },
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setModalState(() {
                        tempQuantity = int.tryParse(value) ?? 1;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final int finalQuantity =
                    int.tryParse(_quantityController.text) ?? 1;

                final existingItemIndex = _shoppingList.indexWhere(
                  (item) => item.name.toLowerCase() == itemName.toLowerCase(),
                );

                if (existingItemIndex != -1) {
                  final existingItem = _shoppingList[existingItemIndex];
                  final updatedItem = ShoppingItem(
                    documentId: existingItem.documentId,
                    name: existingItem.name,
                    category: existingItem.category,
                    quantity: existingItem.quantity + finalQuantity,
                  );

                  final savedId = await _saveItemToFirestore(updatedItem);

                  if (mounted && savedId != null) {
                    setState(() {
                      _shoppingList[existingItemIndex] = updatedItem;
                    });
                  }
                } else {
                  final newItem = ShoppingItem(
                    name: itemName,
                    quantity: finalQuantity,
                    category: _suggestions.contains(itemName.toLowerCase())
                        ? itemName
                        : 'Outros',
                  );

                  final savedId = await _saveItemToFirestore(newItem);

                  if (mounted && savedId != null) {
                    final savedItem = ShoppingItem(
                      documentId: savedId,
                      name: newItem.name,
                      category: newItem.category,
                      quantity: newItem.quantity,
                    );

                    setState(() {
                      _shoppingList.add(savedItem);
                    });
                  } else if (mounted) {
                    _loadShoppingList();
                  }
                }

                _itemInputController.clear();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Confirmar Adição',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      _quantityController.clear();
    });
  }

  Widget _buildInputAndSuggestions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              ..._suggestions.map(
                (item) => ActionChip(
                  label: Text(item.toUpperCase()),
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  onPressed: () => _showItemRegistrationModal(item),
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.5),
                    ),
                  ),
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _itemInputController,
                  decoration: const InputDecoration(
                    labelText: 'Novo Item',
                    hintText: 'ex: pão, leite, frango',
                    border: OutlineInputBorder(),
                  ),
                  onFieldSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      _showItemRegistrationModal(value.trim());
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(56, 56),
                ),
                child: const Icon(Icons.add_shopping_cart, size: 24),
                onPressed: () {
                  final newItem = _itemInputController.text.trim();
                  if (newItem.isNotEmpty) {
                    _showItemRegistrationModal(newItem);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShoppingListItem(
    BuildContext context,
    ShoppingItem item,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Categoria: ${item.category}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${item.quantity}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final itemToDelete = _shoppingList[index];

                      setState(() {
                        _shoppingList.removeAt(index);
                      });

                      if (itemToDelete.documentId != null) {
                        await _deleteItemFromFirestore(
                          itemToDelete.documentId!,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8),
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      minimumSize: Size.zero,
                    ),
                    child: const Icon(Icons.delete_forever, size: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SandwichMenu(),

      appBar: AppBar(
        title: const Text('🛒 Lista de Compras'),

        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ??
            Theme.of(context).colorScheme.primary,
        foregroundColor:
            Theme.of(context).appBarTheme.foregroundColor ?? Colors.white,
        elevation: 4,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: _buildInputAndSuggestions(context),
          ),
          const SizedBox(height: 24),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _shoppingList.isEmpty
                ? Center(
                    child: Text(
                      'A lista está vazia.\nAdicione seu primeiro item!',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _shoppingList.length,
                    itemBuilder: (context, index) {
                      return _buildShoppingListItem(
                        context,
                        _shoppingList[index],
                        index,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
