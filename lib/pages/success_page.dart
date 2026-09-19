import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/movie.dart';
import '../state/shell_controller.dart';
import '../theme/app_text_styles.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key, required this.movie});

  final Movie movie;

  /// Quay về màn hình gốc (MainShell) rồi chuyển sang [tab].
  void _finish(BuildContext context, AppTab tab) {
    ShellScope.of(context, listen: false).select(tab);
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: const Alignment(0.45, -0.12),
                            radius: 0.72,
                            colors: [
                              colors.primary.withValues(alpha: 0.16),
                              colors.surface.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 390),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _SuccessStatusBar(),
                              const SizedBox(height: 30),
                              const _SuccessBadge(),
                              const SizedBox(height: 14),
                              Text(
                                'ĐÃ THÊM VÀO DANH SÁCH!',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.heading.copyWith(
                                  color: colors.onSurface,
                                  fontSize: 24,
                                  height: 30 / 24,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Phim đã được lưu vào danh sách xem sau.\n'
                                'Bạn có thể xem lại bất cứ lúc nào ở tab '
                                '"Xem sau".',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 14,
                                  height: 22.75 / 14,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Center(child: _MovieRecap(movie: movie)),
                              const SizedBox(height: 24),
                              SizedBox(
                                height: 56,
                                child: FilledButton.icon(
                                  onPressed: () =>
                                      _finish(context, AppTab.watchlist),
                                  icon: const Icon(
                                    Icons.bookmark_rounded,
                                    size: 18,
                                  ),
                                  label: const Text('XEM DANH SÁCH XEM SAU'),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 56,
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      _finish(context, AppTab.home),
                                  icon: const Icon(
                                    Icons.home_outlined,
                                    size: 18,
                                  ),
                                  label: const Text('VỀ TRANG CHỦ'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SuccessStatusBar extends StatelessWidget {
  const _SuccessStatusBar();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHigh.withValues(alpha: 0.62),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.theaters_outlined, size: 15, color: colors.primary),
              const SizedBox(width: 8),
              Text(
                'MOVIE EXPLORER',
                style: AppTextStyles.overline.copyWith(
                  color: colors.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: colors.surfaceContainer.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.done_all_rounded, size: 14, color: colors.primary),
              const SizedBox(width: 4),
              Text(
                'ĐÃ ĐỒNG BỘ',
                style: AppTextStyles.overline.copyWith(
                  color: colors.primary,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SuccessBadge extends StatelessWidget {
  const _SuccessBadge();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 192,
      child: Center(
        child: SizedBox.square(
          dimension: 192,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Lottie.asset(
                'assets/animations/success.json',
                width: 192,
                height: 192,
                fit: BoxFit.contain,
                repeat: false,
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primary,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x40000000),
                      blurRadius: 28,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 40,
                  color: colors.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MovieRecap extends StatelessWidget {
  const _MovieRecap({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: Image.asset(
                movie.posterAsset,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              movie.title,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 14,
                height: 20 / 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${movie.year})',
              style: TextStyle(
                color: colors.outline,
                fontSize: 12,
                height: 16 / 12,
              ),
            ),
            const SizedBox(width: 10),
            SizedBox.square(
              dimension: 4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.outline,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.star_rounded, size: 14, color: colors.primary),
            const SizedBox(width: 4),
            Text(
              movie.rating.toStringAsFixed(1),
              style: TextStyle(
                color: colors.primary,
                fontSize: 12,
                height: 16 / 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.48,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
