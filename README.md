# 🍢 Espetinho — Gestão de Restaurante

Aplicativo Flutter para gerenciar o dia a dia de um restaurante, lanchonete ou
espetinho: cadastro de produtos, controle de estoque, abertura e fechamento de
pedidos, impressão de comandas em impressoras térmicas Bluetooth e relatórios
de vendas e lucro. Tudo funciona **100% offline**, com os dados salvos
localmente no próprio dispositivo (SQLite via Drift).

---

## ✨ Principais recursos

- **Pedidos (comandas):** abra um pedido por cliente, monte o carrinho com
  produtos e suas escolhas (sabores, molhos, adicionais), aplique desconto e
  feche a conta.
- **Produtos flexíveis:** produtos simples (uma bebida), compostos com receita
  (um hambúrguer feito de pão + carne + queijo) e produtos com grupos de
  escolha (escolher o sabor do espeto, adicionar bacon extra, etc.).
- **Controle de estoque:** baixa automática de insumos ao fechar o pedido,
  registro de compras e alerta de estoque mínimo. Produtos servidos "a gosto"
  podem ficar de fora do controle de estoque.
- **Impressão térmica:** envia comandas para impressoras Bluetooth de **58mm**
  ou **80mm**, com impressoras separadas para **cozinha** e **salão**. O app
  reimprime apenas o que mudou e avisa quando um item é cancelado.
- **Monitor de impressora:** se a conexão cair, o app pinta a barra superior de
  vermelho em qualquer tela e mostra um alerta com o conteúdo que seria
  impresso — nada passa despercebido.
- **Relatórios:** vendas por período, produtos mais vendidos, lucro/margem e
  situação do estoque.
- **Configurações:** nome da loja, desconto padrão e tema (claro / escuro /
  sistema).
- **Português (pt-BR)** por padrão, com formatação de datas e moeda localizada.

---

## 🧱 Arquitetura

O projeto segue uma arquitetura por **features** com separação em camadas
(*domain* / *data* / *presentation*), gerenciamento de estado com **BLoC/Cubit**
e injeção de dependências com **GetIt**.

```
lib/
├── main.dart                 # Ponto de entrada (inicializa locale, DI e app)
├── app.dart                  # MaterialApp.router, tema, locale, guarda da impressora
├── core/
│   ├── database/             # Drift: tabelas, DAOs, banco e seed inicial
│   ├── di/injector.dart      # Registro de repositórios e cubits (GetIt)
│   ├── router/app_router.dart# Rotas (go_router)
│   ├── theme/                # Tema claro e escuro
│   └── utils/                # Formatadores (moeda, data)
└── features/
    ├── home/                 # Tela inicial com módulos e banner de pedidos
    ├── menu/                 # Categorias e grupos de produtos
    ├── products/             # Cadastro/edição de produtos e receitas
    ├── stock/                # Estoque e registro de compras
    ├── orders/               # Pedidos, carrinho e impressão de comandas
    ├── reports/              # Relatórios de vendas, lucro e estoque
    ├── printer/              # Impressoras Bluetooth e monitor de conexão
    └── settings/             # Preferências do app
```

Cada *feature* costuma ter:

