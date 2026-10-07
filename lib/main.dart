import 'package:flutter/material.dart';

void main() => runApp(const PorcoEatsApp());

class AppColors {
  static const brown = Color(0xFF2A1510);
  static const brownLight = Color(0xFF6A3418);
  static const yellow = Color(0xFFFFB81C);
  static const red = Color(0xFF9B1C14);
  static const cream = Color(0xFFFBF5E8);
  static const muted = Color(0xFF7A6558);
}

class PorcoEatsApp extends StatelessWidget {
  const PorcoEatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Porco Eats',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.yellow),
        scaffoldBackgroundColor: AppColors.cream,
      ),
      home: const LandingPage(),
    );
  }
}

bool isWide(BuildContext c) => MediaQuery.sizeOf(c).width > 860;

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _inicio = GlobalKey();
  final _categorias = GlobalKey();
  final _como = GlobalKey();
  final _contato = GlobalKey();

  void _go(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _order() => ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Em breve: abrir o app para pedir!')),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _Header(
            onInicio: () => _go(_inicio),
            onComo: () => _go(_como),
            onCategorias: () => _go(_categorias),
            onContato: () => _go(_contato),
            onOrder: _order,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _Hero(key: _inicio, onOrder: _order),
                  _Categories(key: _categorias),
                  _HowItWorks(key: _como),
                  const _Why(),
                  _CtaBanner(onOrder: _order),
                  _Footer(key: _contato),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Componentes base ----------

class _Section extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const _Section({
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1080),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class _OrderButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _OrderButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.smartphone, size: 20),
      label: const Text(
        'Pedir agora',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.yellow,
        foregroundColor: AppColors.brown,
        elevation: 0,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionTitle(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 3,
            margin: const EdgeInsets.only(top: 14, right: 12),
            color: AppColors.yellow,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppColors.brown,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: AppColors.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Distribui [children] em [cols] colunas de largura igual.
class _ResponsiveGrid extends StatelessWidget {
  final int cols;
  final double gap;
  final List<Widget> children;
  const _ResponsiveGrid({
    required this.cols,
    required this.children,
    this.gap = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = (c.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [for (final ch in children) SizedBox(width: w, child: ch)],
        );
      },
    );
  }
}

class _IconBubble extends StatelessWidget {
  final IconData icon;
  final bool soft;
  const _IconBubble(this.icon, {this.soft = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: soft ? const Color(0xFFFFF0C9) : const Color(0xFFFFD36B),
        boxShadow: soft
            ? null
            : const [BoxShadow(color: Color(0xFFE59F0A), offset: Offset(0, 4))],
      ),
      child: Icon(
        icon,
        size: 28,
        color: soft ? const Color(0xFFE07A10) : AppColors.brown,
      ),
    );
  }
}

// ---------- Cabeçalho ----------

class _Header extends StatelessWidget {
  final VoidCallback onInicio, onComo, onCategorias, onContato, onOrder;
  const _Header({
    required this.onInicio,
    required this.onComo,
    required this.onCategorias,
    required this.onContato,
    required this.onOrder,
  });

  Widget _link(String label, VoidCallback onTap, {bool active = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: active ? AppColors.yellow : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: active ? AppColors.yellow : Colors.white,
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.brown,
      elevation: 4,
      child: SafeArea(
        bottom: false,
        child: _Section(
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                Image.asset('assets/images/logo.png', height: 48),
                const Spacer(),
                if (isWide(context)) ...[
                  _link('Início', onInicio, active: true),
                  _link('Como funciona', onComo),
                  _link('Categorias', onCategorias),
                  _link('Contato', onContato),
                  const Spacer(),
                ],
                _OrderButton(onPressed: onOrder),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------- Hero ----------

class _Hero extends StatelessWidget {
  final VoidCallback onOrder;
  const _Hero({super.key, required this.onOrder});

  @override
  Widget build(BuildContext context) {
    final wide = isWide(context);
    final size = wide ? 60.0 : 40.0;

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PORCO EATS',
          style: TextStyle(
            color: AppColors.yellow,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'SEU PEDIDO,',
          style: TextStyle(
            color: Colors.white,
            fontSize: size,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        Transform.rotate(
          angle: -0.03,
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.yellow, width: 5),
              ),
            ),
            child: Text(
              'NOSSA MISSÃO!',
              style: TextStyle(
                color: AppColors.yellow,
                fontSize: size,
                fontWeight: FontWeight.w900,
                height: 1.05,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const SizedBox(
          width: 340,
          child: Text(
            'Os melhores sabores da sua cidade, na palma da sua mão.',
            style: TextStyle(color: Color(0xFFF4E6D2), fontSize: 18),
          ),
        ),
        const SizedBox(height: 24),
        _OrderButton(onPressed: onOrder),
      ],
    );

    final art = SizedBox(
      height: 340,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: -0.03,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset(
                'assets/images/burger.jpg',
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Positioned(right: -6, bottom: -20, child: _PhoneMock()),
          if (wide)
            Positioned(
              top: 0,
              right: -90,
              child: Transform.rotate(
                angle: -0.14,
                child: const Text(
                  'RÁPIDO\nPRÁTICO\nDELICIOSO',
                  style: TextStyle(
                    color: AppColors.yellow,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.4, -0.2),
          radius: 1.1,
          colors: [AppColors.brownLight, AppColors.brown],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(900, 40)),
      ),
      padding: const EdgeInsets.fromLTRB(0, 48, 0, 80),
      child: _Section(
        child: wide
            ? Row(
                children: [
                  Expanded(flex: 11, child: text),
                  const SizedBox(width: 20),
                  Expanded(flex: 10, child: Center(child: art)),
                ],
              )
            : Column(children: [text, const SizedBox(height: 30), art]),
      ),
    );
  }
}

class _PhoneMock extends StatelessWidget {
  const _PhoneMock();

  Widget _stat(String n, String label, Color c) => Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            n,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 7)),
        ],
      ),
    ),
  );

  Widget _order(String who, String price) => Container(
    padding: const EdgeInsets.symmetric(vertical: 5),
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(who, style: const TextStyle(fontSize: 9)),
        Text(
          price,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.05,
      child: Container(
        width: 178,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: const Color(0xFF17100D), width: 6),
          boxShadow: const [
            BoxShadow(
              color: Color(0x99000000),
              blurRadius: 30,
              offset: Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Olá, Gustavo!',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.brown,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _stat('5', 'Recebidos', const Color(0xFFD9382C)),
                _stat('3', 'Em preparo', const Color(0xFFF2A51A)),
                _stat('2', 'Em entrega', const Color(0xFF4A2415)),
                _stat('18', 'Entregues', const Color(0xFF2F9E4F)),
              ],
            ),
            const SizedBox(height: 8),
            _order('#1024 Júlio', 'R\$ 72,50'),
            _order('#1025 Maria', 'R\$ 48,90'),
            _order('#1026 Carlos', 'R\$ 36,80'),
          ],
        ),
      ),
    );
  }
}

