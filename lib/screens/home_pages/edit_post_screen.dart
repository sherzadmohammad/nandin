import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanden/models/meal_data.dart';
import 'package:nanden/providers/post_provider.dart';
import 'package:nanden/providers/user_provider.dart';
import 'package:nanden/utils/toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

class AddEditMealPostScreen extends ConsumerStatefulWidget {
  final Post? post; // Optional post for editing mode
  
  const AddEditMealPostScreen({super.key, this.post});

  @override
  ConsumerState<AddEditMealPostScreen> createState() => _AddEditMealPostScreenState();
}

class _AddEditMealPostScreenState extends ConsumerState<AddEditMealPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _videoUrlController = TextEditingController();
  final _cuisineController = TextEditingController();
  final _tagsController = TextEditingController();
  final _descriptionController = TextEditingController();


  int _duration = 30;
  String _complexity = 'Simple';
  String _affordability = 'Affordable';
  bool _isPublic = true;
  File? _imageFile;
  final List<TextEditingController> _ingredientControllers = [TextEditingController()];
  final List<TextEditingController> _stepControllers = [TextEditingController()];
  
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Fill fields if editing an existing post
    if (widget.post != null) {
      _titleController.text = widget.post!.title;
      _imageUrlController.text = widget.post!.imageUrl;
      _videoUrlController.text = widget.post!.videoUrl ?? '';
      _cuisineController.text = widget.post!.cuisine;
      _tagsController.text = widget.post!.tags?.join(', ') ?? '';
      
      _duration = widget.post!.duration;
      _complexity = widget.post!.complexity;
      _affordability = widget.post!.affordability;
      _isPublic = widget.post!.isPublic;
      
      // Set up ingredient controllers
      _ingredientControllers.clear();
      for (final ingredient in widget.post!.ingredients) {
        _ingredientControllers.add(TextEditingController(text: ingredient));
      }
      if (_ingredientControllers.isEmpty) {
        _ingredientControllers.add(TextEditingController());
      }
      
      // Set up step controllers
      _stepControllers.clear();
      for (final step in widget.post!.steps) {
        _stepControllers.add(TextEditingController(text: step));
      }
      if (_stepControllers.isEmpty) {
        _stepControllers.add(TextEditingController());
      }
    }
  }

Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null;

    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(_imageFile!.path)}';
      
      await Supabase.instance.client.storage.from('post_cover_images').upload(fileName, _imageFile!);
      
      // Get the public URL
      final imageUrl = Supabase.instance.client.storage
          .from('post_cover_images')
          .getPublicUrl(fileName);
          
      return imageUrl;
    } catch (e) {
      if(mounted){
        showToast(context: context, message: 'Failed tooo upload image: $e');
      }
      return null;
    }
  }

  @override
  void dispose() {
    _cuisineController.dispose();
    _titleController.dispose();
    _tagsController.dispose();
    _imageUrlController.dispose();
    _videoUrlController.dispose();
    for(int i=0;i<_ingredientControllers.length;i++){
      _ingredientControllers[i].dispose();
    }
    for(int i=0;i<_stepControllers.length;i++){
      _stepControllers[i].dispose();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post == null ? 'Add New Recipe' : 'Edit Recipe'),
        actions: [
          if (_isSubmitting)
            const Center(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            )),
          if (!_isSubmitting)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _submitPost,
              tooltip: 'Save Recipe',
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),

          children: [
            // Basic info section
            _buildSectionHeader('Basic Information'),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _imageFile!,
                          fit: BoxFit.fill,
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.add_a_photo,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Recipe Title',
                hintText: 'Enter a descriptive title',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16,),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Recipe Description',
                hintText: 'Enter a description...',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),    
            const SizedBox(height: 16),
            TextFormField(
              controller: _videoUrlController,
              decoration: const InputDecoration(
                labelText: 'Video URL (optional)',
                hintText: 'Enter URL for a video tutorial',
              ),
            ),
            
            // Cuisine and tags
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _cuisineController,
                    decoration: const InputDecoration(
                      labelText: 'Cuisine',
                      hintText: 'e.g., Italian, Mexican',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter cuisine';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    initialValue: _duration.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Duration (min)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Must be a number';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        _duration = int.parse(value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags (comma separated)',
                hintText: 'e.g., vegetarian, dinner, quick',
              ),
            ),
            
            // Complexity and affordability
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _complexity,
                    decoration: const InputDecoration(
                      labelText: 'Complexity',
                    ),
                    items: ['Simple', 'Challenging', 'Hard']
                        .map((label) => DropdownMenuItem(
                              value: label,
                              child: Text(label),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _complexity = value;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _affordability,
                    decoration: const InputDecoration(
                      labelText: 'Affordability',
                    ),
                    items: ['Affordable', 'Pricey', 'Luxurious']
                        .map((label) => DropdownMenuItem(
                              value: label,
                              child: Text(label),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _affordability = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            
            // Visibility toggle
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Public Recipe'),
              subtitle: const Text('Make this recipe visible to everyone'),
              value: _isPublic,
              onChanged: (value) => setState(() => _isPublic = value),
            ),
            
            // Ingredients section
            const SizedBox(height: 24),
            _buildSectionHeader('Ingredients'),
            ..._buildIngredientFields(),
            OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Ingredient'),
              onPressed: _addIngredientField,
            ),
            
            // Steps section
            const SizedBox(height: 24),
            _buildSectionHeader('Preparation Steps'),
            ..._buildStepFields(),
            OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Step'),
              onPressed: _addStepField,
            ),
            
            // Bottom padding
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  List<Widget> _buildIngredientFields() {
    return List.generate(_ingredientControllers.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _ingredientControllers[index],
                decoration: InputDecoration(
                  labelText: 'Ingredient ${index + 1}',
                  hintText: 'e.g., 2 cups flour',
                ),
                validator: (value) {
                  if (index == 0 && (value == null || value.isEmpty)) {
                    return 'Please enter at least one ingredient';
                  }
                  return null;
                },
              ),
            ),
            if (_ingredientControllers.length > 1)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _removeIngredientField(index),
              ),
          ],
        ),
      );
    });
  }
  
  List<Widget> _buildStepFields() {
    return List.generate(_stepControllers.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: CircleAvatar(
                radius: 12,
                child: Text('${index + 1}')
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _stepControllers[index],
                decoration: InputDecoration(
                  labelText: 'Step ${index + 1}',
                  hintText: 'Describe this step...',
                ),
                maxLines: 3,
                validator: (value) {
                  if (index == 0 && (value == null || value.isEmpty)) {
                    return 'Please enter at least one step';
                  }
                  return null;
                },
              ),
            ),
            if (_stepControllers.length > 1)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _removeStepField(index),
              ),
          ],
        ),
      );
    });
  }
  
  void _addIngredientField() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
    });
  }
  
  void _removeIngredientField(int index) {
    setState(() {
      _ingredientControllers[index].dispose();
      _ingredientControllers.removeAt(index);
    });
  }
  
  void _addStepField() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }
  
  void _removeStepField(int index) {
    setState(() {
      _stepControllers[index].dispose();
      _stepControllers.removeAt(index);
    });
  }

  void _submitPost() async {
    if (_formKey.currentState?.validate() != true) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors in the form')),
      );
      return;
    }
    final imageUrl= await _uploadImage();
    if(imageUrl ==null)return;

    setState(() => _isSubmitting = true);
    
    final currentUser = ref.read(userProvider).asData?.value;

    final tags = _tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
    
    final ingredients = _ingredientControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();
    
    final steps = _stepControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();
    
    try {
      if (widget.post == null) {
        // Create new post
        final newPost = Post(
          userId: currentUser!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          imageUrl: imageUrl,
          videoUrl: _videoUrlController.text.isEmpty ? null : _videoUrlController.text.trim(),
          ingredients: ingredients,
          steps: steps,
          duration: _duration,
          complexity: _complexity,
          affordability: _affordability,
          likeCount: 0,
          commentCount: 0,
          savedCount: 0,
          cuisine: _cuisineController.text.trim(),
          createdAt: DateTime.now(),
          isPublic: _isPublic,
          tags: tags,
        );
        
        final createdPost = await ref.read(mealPostsProvider.notifier).createPost(newPost, tags);
        
        if (createdPost != null && mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recipe created successfully')),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create recipe')),
          );
          setState(() => _isSubmitting = false);
        }
      } else {
        // Update existing post
        final updatedPost = Post(
          id: widget.post!.id!,
          userId: widget.post!.userId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          imageUrl: _imageUrlController.text.trim(),
          videoUrl: _videoUrlController.text.isEmpty ? null : _videoUrlController.text.trim(),
          ingredients: ingredients,
          steps: steps,
          duration: _duration,
          complexity: _complexity,
          affordability: _affordability,
          likeCount: widget.post!.likeCount,
          commentCount: widget.post!.commentCount,
          savedCount: widget.post!.savedCount,
          cuisine: _cuisineController.text.trim(),
          createdAt: widget.post!.createdAt,
          isPublic: _isPublic,
          tags: tags,
        );
        
        final result = await ref.read(mealPostsProvider.notifier).updatePost(updatedPost, tags);
        
        if (result != null && mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recipe updated successfully')),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update recipe')),
          );
          setState(() => _isSubmitting = false);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() => _isSubmitting = false);
      }
    }
  }
}