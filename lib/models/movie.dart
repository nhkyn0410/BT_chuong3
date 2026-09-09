class CastMember {
  const CastMember({
    required this.name,
    required this.role,
    required this.imageAsset,
  });

  final String name;
  final String role;
  final String imageAsset;
}

class Movie {
  const Movie({
    required this.title,
    required this.year,
    required this.rating,
    required this.genres,
    required this.posterAsset,
    required this.heroAsset,
    required this.homeHint,
    required this.duration,
    required this.certification,
    required this.presentationFormat,
    required this.viewCount,
    required this.storyline,
    this.cast = const [],
  });

  final String title;
  final int year;
  final double rating;
  final List<String> genres;
  final String posterAsset;
  final String heroAsset;
  final String homeHint;
  final String duration;
  final String certification;
  final String presentationFormat;
  final String viewCount;
  final String storyline;
  final List<CastMember> cast;

  String get genreLabel => genres.take(2).join(' • ');
}