// ---------- Categorias ----------

class _Categories extends StatelessWidget {
  const _Categories({super.key});

  static const items = [
    ('Lanches', Icons.lunch_dining, 'cat_lanches'),
    ('Pizzas', Icons.local_pizza, 'cat_pizzas'),
    ('Sushi', Icons.set_meal, 'cat_sushi'),
    ('Executivos', Icons.takeout_dining, 'cat_executivos'),
    ('Porções', Icons.fastfood, 'cat_porcoes'),
    ('Bebidas', Icons.local_drink, 'cat_bebidas'),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final cols = w > 860 ? 6 : (w > 480 ? 3 : 2);
    return _Section(
      padding: const EdgeInsets.fromLTRB(20, 36, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            'Tudo que você gosta',
            'Encontre seu sabor favorito',
          ),
          _ResponsiveGrid(
            cols: cols,
            gap: 14,
            children: [
              for (final (label, icon, asset) in items)
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(color: Color(0x142A1510), blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/$asset.jpg',
                        height: 84,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.yellow,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                icon,
                                size: 16,
                                color: AppColors.brown,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              label,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------- Como funciona ----------

class _HowItWorks extends StatelessWidget {
  const _HowItWorks({super.key});

  static const steps = [
    (
      Icons.location_on,
      '1. Escolha seu endereço',
      'Informe onde você quer receber seu pedido.',
    ),
    (
      Icons.restaurant,
      '2. Escolha sua comida',
      'Encontre restaurantes e produtos que você ama.',
    ),
    (
      Icons.shopping_cart,
      '3. Monte seu pedido',
      'Adicione seus produtos ao carrinho.',
    ),
    (
      Icons.delivery_dining,
      '4. Receba em casa',
      'Acompanhe seu pedido até ele chegar.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final cols = w > 860 ? 4 : (w > 480 ? 2 : 1);
    return _Section(
      padding: const EdgeInsets.fromLTRB(20, 36, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            'Como funciona?',
            'Pedir sua comida nunca foi tão fácil',
          ),
          _ResponsiveGrid(
            cols: cols,
            gap: 20,
            children: [
              for (final (icon, title, desc) in steps)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _IconBubble(icon),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            desc,
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------- Por que Porco Eats ----------

class _Why extends StatelessWidget {
  const _Why();

  static const items = [
    (Icons.bolt, 'Agilidade', 'Faça seu pedido de forma rápida e simples.'),
    (Icons.local_offer, 'Ofertas', 'Encontre promoções e ofertas especiais.'),
    (
      Icons.my_location,
      'Acompanhe',
      'Veja o status do seu pedido em tempo real.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cols = isWide(context) ? 3 : 1;
    return _Section(
      padding: const EdgeInsets.fromLTRB(20, 36, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            'Por que Porco Eats?',
            'Uma experiência feita para você',
          ),
          _ResponsiveGrid(
            cols: cols,
            gap: 20,
            children: [
              for (final (icon, title, desc) in items)
                Row(
                  children: [
                    _IconBubble(icon, soft: true),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            desc,
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------- Banner final ----------

class _CtaBanner extends StatelessWidget {
  final VoidCallback onOrder;
  const _CtaBanner({required this.onOrder});

  @override
  Widget build(BuildContext context) {
    final wide = isWide(context);
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.rotate(
          angle: -0.03,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Bateu aquela fome?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Seu próximo pedido está a poucos cliques de distância.',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );

    return _Section(
      padding: const EdgeInsets.fromLTRB(20, 36, 20, 40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
        decoration: BoxDecoration(
          color: AppColors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: wide
            ? Row(
                children: [
                  Expanded(child: text),
                  _OrderButton(onPressed: onOrder),
                  const SizedBox(width: 24),
                  Image.asset('assets/images/logo.png', height: 110),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text,
                  const SizedBox(height: 18),
                  _OrderButton(onPressed: onOrder),
                ],
              ),
      ),
    );
  }
}

// ---------- Rodapé ----------

class _Footer extends StatelessWidget {
  const _Footer({super.key});

  @override
  Widget build(BuildContext context) {
    Widget social(IconData i) => Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(
        color: Color(0x14FFFFFF),
        shape: BoxShape.circle,
      ),
      child: Icon(i, size: 18, color: Colors.white),
    );

    return Container(
      color: AppColors.brown,
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: _Section(
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 20,
          runSpacing: 14,
          children: [
            Image.asset('assets/images/logo.png', height: 44),
            const Text(
              'Seu pedido, nossa missão!',
              style: TextStyle(color: Color(0xFFE8D6C2), fontSize: 13),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                social(Icons.photo_camera),
                const SizedBox(width: 12),
                social(Icons.thumb_up),
                const SizedBox(width: 12),
                social(Icons.music_note),
              ],
            ),
            const Text(
              '© 2026 Porco Eats. Todos os direitos reservados.',
              style: TextStyle(color: Color(0xFFE8D6C2), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
