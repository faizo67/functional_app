import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:functional_app/core/utils/dialog_service.dart';
import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_event.dart';
import '../bloc/home/home_state.dart';
import '../../domain/usecases/home_usecase.dart';
import '../../data/models/product_model.dart';

/// HomeUI receives the accessToken from the login page and displays a list of products.
/// Now uses HomeBloc and HomeUseCase to fetch products from the API.
class HomeUI extends StatefulWidget {
  final String accessToken;

  /// The HomeUseCase is injected to fetch products.
  final HomeUseCase homeUseCase;
  const HomeUI({
    required this.accessToken,
    required this.homeUseCase,
    super.key,
  });

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<ProductModel> _products = [];
  bool _isAnimating = true;
  late AnimationController _backgroundController;
  late Animation<Color?> _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
    _backgroundColorAnimation = ColorTween(
      begin: Colors.blue[100],
      end: Colors.purple[100],
    ).animate(_backgroundController);
    _backgroundController.repeat();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _backgroundColorAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _backgroundColorAnimation.value ?? Colors.blue[100]!,
                Colors.blue[50]!,
                Colors.white,
              ],
            ),
          ),
          child: BlocProvider(
            create: (_) =>
                HomeBloc(widget.homeUseCase)
                  ..add(FetchHomeData(accessToken: widget.accessToken)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text('Products'),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: BlocConsumer<HomeBloc, HomeState>(
                listener: (context, state) async {
                  if (state is HomeLoading) {
                    DialogService().showLoader();
                  } else {
                    DialogService().hideLoader();
                  }
                  if (state is HomeLoaded) {
                    _products = [];
                    _isAnimating = true;
                    for (var i = 0; i < state.products.length; i++) {
                      await Future.delayed(const Duration(milliseconds: 100));
                      _products.add(state.products[i]);
                      _listKey.currentState?.insertItem(i);
                    }
                    await Future.delayed(const Duration(milliseconds: 200));
                    setState(() {
                      _isAnimating = false;
                    });
                  }
                },
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return SizedBox.shrink();
                  } else if (state is HomeLoaded) {
                    return AnimatedList(
                      key: _listKey,
                      initialItemCount: _products.length,
                      itemBuilder: (context, index, animation) {
                        final product = _products[index];
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: animation.drive(
                              Tween<Offset>(
                                begin: const Offset(1, 0),
                                end: Offset.zero,
                              ).chain(CurveTween(curve: Curves.easeOut)),
                            ),
                            child: GestureDetector(
                              onTap: _isAnimating
                                  ? null
                                  : () {
                                      context.go(
                                        '/home/details',
                                        extra: product,
                                      );
                                    },
                              child: Hero(
                                tag: 'product_${product.id}',
                                child: CustomProductCard(product: product),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is HomeError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return Container();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomProductCard extends StatelessWidget {
  final ProductModel product;
  const CustomProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.image,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.category,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ' 4${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
