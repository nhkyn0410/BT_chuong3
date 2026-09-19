import '../models/movie.dart';
import '../models/movie_category.dart';

const _inceptionCast = <CastMember>[
  CastMember(
    name: 'C. Nolan',
    role: 'Đạo diễn',
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
    id: 'inception',
    title: 'Inception',
    year: 2010,
    rating: 8.8,
    genres: [
      MovieCategory.sciFi,
      MovieCategory.action,
      MovieCategory.adventure,
      MovieCategory.mystery,
    ],
    posterAsset: 'assets/images/poster_inception.png',
    heroAsset: 'assets/images/detail_inception.png',
    homeHint: 'Siêu phẩm của Nolan',
    duration: '148 phút',
    certification: 'T13',
    presentationFormat: 'IMAX 70mm',
    viewCount: '2,4 triệu',
    storyline:
        'Dom Cobb là kẻ trộm chuyên đánh cắp bí mật từ tiềm thức khi con người '
        'đang mơ. Để được trở về với gia đình, anh nhận một nhiệm vụ ngược lại: '
        'cấy một ý tưởng vào tâm trí người thừa kế của một tập đoàn lớn. Nhưng '
        'quá khứ đau buồn của Cobb có thể đẩy cả nhóm vào thảm họa.',
    cast: _inceptionCast,
  ),
  Movie(
    id: 'interstellar',
    title: 'Interstellar',
    year: 2014,
    rating: 8.7,
    genres: [MovieCategory.sciFi, MovieCategory.drama, MovieCategory.adventure],
    posterAsset: 'assets/images/poster_interstellar.png',
    heroAsset: 'assets/images/poster_interstellar.png',
    homeHint: 'Công chiếu IMAX',
    duration: '169 phút',
    certification: 'T13',
    presentationFormat: 'IMAX',
    viewCount: '2,1 triệu',
    storyline:
        'Khi Trái Đất dần cạn kiệt sự sống, một nhóm nhà du hành vượt qua hố '
        'giun để tìm kiếm ngôi nhà mới cho nhân loại.',
  ),
  Movie(
    id: 'dark-knight',
    title: 'The Dark Knight',
    year: 2008,
    rating: 9.0,
    genres: [MovieCategory.action, MovieCategory.crime, MovieCategory.drama],
    posterAsset: 'assets/images/poster_dark_knight.png',
    heroAsset: 'assets/images/poster_dark_knight.png',
    homeHint: 'Điểm cao nhất',
    duration: '152 phút',
    certification: 'T13',
    presentationFormat: 'IMAX',
    viewCount: '3,2 triệu',
    storyline:
        'Batman đối đầu với Joker, kẻ chủ mưu gieo rắc hỗn loạn khắp Gotham và '
        'đẩy những người bảo vệ thành phố đến giới hạn cuối cùng.',
  ),
  Movie(
    id: 'endgame',
    title: 'Avengers: Endgame',
    year: 2019,
    rating: 8.5,
    genres: [
      MovieCategory.action,
      MovieCategory.sciFi,
      MovieCategory.adventure,
    ],
    posterAsset: 'assets/images/endgame.jpg',
    heroAsset: 'assets/images/endgame.jpg',
    homeHint: 'Bom tấn',
    duration: '181 phút',
    certification: 'T13',
    presentationFormat: 'IMAX',
    viewCount: '2,8 triệu',
    storyline:
        'Sau cú búng tay của Thanos, các Avengers còn lại tập hợp một lần cuối '
        'để đảo ngược thảm họa và cứu lấy vũ trụ.',
  ),
  Movie(
    id: 'oppenheimer',
    title: 'Oppenheimer',
    year: 2023,
    rating: 8.9,
    genres: [MovieCategory.biography, MovieCategory.drama],
    posterAsset: 'assets/images/poster_oppenheimer.png',
    heroAsset: 'assets/images/poster_oppenheimer.png',
    homeHint: 'Đoạt giải Oscar',
    duration: '180 phút',
    certification: 'T18',
    presentationFormat: 'IMAX 70mm',
    viewCount: '1,9 triệu',
    storyline:
        'Câu chuyện về nhà vật lý J. Robert Oppenheimer và vai trò của ông '
        'trong việc chế tạo quả bom nguyên tử đầu tiên của thế giới.',
  ),
  Movie(
    id: 'spider-verse',
    title: 'Spider-Man: Verse',
    year: 2018,
    rating: 8.4,
    genres: [
      MovieCategory.animation,
      MovieCategory.action,
      MovieCategory.adventure,
    ],
    posterAsset: 'assets/images/spiderver.jpg',
    heroAsset: 'assets/images/spiderver.jpg',
    homeHint: 'Hoạt hình xuất sắc',
    duration: '117 phút',
    certification: 'P',
    presentationFormat: 'Dolby Cinema',
    viewCount: '1,7 triệu',
    storyline:
        'Cậu thiếu niên Miles Morales trở thành Người Nhện và phát hiện những '
        'người hùng đến từ các vũ trụ khác cũng sở hữu sức mạnh giống mình.',
  ),
];

List<Movie> moviesIn(MovieCategory category) =>
    movies.where((movie) => movie.genres.contains(category)).toList();
