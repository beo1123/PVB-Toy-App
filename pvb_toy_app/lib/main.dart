// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, duplicate_ignore
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pvb_toy_app/model/product.dart';
import 'package:pvb_toy_app/network/api_request.dart';
import 'package:pvb_toy_app/state/state_management.dart';
import 'package:pvb_toy_app/view/Check_out.dart';
import 'package:pvb_toy_app/view/Order_Detail.dart';
import 'package:pvb_toy_app/view/admin.dart';
import 'package:pvb_toy_app/view/cart_detail.dart';
import 'package:pvb_toy_app/view/login.dart';
import 'package:pvb_toy_app/view/order_history.dart';
import 'package:pvb_toy_app/view/product_brand_view.dart';
import 'package:pvb_toy_app/view/product_detail_view.dart';
import 'package:pvb_toy_app/view/product_discount_view.dart';
import 'package:pvb_toy_app/view/product_list_view.dart';
import 'package:pvb_toy_app/view/user_profile.dart';
import 'package:pvb_toy_app/widget/product_cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<String?> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('token');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ignore: duplicate_ignore
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/productList':
            return PageTransition(
                type: PageTransitionType.fade,
                child: ProductListPage(),
                settings: settings);
          case '/home':
            return PageTransition(
                type: PageTransitionType.fade,
                child: MyHomePage(),
                settings: settings);
          case '/productDetail':
            return PageTransition(
                type: PageTransitionType.fade,
                child: ProductDetailPage(),
                settings: settings);
          case '/cartDetail':
            return PageTransition(
                type: PageTransitionType.fade,
                child: CartDetail(),
                settings: settings);
          case '/producBrandList':
            return PageTransition(
                type: PageTransitionType.fade,
                child: ProductBrandListPage(),
                settings: settings);
          case '/producDiscountList':
            return PageTransition(
                type: PageTransitionType.fade,
                child: ProductDiscountListPage(),
                settings: settings);
          case '/login':
            return PageTransition(
                type: PageTransitionType.fade,
                child: Login(),
                settings: settings);
          case '/userDetail':
            return PageTransition(
                type: PageTransitionType.fade,
                child: UserProfile(),
                settings: settings);
          case '/checkOut':
            return PageTransition(
                type: PageTransitionType.fade,
                child: CheckOut(),
                settings: settings);
          case '/orders':
            return PageTransition(
                type: PageTransitionType.fade,
                child: OrderHistory(),
                settings: settings);
          case '/orderDetail':
            return PageTransition(
                type: PageTransitionType.fade,
                child: OrderDetail(),
                settings: settings);
          case '/adminPage':
            return PageTransition(
                type: PageTransitionType.fade,
                child: AdminPage(),
                settings: settings);

          default:
            return null;
        }
      },

      title: 'Pvb Toy Shop',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      // ignore: prefer_const_constructors
      home: FutureBuilder(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            debugPrint('$snapshot.data');
            return MyHomePage();
          } else {
            debugPrint('$snapshot.data');
            return Login();
          }
        },
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class MyHomePage extends ConsumerWidget {
  // ignore: top_level_function_literal_block
  final _fetchCategory = FutureProvider((ref) async {
    var result = await fetchCategory();
    return result;
  });

  Future<String?> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('token');
  }

  // ignore: unused_field
  final _fetchProductByDiscount =
      FutureProvider.family<List<myToy>, int?>((ref, id) async {
    var result = await fetchProductByDiscount(id);
    return result;
  });

  final _fetchBrand = FutureProvider((ref) async {
    var result = await fetchBrand();
    return result;
  });

  final _fetchDiscount = FutureProvider((ref) async {
    var result = await fetchDiscount();
    return result;
  });

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var categoryApiResult = ref.watch(_fetchCategory);
    var ProductApiResult = ref.watch(_fetchProductByDiscount(1));
    var brandApiResult = ref.watch(_fetchBrand);
    var discountApiResult = ref.watch(_fetchDiscount);
    return Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
            child: ListView(
          children: [
            ExpansionTile(
              title: Text('Category'),
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 200.0,
                      child: categoryApiResult.when(
                          data: (category) => ListView.builder(
                                itemCount: category.length,
                                itemBuilder: ((context, index) {
                                  return Card(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: ListTile(
                                        onTap: () {
                                          ref
                                              .read(categorySelected.notifier)
                                              .state
                                              .id = category[index].id;
                                          ref
                                              .read(categorySelected.notifier)
                                              .state
                                              .category = category[
                                                  index]
                                              .category;
                                          Navigator.of(context)
                                              .pushNamed('/productList');
                                        },
                                        title: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  category[index]
                                                      .catImg
                                                      .toString()),
                                            ),
                                            // ignore: prefer_const_constructors
                                            SizedBox(
                                              width: 30,
                                            ),
                                            category[index]
                                                        .category
                                                        .toString()
                                                        .length <=
                                                    10
                                                ? Text(category[index]
                                                    .category
                                                    .toString())
                                                : Text(
                                                    category[index]
                                                        .category
                                                        .toString(),
                                                    // ignore: prefer_const_constructors
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  )
                                          ],
                                        )),
                                  ));
                                }),
                              ),
                          error: (error, stack) => Center(
                                child: Text("$error"),
                              ),
                          loading: () =>
                              const Center(child: CircularProgressIndicator())),
                    )
                  ],
                )
              ],
            ),
            ExpansionTile(
              title: Text('Brand'),
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 200.0,
                      child: brandApiResult.when(
                          data: (brand) => ListView.builder(
                                itemCount: brand.length,
                                itemBuilder: ((context, index) {
                                  return Card(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: ListTile(
                                        onTap: () {
                                          ref
                                              .read(brandSelected.notifier)
                                              .state
                                              .id = brand[index].id;
                                          ref
                                              .read(brandSelected.notifier)
                                              .state
                                              .brand = brand[index].brand;
                                          Navigator.of(context)
                                              .pushNamed('/producBrandList');
                                        },
                                        title: Row(
                                          children: [
                                            // ignore: prefer_const_constructors
                                            SizedBox(
                                              width: 30,
                                            ),
                                            brand[index]
                                                        .brand
                                                        .toString()
                                                        .length <=
                                                    10
                                                ? Text(brand[index]
                                                    .brand
                                                    .toString())
                                                : Text(
                                                    brand[index]
                                                        .brand
                                                        .toString(),
                                                    // ignore: prefer_const_constructors
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  )
                                          ],
                                        )),
                                  ));
                                }),
                              ),
                          error: (error, stack) => Center(
                                child: Text("$error"),
                              ),
                          loading: () =>
                              const Center(child: CircularProgressIndicator())),
                    )
                  ],
                )
              ],
            ),
            ExpansionTile(
              title: Text('Discount'),
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 200.0,
                      child: discountApiResult.when(
                          data: (discount) => ListView.builder(
                                itemCount: discount.length,
                                itemBuilder: ((context, index) {
                                  return Card(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: ListTile(
                                        onTap: () {
                                          ref
                                              .read(discountSelected.notifier)
                                              .state
                                              .id = discount[index].id;
                                          ref
                                              .read(discountSelected.notifier)
                                              .state
                                              .name = discount[index].name;
                                          Navigator.of(context)
                                              .pushNamed('/producDiscountList');
                                        },
                                        title: Row(
                                          children: [
                                            // ignore: prefer_const_constructors
                                            SizedBox(
                                              width: 30,
                                            ),
                                            discount[index]
                                                        .name
                                                        .toString()
                                                        .length <=
                                                    10
                                                ? Text(discount[index]
                                                    .name
                                                    .toString())
                                                : Text(
                                                    discount[index]
                                                        .name
                                                        .toString(),
                                                    // ignore: prefer_const_constructors
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  )
                                          ],
                                        )),
                                  ));
                                }),
                              ),
                          error: (error, stack) => Center(
                                child: Text("$error"),
                              ),
                          loading: () =>
                              const Center(child: CircularProgressIndicator())),
                    )
                  ],
                )
              ],
            )
          ],
        )),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Drawer button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ignore: avoid_returning_null_for_void

                  IconButton(
                    // ignore: prefer_const_constructors
                    icon: Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  Text(
                    'PvB Toy Shop',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  Row(
                    children: [
                      FutureBuilder(
                        future: getToken(),
                        builder: (context, snapshot) {
                          var token = snapshot.data;
                          return IconButton(
                            icon: Icon(
                              token != null
                                  ? Icons.account_circle_rounded
                                  : null,
                              size: 30,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/userDetail');
                            },
                          );
                        },
                      ),
                      FutureBuilder(
                        future: getToken(),
                        builder: (context, snapshot) {
                          var token = snapshot.data;
                          return IconButton(
                            icon: Icon(
                              Icons.shopping_bag_outlined,
                              size: 30,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              if (token == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                        'Login Or Register to see Cart'),
                                    action: SnackBarAction(
                                      label: 'OK',
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed('/login');
                                      },
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.of(context).pushNamed('/cartDetail');
                              }
                            },
                          );
                        },
                      ),
                      FutureBuilder(
                        future: getToken(),
                        builder: (context, snapshot) {
                          var token = snapshot.data;
                          return IconButton(
                            icon: Icon(
                              token == null
                                  ? Icons.account_circle_outlined
                                  : Icons.exit_to_app,
                              size: 30,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              if (token == null) {
                                Navigator.of(context).pushNamed('/login');
                              } else {
                                Logout();
                                Navigator.of(context).pushNamed('/home');
                              }
                            },
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
              categoryApiResult.when(
                  data: (category) => Stack(
                        alignment: Alignment.center,
                        children: [
                          CarouselSlider(
                              items: category
                                  .map((e) => Builder(
                                      // ignore: avoid_unnecessary_containers
                                      builder: (context) => Container(
                                            child: Image(
                                              image: NetworkImage(
                                                  e.catImg.toString()),
                                              fit: BoxFit.cover,
                                            ),
                                          )))
                                  .toList(),
                              options: CarouselOptions(
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  viewportFraction: 1,
                                  initialPage: 0))
                        ],
                      ),
                  error: (error, stack) => Center(
                        child: Text("$error"),
                      ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator())),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.amberAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text('Toy'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          ProductApiResult.when(
              data: (products) => GridView.count(
                    crossAxisCount: 2,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: 0.46,
                    children:
                        products.map((e) => ProductCard(product: e)).toList(),
                  ),
              error: (error, stack) => Center(
                    child: Text("$error"),
                  ),
              loading: () => const Center(child: CircularProgressIndicator())),
        ]))));
  }
}

Future Logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.remove('token');
}
