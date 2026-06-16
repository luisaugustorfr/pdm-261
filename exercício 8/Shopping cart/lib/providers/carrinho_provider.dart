import 'package:flutter/foundation.dart';
import '../models/produto.dart';
import '../models/item_carrinho.dart';

class CarrinhoProvider extends ChangeNotifier {
  final List<ItemCarrinho> _itens = [];

  // Getter: retorna lista somente para leitura
  List<ItemCarrinho> get itens => List.unmodifiable(_itens);

  // Getter: quantidade total de itens
  int get quantidadeTotal {
    return _itens.fold(0, (sum, item) => sum + item.quantidade);
  }

  // Getter: valor total
  double get valorTotal {
    return _itens.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  // Ação: adicionar produto ao carrinho
  void adicionarProduto(Produto produto) {
    // Verifica se o produto já existe no carrinho
    final index = _itens.indexWhere((item) => item.produto.id == produto.id);

    if (index != -1) {
      // Se existir, aumenta a quantidade
      _itens[index].quantidade++;
    } else {
      // Se não existir, adiciona novo item
      _itens.add(ItemCarrinho(produto: produto));
    }

    // Notifica os widgets监听adores sobre a mudança
    notifyListeners();
  }

  // Ação: remover produto do carrinho
  void removerProduto(String produtoId) {
    _itens.removeWhere((item) => item.produto.id == produtoId);
    notifyListeners();
  }

  // Ação: atualizar quantidade
  void atualizarQuantidade(String produtoId, int novaQuantidade) {
    if (novaQuantidade <= 0) {
      removerProduto(produtoId);
      return;
    }

    final index = _itens.indexWhere((item) => item.produto.id == produtoId);
    if (index != -1) {
      _itens[index].quantidade = novaQuantidade;
      notifyListeners();
    }
  }

  // Ação: limpar todo o carrinho
  void limparCarrinho() {
    _itens.clear();
    notifyListeners();
  }
}
