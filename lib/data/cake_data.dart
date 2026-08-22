import '../models/cake_model.dart';

class CakeData {
  CakeData._();

  static const List<CakeModel> cakes = [
    // ==========================================================
    // 1. CHOCOLATE CAKE
    // ==========================================================

    CakeModel(
      id: '1',
      name: 'Chocolate Dream',
      category: 'Birthday',
      image: 'assets/images/cakes/chocolate_dream.jpg',
      price: 2500,
      rating: 4.8,
      reviews: 120,
      description:
          'A rich chocolate cake layered with smooth chocolate cream and premium chocolate ganache.',
    ),

    // ==========================================================
    // 2. RED VELVET
    // ==========================================================

    CakeModel(
      id: '2',
      name: 'Red Velvet',
      category: 'Birthday',
      image: 'assets/images/cakes/red_velvet.jpg',
      price: 2800,
      rating: 4.9,
      reviews: 98,
      description:
          'Soft red velvet sponge with creamy frosting and a delicious classic taste.',
    ),

    // ==========================================================
    // 3. STRAWBERRY
    // ==========================================================

    CakeModel(
      id: '3',
      name: 'Strawberry Delight',
      category: 'Anniversary',
      image: 'assets/images/cakes/strawberry_delight.jpg',
      price: 3000,
      rating: 4.8,
      reviews: 87,
      description:
          'Fresh strawberry cake decorated with beautiful cream and strawberries.',
    ),

    // ==========================================================
    // 4. BUTTERSCOTCH
    // ==========================================================

    CakeModel(
      id: '4',
      name: 'Butterscotch Bliss',
      category: 'Wedding',
      image: 'assets/images/cakes/butterscotch_bliss.jpg',
      price: 3200,
      rating: 4.7,
      reviews: 64,
      description:
          'A creamy butterscotch cake with caramel crunch and premium decoration.',
    ),

    // ==========================================================
    // 5. BLACK FOREST
    // ==========================================================

    CakeModel(
      id: '5',
      name: 'Black Forest',
      category: 'Birthday',
      image: 'assets/images/cakes/black_forest.jpg',
      price: 2700,
      rating: 4.6,
      reviews: 73,
      description:
          'Classic black forest cake with chocolate sponge, cherries and fresh cream.',
    ),

    // ==========================================================
    // 6. CUSTOM CELEBRATION
    // ==========================================================

    CakeModel(
      id: '6',
      name: 'Custom Celebration',
      category: 'Custom',
      image: 'assets/images/cakes/custom_celebration.jpg',
      price: 3500,
      rating: 4.9,
      reviews: 51,
      description:
          'Create a beautiful custom cake according to your special occasion.',
    ),
  ];
}