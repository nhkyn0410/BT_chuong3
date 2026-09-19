import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/movie.dart';
import '../routes/app_routes.dart';
import '../state/watchlist_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/cast_member_card.dart';
import '../widgets/genre_pill.dart';
import '../widgets/section_header.dart';
import '../widgets/watchlist_button.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key, required this.movie});

  final Movie movie;

  void _addToWatchlist(BuildContext context) {
    WatchlistScope.of(context, listen: false).add(movie);
    Navigator.pushNamed(context, AppRoutes.success, arguments: movie);
  }

  Future<void> _share(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(
      ClipboardData(
        text:
            '${movie.title} (${movie.year}) – ${movie.rating.toStringAsFixed(1)}/10'
            '\n${movie.storyline}',
      ),
    );
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Đã sao chép thông tin phim')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final saved = WatchlistScope.of(context).contains(movie);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết phim'),
        actions: [
          WatchlistButton(movie: movie),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Backdrop(movie: movie),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 164),
                        child: _MovieInformation(movie: movie),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: SafeArea(
              top: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _WatchlistAction(
                      saved: saved,
                      onAdd: () => _addToWatchlist(context),
                      onRemove: () => removeFromWatchlist(context, movie),
                      onShare: () => _share(context),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Backdrop extends StatelessWidget {
  const _Backdrop({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).colorScheme.surface;
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = (constraints.maxWidth * 320 / 390).clamp(280.0, 360.0);
        return SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: movie.heroTag,
                child: ColoredBox(
                  color: AppColors.deepest,
                  child: Image.asset(movie.heroAsset, fit: BoxFit.cover),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      background.withValues(alpha: 0.6),
                      background,
                    ],
                    stops: const [0, 0.55, 1],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _RatingBadge(rating: movie.rating),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight.withValues(alpha: 0.84),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.play_arrow_rounded,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'TRAILER',
                            style: AppTextStyles.overline.copyWith(
                              fontSize: 12,
                              height: 16 / 12,
                              letterSpacing: 0.6,
                              color: AppColors.textWarm,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.deepest.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              height: 18 / 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.28,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            '/ 10',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 16 / 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieInformation extends StatelessWidget {
  const _MovieInformation({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TitleBlock(movie: movie),
        const SizedBox(height: 24),
        SizedBox(
          height: 32,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: movie.genres.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final genre = movie.genres[index];
              return GenrePill(
                label: genre.label,
                highlighted: index == 0,
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.category,
                  arguments: genre,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        _Storyline(storyline: movie.storyline),
        if (movie.cast.isNotEmpty) ...[
          const SizedBox(height: 20),
          _CastSection(movie: movie),
        ],
        const SizedBox(height: 24),
        _ScreeningSchedule(movie: movie),
      ],
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                movie.genres.first.label.toUpperCase(),
                style: AppTextStyles.overline.copyWith(
                  color: colors.primary,
                  letterSpacing: 1,
                ),
              ),
            ),
            Icon(
              Icons.remove_red_eye_outlined,
              size: 16,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              '${movie.viewCount} lượt xem',
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontSize: 12,
                height: 16 / 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          movie.title.toUpperCase(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.display.copyWith(
            color: colors.onSurface,
            fontSize: 48,
            letterSpacing: 2.4,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 8,
          children: [
            _MetaText('${movie.year}', color: colors.onSurface),
            const _MetaDot(),
            _MetaText(movie.duration),
            const _MetaDot(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                movie.certification,
                style: AppTextStyles.overline.copyWith(
                  color: colors.onSurfaceVariant,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            const _MetaDot(),
            _MetaText(movie.presentationFormat, color: colors.tertiary),
          ],
        ),
      ],
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText(this.text, {this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _MetaDot extends StatelessWidget {
  const _MetaDot();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 6,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _Storyline extends StatelessWidget {
  const _Storyline({required this.storyline});

  final String storyline;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(
            title: 'Nội dung phim',
            trailing: Icon(
              Icons.menu_book_outlined,
              size: 18,
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            storyline,
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 14,
              height: 22.75 / 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _CastSection extends StatelessWidget {
  const _CastSection({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Diễn viên & Đạo diễn'),
        const SizedBox(height: 12),
        SizedBox(
          height: 116,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: movie.cast.length,
            separatorBuilder: (context, index) => const SizedBox(width: 4),
            itemBuilder: (context, index) =>
                CastMemberCard(member: movie.cast[index]),
          ),
        ),
      ],
    );
  }
}

const _cinemas = <(String, String, List<String>)>[
  ('Rạp Ngôi Sao', 'Tầng 5, Trung tâm thương mại', ['10:00', '13:30', '19:45']),
  ('Rạp Ánh Trăng', 'Số 12, đường Hoa Sữa', ['09:15', '16:00', '21:30']),
  ('Rạp Bình Minh', 'Khu đô thị Bình Minh', ['11:20', '18:10', '22:00']),
];

class _ScreeningSchedule extends StatelessWidget {
  const _ScreeningSchedule({required this.movie});

  final Movie movie;

  void _showTimes(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          children: [
            Text(
              'Suất chiếu hôm nay – ${movie.title}',
              style: Theme.of(sheetContext).textTheme.titleMedium,
            ),
            for (final (name, address, times) in _cinemas) ...[
              const SizedBox(height: 16),
              Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(
                address,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(sheetContext).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final time in times)
                    ActionChip(
                      label: Text(time),
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        messenger
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text('Đã chọn suất $time tại $name'),
                            ),
                          );
                      },
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surfaceContainer,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showTimes(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.confirmation_number_outlined,
                  size: 18,
                  color: colors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lịch chiếu',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 14,
                        height: 20 / 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${_cinemas.length} rạp gần bạn',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 12,
                        height: 16 / 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Xem suất chiếu',
                  style: TextStyle(
                    color: colors.tertiary,
                    fontSize: 12,
                    height: 16 / 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.48,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WatchlistAction extends StatelessWidget {
  const _WatchlistAction({
    required this.saved,
    required this.onAdd,
    required this.onRemove,
    required this.onShare,
  });

  final bool saved;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: 60,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x55000000),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: saved
                ? FilledButton.tonalIcon(
                    onPressed: onRemove,
                    icon: const Icon(Icons.bookmark_remove_outlined, size: 18),
                    label: const Text('Bỏ khỏi danh sách'),
                  )
                : FilledButton.icon(
                    onPressed: onAdd,
                    icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                    label: const Text('Thêm vào danh sách xem'),
                  ),
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(
            tooltip: 'Sao chép thông tin phim',
            onPressed: onShare,
            icon: Icon(Icons.share_outlined, size: 18, color: colors.onSurface),
          ),
        ],
      ),
    );
  }
}
