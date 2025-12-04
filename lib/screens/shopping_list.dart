import 'package:flutter/material.dart';
import '../widgets/menu_sanduwitch.dart';

// Classe de modelo para um item da lista de compras
class ShoppingItem {
  // ... (Model class remains the same)
  final String name;
  String category;
  int quantity;

  ShoppingItem({
    required this.name,
    this.category = 'Outros', // Categoria padrão
    this.quantity = 1,
  });
}

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  // ... (State properties remain the same)
  final List<ShoppingItem> _shoppingList = [];
  final List<String> _suggestions = [
    'proteínas',
    'verduras',
    'frutas',
    'doces',
  ];
  final TextEditingController _itemInputController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // Função para mostrar o modal de registro de item (Métodos não mudam)
  void _showItemRegistrationModal(String itemName) {
    // ... (logic remains the same)
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
              onPressed: () {
                final int finalQuantity =
                    int.tryParse(_quantityController.text) ?? 1;

                if (_shoppingList.any((item) => item.name == itemName)) {
                  final existingItem = _shoppingList.firstWhere(
                    (item) => item.name == itemName,
                  );
                  setState(() {
                    existingItem.quantity += finalQuantity;
                  });
                } else {
                  setState(() {
                    _shoppingList.add(
                      ShoppingItem(
                        name: itemName,
                        quantity: finalQuantity,
                        category: _suggestions.contains(itemName.toLowerCase())
                            ? itemName
                            : 'Outros',
                      ),
                    );
                  });
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

  // Função para construir os chips de sugestão e o campo de input (Métodos não mudam)
  Widget _buildInputAndSuggestions(BuildContext context) {
    // ... (method remains the same)
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

  // Função para construir o item da lista (Métodos não mudam)
  Widget _buildShoppingListItem(
    BuildContext context,
    ShoppingItem item,
    int index,
  ) {
    // ... (method remains the same)
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
                    onPressed: () {
                      setState(() {
                        _shoppingList.removeAt(index);
                      });
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
    // === MUDANÇA CRÍTICA: REMOVER MaterialApp e definição de tema local ===

    // O widget Home é o paradigma, e ele retorna apenas um Scaffold
    return Scaffold(
      drawer: const SandwichMenu(),

      // Adaptando o AppBar para ser mais parecido com o de Home (sem título se não for essencial)
      appBar: AppBar(
        title: const Text('🛒 Lista de Compras Inteligente'),
        // Usando as cores do tema principal para consistência
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
            child: _shoppingList.isEmpty
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
    // return MaterialApp(...); // LINHAS REMOVIDAS
  }
}
