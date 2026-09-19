import 'package:flutter/material.dart';

import '../data/movie_data.dart';
import '../models/movie_category.dart';
import '../routes/app_routes.dart';
import '../widgets/category_card.dart';
import '../widgets/section_header.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  void _openCategory(BuildContext context, MovieCategory category) {
    // Truyền dữ liệu qua route có tên và tham số `arguments`.
    Navigator.pushNamed(context, AppRoutes.category, arguments: category);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxContentWidth = constraints.maxWidth.clamp(0.0, 760.0);
        final columns = maxContentWidth >= 600 ? 3 : 2;

        return Center(
          child: SizedBox(
            width: maxContentWidth,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: 'Khám phá theo thể loại',
                          trailing: CountPill(
                            '${MovieCategory.values.length} THỂ LOẠI',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Chọn một thể loại để xem các bộ phim thuộc danh mục đó.',
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.05,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final category = MovieCategory.values[index];
                      return CategoryCard(
                        category: category,
                        movieCount: moviesIn(category).length,
                        onTap: () => _openCategory(context, category),
                      );
                    }, childCount: MovieCategory.values.length),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
