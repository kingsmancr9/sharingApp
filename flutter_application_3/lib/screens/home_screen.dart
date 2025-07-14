import 'package:flutter/material.dart';
import 'recipe_detail_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> recipes = [
    {
      'title': 'Spaghetti Carbonara',
      'author': 'Chef Maria',
      'time': '25 minutes',
      'description': 'Creamy Italian pasta with eggs, cheese, and bacon...',
      'likes': 24,
      'icon': Icons.ramen_dining,
      'color': Colors.orange,
      'ingredients': ['200g spaghetti', '2 eggs', '100g bacon', '50g cheese', 'Salt', 'Pepper'],
    },
    {
      'title': 'Margherita Pizza',
      'author': 'Chef Luigi',
      'time': '40 minutes',
      'description': 'Classic pizza with tomato, mozzarella, and basil...',
      'likes': 18,
      'icon': Icons.local_pizza,
      'color': Colors.deepOrange,
      'ingredients': ['Pizza dough', 'Tomato sauce', 'Mozzarella', 'Basil', 'Olive oil'],
    },
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Filter recipes by search query (title or author)
    final filteredRecipes = recipes.where((recipe) {
      final query = searchQuery.toLowerCase();
      return recipe['title'].toLowerCase().contains(query) ||
          recipe['author'].toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = filteredRecipes[index];
                final recipeIndex = recipes.indexOf(recipe);
                return Card(
                  margin: const EdgeInsets.only(bottom: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipe image placeholder with icon and gradient
                      Container(
                        height: 110,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                          gradient: LinearGradient(
                            colors: [recipe['color'], Colors.orangeAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(recipe['icon'], color: Colors.white, size: 32),
                              const SizedBox(width: 10),
                              Text(
                                recipe['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'By: ${recipe['author']} • ${recipe['time']}',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              recipe['description'],
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.favorite, color: Colors.red, size: 18),
                                const SizedBox(width: 4),
                                Text('${recipe['likes']}'),
                                const Spacer(),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RecipeDetailScreen(
                                          recipe: recipe,
                                          recipeIndex: recipeIndex,
                                        ),
                                      ),
                                    );
                                    if (result != null && result['delete'] == true && result['index'] != null) {
                                      setState(() {
                                        recipes.removeAt(result['index']);
                                      });
                                    }
                                  },
                                  child: const Text('View Recipe'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}