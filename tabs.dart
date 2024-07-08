import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/screens/categories.dart';
import 'package:recipe_app/screens/filters.dart';
import 'package:recipe_app/screens/meals.dart';
import 'package:recipe_app/widgets/main_drawer.dart';
import 'package:recipe_app/provider/favourite_provider.dart';
import 'package:recipe_app/provider/filter_provider.dart';

const kinitialfilters = {
  Filter.glutinFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreen();
  }
}

class _TabsScreen extends ConsumerState<TabsScreen> {
  int _selectedpageindex = 0;

  void _selectpage(int index) {
    setState(() {
      _selectedpageindex = index;
    });
  }

  void _setscreen(String indetifier) async {
    Navigator.of(context).pop();
    if (indetifier == 'Filters') {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(FilteredMealProvider);
    Widget activepage = CategoriesScreen(
      availableMeal: availableMeals,
    );
    var activepagetitle = 'Categories';
    if (_selectedpageindex == 1) {
      final favouritemeals = ref.watch(favouriteMealProvider);
      activepage = Mealsscreen(
        meals: favouritemeals,
      );
      activepagetitle = 'Favourites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activepagetitle),
      ),
      drawer: MainDrawer(onselectscreen: _setscreen),
      body: activepage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedpageindex,
        onTap: _selectpage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favourites',
          ),
        ],
      ),
    );
  }
}
