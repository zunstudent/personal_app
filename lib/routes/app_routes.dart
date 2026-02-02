import 'package:get/get.dart';
import 'package:personal_app/pages/add_post_page.dart';

import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';
import '../bindings/feed_binding.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const profile = '/profile';
  static const addPost = '/add-post';


  static final pages = [
    GetPage(
      name: login,
      page: () => LoginPage(),
    ),
    GetPage(
      name: register,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: home,
      page: () => HomePage(),
      binding: FeedBinding(),
    ),
    GetPage(
      name: profile,
      page: () => ProfilePage(),
    ),
    GetPage(
      name: addPost,
      page: () => AddPostPage(),
),

  ];
}
