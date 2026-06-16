import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carrinho_provider.dart';
import '../models/item_carrinho.dart';

class CarrinhoScreen extends StatelessWidget {
  const CarrinhoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho de Compras'),
        actions: [
          // Botão limpar
          TextButton.icon(
            onPressed: () {
              _mostrarDialogoLimpar(context);
            },
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            label: const Text(
              'Limpar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Consumer<CarrinhoProvider>(
        builder: (context, carrinho, child) {
          if (carrinho.itens.isEmpty) {
            return _buildCarrinhoVazio();
          }
          return _buildListaItens(carrinho);
        },
      ),
      bottomNavigationBar: Consumer<CarrinhoProvider>(
        builder: (context, carrinho, child) {
          if (carrinho.itens.isEmpty) {
            return const SizedBox.shrink();
          }
          return _buildResumoTotal(carrinho);
        },
      ),
    );
  }

  Widget _buildCarrinhoVazio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '🛒',
            style: TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 16),
          const Text(
            'Carrinho vazio',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Adicione produtos para começar',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildListaItens(CarrinhoProvider carrinho) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: carrinho.itens.length,
      itemBuilder: (context, index) {
        return ItemCarrinhoCard(item: carrinho.itens[index]);
      },
    );
  }

  Widget _buildResumoTotal(CarrinhoProvider carrinho) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'R\$ ${carrinho.valorTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Aqui você implementaria o checkout
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'FINALIZAR COMPRA',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoLimpar(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limpar Carrinho'),
        content: const Text('Tem certeza que deseja remover todos os itens?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CarrinhoProvider>().limparCarrinho();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }
}

class ItemCarrinhoCard extends StatelessWidget {
  final ItemCarrinho item;

  const ItemCarrinhoCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Imagem/Emoji
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  item.produto.imagemUrl,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Informações do produto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.produto.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'R\$ ${item.produto.preco.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Controle de quantidade
            Column(
              children: [
                // Subtotal do item
                Text(
                  'R\$ ${item.subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                // Botões de quantidade
                Row(
                  children: [
                    // Botão diminui
                    IconButton(
                      onPressed: () {
                        context.read<CarrinhoProvider>().atualizarQuantidade(
                              item.produto.id,
                              item.quantidade - 1,
                            );
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                      color: Colors.red,
                    ),
                    // Quantidade
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${item.quantidade}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Botão aumenta
                    IconButton(
                      onPressed: () {
                        context.read<CarrinhoProvider>().atualizarQuantidade(
                              item.produto.id,
                              item.quantidade + 1,
                            );
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      color: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}