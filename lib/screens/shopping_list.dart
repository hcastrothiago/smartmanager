import 'package:flutter/material.dart';

// Classe de modelo para um item da lista de compras
class ShoppingItem {
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
  // Lista de itens atualmente na lista de compras
  final List<ShoppingItem> _shoppingList = [];

  // Sugestões de categorias genéricas ou itens rápidos
  final List<String> _suggestions = [
    'proteínas',
    'verduras',
    'frutas',
    'doces',
  ];

  // Controlador para o campo de texto de adição de item principal
  final TextEditingController _itemInputController = TextEditingController();

  // Controlador para o campo de texto de quantidade dentro do modal
  final TextEditingController _quantityController = TextEditingController();

  // Função para mostrar o modal de registro de item
  void _showItemRegistrationModal(String itemName) {
    int tempQuantity = 1;
    _quantityController.text = tempQuantity
        .toString(); // Inicializa o controlador do modal

    // Substitui showMoonModal por showDialog (Modal padrão do Material)
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Equivalente ao MoonModal com borda squircle no Material
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
                  // Campo de Quantidade (Substitui MoonTextInput)
                  TextFormField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantidade',
                      hintText: 'Digite a quantidade (ex: 3)',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        // Botão de incremento (+)
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
                        // Botão de decremento (-)
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
            // Botão de Confirmação (Substitui MoonFilledButton)
            ElevatedButton(
              onPressed: () {
                final int finalQuantity =
                    int.tryParse(_quantityController.text) ?? 1;

                // Validação e lógica de adição/atualização
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

                // Limpa o campo de input principal e fecha o modal
                _itemInputController.clear();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(
                  double.infinity,
                  48,
                ), // Assegura largura total
                backgroundColor: Theme.of(
                  context,
                ).primaryColor, // Cor de fundo principal
                foregroundColor: Colors.white, // Cor do texto
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
      // Garante que o controlador do modal seja limpo ao fechar
      _quantityController.clear();
    });
  }

  // Função para construir os chips de sugestão e o campo de input
  Widget _buildInputAndSuggestions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chips de Sugestão
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              // Mapeia a lista de sugestões para chips clicáveis
              ..._suggestions.map(
                (item) => ActionChip(
                  label: Text(item.toUpperCase()),
                  // O ActionChip não tem 'backgroundColor', use o style:
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),

                  // O ActionChip possui o parâmetro onPressed, que é o que você precisa!
                  onPressed: () => _showItemRegistrationModal(item),

                  // Você pode usar o shape para manter a aparência se necessário
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

        // Campo para Adicionar Item
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  // Substitui MoonTextInput
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
              // Botão de adição (Substitui MoonFilledButton.icon)
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

  // Função para construir o item da lista
  Widget _buildShoppingListItem(
    BuildContext context,
    ShoppingItem item,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        // Substitui MoonCard
        elevation: 2,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Nome do Item e Categoria
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

              // Quantidade e Botão de Remover
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
                    // Substitui MoonFilledButton.icon (para o delete)
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
    // Definindo um tema básico para simular as cores da Moon Design (piccolo/goku/chichi)
    final ThemeData theme = ThemeData(
      primaryColor: const Color(
        0xFF6366F1,
      ), // Simula o 'piccolo' (roxo/azul primário)
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.indigo,
        accentColor: const Color(
          0xFFE94E77,
        ), // Simula o 'chichi' (rosa/vermelho secundário)
        backgroundColor: const Color(
          0xFFF7F7F7,
        ), // Simula o 'goku' (fundo claro)
      ),
      useMaterial3: true,
    );

    return MaterialApp(
      title: 'Lista de Compras Material',
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('🛒 Lista de Compras Inteligente'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        body: Column(
          children: [
            // Área de Input e Sugestões
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: _buildInputAndSuggestions(context),
            ),
            const SizedBox(height: 24),

            // **Lista de Compras**
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
      ),
    );
  }
}