- **domain/** — entidades e a interface do repositório (contrato).
- **data/** — implementação do repositório (acesso ao banco e regras).
- **presentation/** — telas (`*_page.dart`) e cubits (`*_cubit.dart`).

---

## 🗄️ Modelo de dados

Banco SQLite gerenciado pelo **Drift** (schema versionado, migrações
automáticas — versão atual `8`). Tabelas principais:

| Tabela                                                | Para quê serve                                                                           |
| ----------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| `category` / `group_products`                     | Organizam os produtos em categorias e grupos.                                             |
| `products`                                          | Produtos vendidos e insumos internos (preço de custo/venda, estoque, local de preparo).  |
| `recipe_items`                                      | Receita de um produto composto (quais insumos e quantidades).                             |
| `recipe_choice_groups` / `recipe_choice_options`  | Grupos de escolha (sabor, molho, adicionais) e suas opções.                             |
| `recipe_choice_group_sources`                       | Permite um grupo de escolha puxar produtos de vários grupos.                             |
| `orders` / `order_items` / `order_item_choices` | Pedidos, itens do pedido e escolhas de cada item.                                         |
| `order_print_logs`                                  | Registro do que já foi impresso na cozinha (evita reimpressão e detecta cancelamentos). |
| `purchases`                                         | Histórico de compras de insumos.                                                         |
| `users`                                             | Usuários (reservado).                                                                    |

Pontos importantes do modelo:

- **Local de preparo** (`preparation_location`): cada produto é `kitchen`,
  `hall` ou `both`, e isso decide para qual impressora a comanda vai.
- **Controle de estoque opcional** (`track_stock`): insumos servidos a gosto
  (molhos, saladas) podem não ter o estoque abatido.
- **Custo no momento da venda:** itens e escolhas guardam o custo unitário da
  época, garantindo relatórios de lucro precisos mesmo após mudanças de preço.

O banco é **populado automaticamente na primeira execução** com dados de
exemplo (bebidas, espetos, lanches, insumos e receitas) — veja
[seed_data.dart](lib/core/database/seed_data.dart).

---

## 🖨️ Impressão de comandas

- Suporte a impressoras térmicas Bluetooth via `print_bluetooth_thermal` e
  formatação ESC/POS (`esc_pos_utils_plus`).
- Papel de **58mm** ou **80mm** configurável.
- Impressoras **independentes** para cozinha e salão — cada item vai para o
  destino certo conforme seu local de preparo.
- **Reimpressão inteligente:** ao alterar um pedido já enviado, apenas as
  diferenças são reimpressas; itens removidos geram um aviso de cancelamento.
- **Monitor global de conexão:** se a impressora ficar offline, a interface
  reage (barra vermelha + alerta) e mostra o cupom que não pôde ser impresso.

## 🚀 Começando

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart SDK `^3.12.2`)
- Um dispositivo/emulador Android (a impressão Bluetooth requer dispositivo
  físico com a impressora pareada)

### Instalação

```bash
# 1. Instale as dependências
flutter pub get

# 2. Gere o código do Drift (DAOs e banco)
dart run build_runner build --delete-conflicting-outputs

# 3. Rode o app
flutter run
```

> O passo 2 é necessário sempre que você alterar tabelas ou DAOs do Drift
> (arquivos `.g.dart` são gerados automaticamente).

### Permissões

O app usa `permission_handler` para solicitar acesso ao **Bluetooth** em tempo
de execução, necessário para descobrir e usar as impressoras térmicas.

---

## 🧪 Testes

```bash
flutter test
```

Os testes usam `bloc_test` e `mocktail` para validar cubits e repositórios.

---

## 📦 Dependências principais

| Pacote                                                   | Uso                                                         |
| -------------------------------------------------------- | ----------------------------------------------------------- |
| `flutter_bloc` / `equatable`                         | Gerenciamento de estado (Cubits) e comparação de valores. |
| `drift` / `drift_flutter` / `sqlite3_flutter_libs` | Banco de dados local SQLite tipado.                         |
| `get_it`                                               | Injeção de dependências.                                 |
| `go_router`                                            | Navegação por rotas.                                      |
| `print_bluetooth_thermal` / `esc_pos_utils_plus`     | Impressão térmica Bluetooth (ESC/POS).                    |
| `permission_handler`                                   | Permissões de Bluetooth em tempo de execução.            |
| `intl` / `flutter_localizations`                     | Localização e formatação (pt-BR).                       |
| `shared_preferences`                                   | Persistência das configurações do app.                   |
| `path_provider` / `path`                             | Localização do arquivo do banco no dispositivo.           |

---

## 🗺️ Fluxo de uso típico

1. **Cadastre** categorias, grupos e produtos (com preços, receitas e local de
   preparo).
2. **Reponha o estoque** registrando compras de insumos.
3. **Abra um pedido** para o cliente, monte o carrinho com escolhas e
   adicionais, aplique desconto.
4. **Imprima a comanda** — cozinha e salão recebem o que lhes cabe.
5. **Feche o pedido**, dando baixa automática no estoque.
6. **Acompanhe** vendas, lucro e estoque pelos relatórios.

---

## 📝 Notas

- Aplicativo em português do Brasil, com suporte secundário a inglês.
- Funciona offline; os dados ficam no dispositivo (banco `restaurante`).
- Projeto privado (`publish_to: none`).
