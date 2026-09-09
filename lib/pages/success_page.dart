import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/movie.dart';
import '../theme/app_colors.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key, required this.movie});

  final Movie movie;

  void _backToHome(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
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
                              AppColors.primary.withValues(alpha: 0.16),
                              AppColors.background.withValues(alpha: 0),
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
                              const Text(
                                'ADDED TO WATCHLIST!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'BebasNeue',
                                  color: AppColors.textWarm,
                                  fontSize: 30,
                                  height: 32 / 30,
                                  letterSpacing: 0.75,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'The movie has been successfully added to your\n'
                                'watchlist and synchronized across your library.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                  height: 22.75 / 14,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Center(child: _MovieRecap(movie: movie)),
                              const SizedBox(height: 15),
                              SizedBox(
                                height: 56,
                                child: FilledButton.icon(
                                  onPressed: () => _backToHome(context),
                                  icon: const Icon(
                                    Icons.arrow_back_rounded,
                                    size: 18,
                                  ),
                                  label: const Text('BACK TO HOME'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: AppColors.onPrimary,
                                    elevation: 0,
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      height: 18 / 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.28,
                                    ),
                                    shape: const StadiumBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'TAP TO BROWSE NEW RELEASES',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 10,
                                  height: 14 / 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted.withValues(alpha: 0.62),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.theaters_outlined, size: 15, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'CELLULOID VAULT',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  height: 14 / 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.done_all_rounded, size: 14, color: AppColors.primary),
              SizedBox(width: 4),
              Text(
                'SYNCED',
                style: TextStyle(
                  color: AppColors.primaryStrong,
                  fontSize: 10,
                  height: 14 / 10,
                  fontWeight: FontWeight.w700,
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
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primary, AppColors.primaryStrong],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x40000000),
                      blurRadius: 28,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 40,
                  color: AppColors.onPrimary,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted.withValues(alpha: 0.92),
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
            Container(
              width: 32,
              height: 32,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: AppColors.deepest,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/success_inception.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              movie.title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 20 / 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${movie.year})',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                height: 16 / 12,
              ),
            ),
            const SizedBox(width: 10),
            const SizedBox.square(
              dimension: 4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.textMuted,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.star_rounded, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              movie.rating.toStringAsFixed(1),
              style: const TextStyle(
                color: AppColors.primaryStrong,
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
