import 'package:bt_chuong4/app.dart';
import 'package:bt_chuong4/models/user_profile.dart';
import 'package:bt_chuong4/pages/categories_page.dart';
import 'package:bt_chuong4/pages/profile_page.dart';
import 'package:bt_chuong4/state/settings_controller.dart';
import 'package:bt_chuong4/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _pumpApp(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(const MovieExplorerApp());
  await tester.pumpAndSettle();
}

/// Các tab ẩn trong IndexedStack vẫn được dựng nên chỉ tìm widget bấm được.
Finder _visibleText(String text) => find.text(text).hitTestable();

Future<void> _tapNavigationBar(WidgetTester tester, String label) async {
  await tester.tap(
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label)),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Danh mục -> chi tiết -> thành công -> tab Xem sau', (
    tester,
  ) async {
    await _pumpApp(tester);
    expect(find.text('MOVIE EXPLORER'), findsOneWidget);

    await _tapNavigationBar(tester, 'Danh mục');
    expect(_visibleText('KHÁM PHÁ THEO THỂ LOẠI'), findsOneWidget);

    await tester.tap(_visibleText('Tội phạm'));
    await tester.pumpAndSettle();
    expect(find.text('1 phim'), findsOneWidget);

    await tester.tap(_visibleText('The Dark Knight'));
    await tester.pumpAndSettle();
    expect(find.text('THE DARK KNIGHT'), findsOneWidget);

    await tester.tap(find.text('Thêm vào danh sách xem'));
    await tester.pumpAndSettle();
    expect(find.text('ĐÃ THÊM VÀO DANH SÁCH!'), findsOneWidget);

    await tester.tap(find.text('XEM DANH SÁCH XEM SAU'));
    await tester.pumpAndSettle();
    expect(_visibleText('1 PHIM ĐÃ LƯU'), findsOneWidget);
    expect(_visibleText('The Dark Knight'), findsOneWidget);
    expect(
      find.descendant(of: find.byType(Badge), matching: find.text('1')),
      findsOneWidget,
    );
  });

  testWidgets('Drawer mở Hồ sơ, nhập họ tên + MSSV và trả dữ liệu về', (
    tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.text('THỂ LOẠI'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationDrawer),
        matching: find.text('Hồ sơ'),
      ),
    );
    await tester.pumpAndSettle();
    expect(_visibleText('Chưa có họ tên'), findsOneWidget);

    await tester.tap(_visibleText('Cập nhật hồ sơ'));
    await tester.pumpAndSettle();
    expect(find.text('Chỉnh sửa hồ sơ'), findsOneWidget);

    final saveButton = find.text('Lưu thay đổi');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập họ và tên'), findsOneWidget);
    expect(find.text('Vui lòng nhập MSSV'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Họ và tên *'),
      '  Nguyễn   Văn An ',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mã số sinh viên (MSSV) *'),
      '2151012345',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Lớp'),
      'dh21cntt01',
    );
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Đã lưu hồ sơ của Nguyễn Văn An'), findsOneWidget);
    expect(_visibleText('2151012345'), findsOneWidget);
    expect(_visibleText('DH21CNTT01'), findsOneWidget);

    await _tapNavigationBar(tester, 'Trang chủ');
    expect(_visibleText('Xin chào, An!'), findsOneWidget);
  });

  testWidgets('Chuyển giao diện Sáng/Tối ở trang Hồ sơ', (tester) async {
    await _pumpApp(tester);
    await _tapNavigationBar(tester, 'Hồ sơ');

    Brightness brightness() =>
        Theme.of(tester.element(find.byType(ProfilePage))).brightness;
    expect(brightness(), Brightness.dark);

    final lightSegment = _visibleText('Sáng');
    await tester.ensureVisible(lightSegment);
    await tester.tap(lightSegment);
    await tester.pumpAndSettle();
    expect(brightness(), Brightness.light);

    await tester.tap(_visibleText('Tối'));
    await tester.pumpAndSettle();
    expect(brightness(), Brightness.dark);
  });

  testWidgets('Lọc theo danh mục ở Trang chủ', (tester) async {
    await _pumpApp(tester);
    expect(_visibleText('6 PHIM'), findsOneWidget);

    final sciFiChip = find.widgetWithText(ChoiceChip, 'Khoa học viễn tưởng');
    await tester.ensureVisible(sciFiChip);
    await tester.tap(sciFiChip);
    await tester.pumpAndSettle();
    // Tiêu đề chứa số phim đã cuộn khỏi màn hình khi hàng chip được kéo lên.
    expect(find.text('3 PHIM', skipOffstage: false), findsOneWidget);
  });

  testWidgets('Vuốt để xóa khỏi Xem sau và hoàn tác', (tester) async {
    await _pumpApp(tester);

    await _tapNavigationBar(tester, 'Danh mục');
    final animationCard = find.descendant(
      of: find.byType(CategoriesPage),
      matching: find.text('Hoạt hình'),
    );
    await tester.ensureVisible(animationCard);
    await tester.pumpAndSettle();
    await tester.tap(animationCard);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Thêm vào danh sách xem sau'));
    await tester.pumpAndSettle();
    // pageBack() tìm tooltip tiếng Anh "Back", còn app đang dùng tiếng Việt.
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    await _tapNavigationBar(tester, 'Xem sau');
    expect(_visibleText('Spider-Man: Verse'), findsOneWidget);

    await tester.drag(
      find.byKey(const ValueKey('spider-verse')),
      const Offset(-500, 0),
    );
    await tester.pumpAndSettle();
    expect(_visibleText('Danh sách đang trống'), findsOneWidget);

    await tester.tap(find.text('Hoàn tác'));
    await tester.pumpAndSettle();
    expect(_visibleText('Spider-Man: Verse'), findsOneWidget);
  });

  testWidgets(
    'Poster ở Trang chủ vẫn hiện sau khi quay về từ trang Thành công',
    (tester) async {
      await _pumpApp(tester);

      Finder inceptionPoster() => find.descendant(
        of: find.widgetWithText(MovieCard, 'Inception'),
        matching: find.byType(Image),
      );
      expect(inceptionPoster(), findsOneWidget);

      await tester.tap(find.widgetWithText(MovieCard, 'Inception'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Thêm vào danh sách xem'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('XEM DANH SÁCH XEM SAU'));
      await tester.pumpAndSettle();

      await _tapNavigationBar(tester, 'Trang chủ');
      expect(inceptionPoster(), findsOneWidget);
    },
  );

  test('SettingsController lưu hồ sơ và giao diện xuống máy', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    SettingsController(preferences: preferences)
      ..setThemeMode(ThemeMode.light)
      ..updateProfile(
        const UserProfile(fullName: 'Nguyễn Văn An', studentId: '2151012345'),
      );

    final reloaded = SettingsController(preferences: preferences);
    expect(reloaded.themeMode, ThemeMode.light);
    expect(reloaded.profile.fullName, 'Nguyễn Văn An');
    expect(reloaded.profile.studentId, '2151012345');
  });

  test('UserProfile tính tên gọi và chữ viết tắt', () {
    const profile = UserProfile(fullName: 'Nguyễn Văn An');
    expect(profile.givenName, 'An');
    expect(profile.initials, 'NA');
    expect(UserProfile.empty.initials, isEmpty);
  });
}
