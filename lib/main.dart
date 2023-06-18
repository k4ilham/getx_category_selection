import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const GetMaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text("Interactive categories")),
        body: Column(
          children: [
            CategoryFilter(),
            Container(
              color: Colors.green,
              height: 2,
            ),
            SelectedCategories()
          ],
        ),
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class CategoryFilter extends StatelessWidget {
  final controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Obx(
        () => ListView.builder(
          itemCount: controller.categories.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              value: controller.selectedCategories
                  .contains(controller.categories[index]),
              onChanged: (bool? selected) =>
                  controller.toggle(controller.categories[index]),
              title: CategoryWidget(category: controller.categories[index]),
            );
          },
        ),
      ),
    );
  }
}

class SelectedCategories extends StatelessWidget {
  final Controller controller = Get.find();

  SelectedCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Obx(
        () => ListView.builder(
          itemCount: controller.selectedCategories.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CategoryWidget(
                category: controller.selectedCategories[index],
              ),
            );
          },
        ),
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final Category category;

  const CategoryWidget({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      category.name,
      style: TextStyle(color: category.color),
    );
  }
}

class Controller extends GetxController {
  // ignore: prefer_final_fields
  var _categories = {
    Category("Apple", Colors.red): false,
    Category("Orange", Colors.orange): false,
    Category("Banana", Colors.yellow): false,
  }.obs;

  void toggle(Category item) {
    _categories[item] = !(_categories[item] ?? true);
  }

  get selectedCategories =>
      _categories.entries.where((e) => e.value).map((e) => e.key).toList();

  get categories => _categories.entries.map((e) => e.key).toList();
}

class Category {
  final String name;
  final Color color;

  Category(this.name, this.color);
}
