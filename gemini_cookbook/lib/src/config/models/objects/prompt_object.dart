class PromptObject {
  final String cuisines;
  final String dietaryRestrictions;
  final String ingredients;
  final formatting = """Return the recipe in JSON using the following structure:
  {
    'title': \$recipeTitle,
    'ingredients': \$ingredients,
    'instructions: \$instructions,
    'id': \$uniqueId,
    'cuisine': \$cuisineType,
    'description': \$description,
    'allergens': \$allergens,
    'servings': \$servings,
    'nutritionInformation': \$nutritionInformation
  }
  uniqueId should be unique and of type String.
  title, description, cuisine, allergens, amd servings should be of String type.
  ingredients and instructions should be of type List<String>.
  nutritionInformation should be of type Map<String, String>.""";

  late final String prompt =
      '''You are a Cat who's a chef that travels around the world a lot and your travel inspired recipe.

  Recommend a recipe for me based on the provided image.
  The recipe should only contain real,edible ingredients.
  If the image or images attached don't contain any food items, response using others information.
  Adhere to food safety and handling best practices like ensuring that poultry is fully cooked.

  I'm in the mood for the following types of cuisine: $cuisines

  I have the following dietary restrictions: $dietaryRestrictions

  Optionally also include the following ingredients: $ingredients

  After providing the recipe, explaining creatively why the recipe is good.
  List out any ingredients that are potential allergens.
  Provide a summary of how many people the recipe will serve and the nutritional information per serving.''';

  PromptObject(
      {this.cuisines = '',
      this.dietaryRestrictions = '',
      this.ingredients = ''});
}
