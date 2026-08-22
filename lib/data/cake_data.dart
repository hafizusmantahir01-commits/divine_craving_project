import '../models/cake_model.dart';

class CakeData {
  CakeData._();

  static const List<CakeModel> cakes = [
    CakeModel(
      id: '1',
      name: 'Chocolate Dream',
      category: 'Birthday',
      image:
          'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=900',
      price: 2500,
      rating: 4.8,
      reviews: 120,
      description:
          'A rich chocolate cake layered with smooth chocolate cream and premium chocolate ganache.',
    ),

    CakeModel(
      id: '2',
      name: 'Red Velvet',
      category: 'Birthday',
      image:
          'https://images.unsplash.com/photo-1586788224331-947f68671cf1?w=900',
      price: 2800,
      rating: 4.9,
      reviews: 98,
      description:
          'Soft red velvet sponge with creamy frosting and a delicious classic taste.',
    ),

    CakeModel(
      id: '3',
      name: 'Strawberry Delight',
      category: 'Anniversary',
      image:
          'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=900',
      price: 3000,
      rating: 4.8,
      reviews: 87,
      description:
          'Fresh strawberry cake decorated with beautiful cream and strawberries.',
    ),

    CakeModel(
      id: '4',
      name: 'Butterscotch Bliss',
      category: 'Wedding',
      image:
          'https://images.unsplash.com/photo-1602351447937-745cb720612f?w=900',
      price: 3200,
      rating: 4.7,
      reviews: 64,
      description:
          'A creamy butterscotch cake with caramel crunch and premium decoration.',
    ),

    CakeModel(
      id: '5',
      name: 'Black Forest',
      category: 'Birthday',
      image:
          'https://images.unsplash.com/photo-1571115177098-24ec42ed204d?w=900',
      price: 2700,
      rating: 4.6,
      reviews: 73,
      description:
          'Classic black forest cake with chocolate sponge, cherries and fresh cream.',
    ),

    CakeModel(
      id: '6',
      name: 'Custom Celebration',
      category: 'Custom',
      image: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=900',
      price: 3500,
      rating: 4.9,
      reviews: 51,
      description:
          'Create a beautiful custom cake according to your special occasion.',
    ),
  ];
}
