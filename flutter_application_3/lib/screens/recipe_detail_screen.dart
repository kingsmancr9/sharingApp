import 'package:flutter/material.dart';
import 'add_recipe_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;
  final int recipeIndex;
  const RecipeDetailScreen({required this.recipe, required this.recipeIndex, Key? key}) : super(key: key);

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late int likeCount;
  bool isLiked = false;
  late Map<String, dynamic> recipe;

  @override
  void initState() {
    super.initState();
    recipe = Map<String, dynamic>.from(widget.recipe);
    likeCount = recipe['likes'] ?? 0;
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
  }

  Future<void> _editRecipe() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddRecipeScreen(
          recipe: recipe,
          recipeIndex: widget.recipeIndex,
        ),
      ),
    );
    if (result != null && result['recipe'] != null) {
      setState(() {
        recipe = {
          ...recipe,
          ...result['recipe'],
        };
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe updated!')),
      );
    }
  }

  void _deleteRecipe() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: const Text('Are you sure you want to delete this recipe?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      Navigator.of(context).pop({'delete': true, 'index': widget.recipeIndex});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['title'] ?? 'Recipe Details'),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image placeholder
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [recipe['color'] ?? Colors.orange, Colors.orangeAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(
                  recipe['icon'] ?? Icons.restaurant,
                  color: Colors.white,
                  size: 64,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              recipe['title'] ?? '',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'By: ${recipe['author']} • ${recipe['time']}',
              style: const TextStyle(color: Colors.black54, fontSize: 15),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    size: 28,
                  ),
                  onPressed: _toggleLike,
                ),
                const SizedBox(width: 6),
                Text('$likeCount', style: const TextStyle(fontSize: 16)),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _editRecipe,
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _deleteRecipe,
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              recipe['description'] ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (recipe['ingredients'] != null && recipe['ingredients'] is List)
              ...List<Widget>.from((recipe['ingredients'] as List).map((ingredient) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 8, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(child: Text(ingredient.toString())),
                  ],
                ),
              ))),
            if (recipe['ingredients'] == null || (recipe['ingredients'] is List && recipe['ingredients'].isEmpty))
              const Text('No ingredients listed.'),
          ],
        ),
      ),
    );
  }
}
