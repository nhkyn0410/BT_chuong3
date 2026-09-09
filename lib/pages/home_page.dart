import 'package:flutter/material.dart';

import '../data/movie_data.dart';
import '../pages/movie_detail_page.dart';
import '../theme/app_colors.dart';
import '../widgets/cinema_header.dart';
import '../widgets/movie_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openMovie(BuildContext context, int index) {
    final movie = movies[index];
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => MovieDetailPage(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CinemaHeader(title: 'Movie Explorer'),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxContentWidth = constraints.maxWidth.clamp(
                    0.0,
                    760.0,
                  );
                  final columns = maxContentWidth >= 600 ? 3 : 2;

                  return Center(
                    child: SizedBox(
                      width: maxContentWidth,
                      child: CustomScrollView(
                        slivers: [
                          const SliverPadding(
                            padding: EdgeInsets.fromLTRB(20, 12, 20, 24),
                            sliver: SliverToBoxAdapter(child: _MovieFilters()),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
                            sliver: SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 167 / 338.5,
                                  ),
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final canOpenDetail = index == 0;
                                return MovieCard(
                                  movie: movies[index],
                                  showExploreBadge: canOpenDetail,
                                  onTap: canOpenDetail
                                      ? () => _openMovie(context, index)
                                      : null,
                                );
                              }, childCount: movies.length),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieFilters extends StatelessWidget {
  const _MovieFilters();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: _MoviesCount(),
            ),
          ),
        ),
        SizedBox(width: 8),
        _FilterToggle(),
      ],
    );
  }
}

class _MoviesCount extends StatelessWidget {
  const _MoviesCount();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'POPULAR MOVIES',
          style: TextStyle(
            fontFamily: 'BebasNeue',
            color: AppColors.textWarm,
            fontSize: 20,
            height: 22 / 20,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            '6 FILMS',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              height: 14 / 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterToggle extends StatelessWidget {
  const _FilterToggle();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _FilterChip(label: 'All', selected: true),
          _FilterChip(label: 'Now Playing'),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? AppColors.onPrimary : AppColors.textSecondary,
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.48,
        ),
      ),
    );
  }
}
