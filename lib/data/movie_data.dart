import '../models/movie.dart';

const _inceptionCast = <CastMember>[
  CastMember(
    name: 'C. Nolan',
    role: 'Director',
    imageAsset: 'assets/images/cast_nolan.png',
  ),
  CastMember(
    name: 'L. DiCaprio',
    role: 'Cobb',
    imageAsset: 'assets/images/cast_dicaprio.png',
  ),
  CastMember(
    name: 'J. Gordon-Levitt',
    role: 'Arthur',
    imageAsset: 'assets/images/cast_gordon_levitt.png',
  ),
  CastMember(
    name: 'Elliot Page',
    role: 'Ariadne',
    imageAsset: 'assets/images/cast_elliot_page.png',
  ),
];

const movies = <Movie>[
  Movie(
    title: 'Inception',
    year: 2010,
    rating: 8.8,
    genres: ['Sci-Fi', 'Action', 'Adventure', 'Mystery'],
    posterAsset: 'assets/images/poster_inception.png',
    heroAsset: 'assets/images/detail_inception.png',
    homeHint: 'Tap for details',
    duration: '2h 28m',
    certification: 'PG-13',
    presentationFormat: 'IMAX 70mm',
    viewCount: '2.4M',
    storyline:
        'A thief who steals corporate secrets through the use of dream-sharing '
        'technology is given the inverse task of planting an idea into the mind '
        'of a C.E.O., but his tragic past may doom the project and his team to '
        'disaster.',
    cast: _inceptionCast,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    rating: 8.7,
    genres: ['Sci-Fi', 'Drama'],
    posterAsset: 'assets/images/poster_interstellar.png',
    heroAsset: 'assets/images/poster_interstellar.png',
    homeHint: 'IMAX Premiere',
    duration: '2h 49m',
    certification: 'PG-13',
    presentationFormat: 'IMAX',
    viewCount: '2.1M',
    storyline:
        'Explorers travel through a wormhole in space in an attempt to ensure '
        'humanity\'s survival.',
  ),
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    rating: 9.0,
    genres: ['Action', 'Crime'],
    posterAsset: 'assets/images/poster_dark_knight.png',
    heroAsset: 'assets/images/poster_dark_knight.png',
    homeHint: 'Top Rated',
    duration: '2h 32m',
    certification: 'PG-13',
    presentationFormat: 'IMAX',
    viewCount: '3.2M',
    storyline:
        'Batman faces a criminal mastermind whose reign of chaos pushes Gotham '
        'and its heroes to their limits.',
  ),
  Movie(
    title: 'Avengers: Endgame',
    year: 2019,
    rating: 8.5,
    genres: ['Action', 'Sci-Fi'],
    posterAsset: 'assets/images/endgame.jpg',
    heroAsset: 'assets/images/endgame.jpg',
    homeHint: 'Blockbuster',
    duration: '3h 01m',
    certification: 'PG-13',
    presentationFormat: 'IMAX',
    viewCount: '2.8M',
    storyline:
        'The remaining Avengers assemble once more to reverse the damage caused '
        'by Thanos and restore the universe.',
  ),
  Movie(
    title: 'Oppenheimer',
    year: 2023,
    rating: 8.9,
    genres: ['Biography', 'Drama'],
    posterAsset: 'assets/images/poster_oppenheimer.png',
    heroAsset: 'assets/images/poster_oppenheimer.png',
    homeHint: 'Award Winner',
    duration: '3h 00m',
    certification: 'R',
    presentationFormat: 'IMAX 70mm',
    viewCount: '1.9M',
    storyline:
        'The story of J. Robert Oppenheimer and his role in developing the '
        'world\'s first atomic weapon.',
  ),
  Movie(
    title: 'Spider-Man: Verse',
    year: 2018,
    rating: 8.4,
    genres: ['Animation', 'Action'],
    posterAsset: 'assets/images/spiderver.jpg',
    heroAsset: 'assets/images/spiderver.jpg',
    homeHint: 'Animation Choice',
    duration: '1h 57m',
    certification: 'PG',
    presentationFormat: 'Dolby Cinema',
    viewCount: '1.7M',
    storyline:
        'Miles Morales becomes Spider-Man and discovers that heroes from other '
        'dimensions share his extraordinary powers.',
  ),
];
