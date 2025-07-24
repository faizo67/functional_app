import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:functional_app/core/utils/app_theme.dart';
import 'package:functional_app/core/utils/event_handler_call_back.dart';
import 'package:functional_app/core/utils/home/custom_product_card.dart';
import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_event.dart';
import '../bloc/home/home_state.dart';
import '../../domain/usecases/home_usecase.dart';

/// HomeUI receives the accessToken from the login page and displays a list of products.
/// Now uses HomeBloc and HomeUseCase to fetch products from the API.
class HomeUI extends StatelessWidget {
  final String accessToken;
  final HomeUseCase homeUseCase;
  const HomeUI({
    required this.accessToken,
    required this.homeUseCase,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HomeBloc(homeUseCase)..add(FetchHomeData(accessToken: accessToken)),
      child: Scaffold(
        // Use the appThemeColor for consistent theming surface is for body background
        backgroundColor: appThemeColor.colorScheme.surface,
        appBar: AppBar(title: Text('Products')),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              final products = state.products;
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 400 + index * 100),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    // Use the customProductCard function to create the card
                    child: customProductCard(product, context),
                  );
                },
              );
            } else if (state is HomeError) {
              return Center(child: Text('Error: \\${state.message}'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}

/// Dummy next screen for navigation demonstration.
class NextScreen extends StatelessWidget {
  final String title;
  const NextScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You are on the Details screen'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<HomeBloc>().add(ShowDialogEvent());
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
