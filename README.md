# bt_chuong4 – Movie Explorer

Ứng dụng khám phá phim viết bằng Flutter cho bài tập Chương 4: điều hướng và
truyền dữ liệu giữa các màn hình, Bottom Navigation, Drawer, Material Design 3
và hiển thị danh mục.

## Chạy ứng dụng

```bash
flutter pub get
flutter run
```

Kiểm thử và phân tích mã:

```bash
flutter test
flutter analyze
```

## Chức năng

| Màn hình | Nội dung |
|---|---|
| Trang chủ | Lời chào theo tên sinh viên, Carousel phim nổi bật, lọc phim theo danh mục bằng `ChoiceChip` |
| Danh mục | Lưới 8 thể loại, bấm để xem danh sách phim của thể loại, sắp xếp bằng bottom sheet |
| Chi tiết phim | Thông tin phim, diễn viên, lịch chiếu, thêm/bỏ khỏi danh sách "Xem sau" |
| Xem sau | Danh sách phim đã lưu, vuốt để xóa (có Hoàn tác), xóa tất cả có hộp thoại xác nhận |
| Hồ sơ | Họ tên, MSSV, lớp, email; chỉnh sửa hồ sơ; chọn giao diện Sáng / Tối / Hệ thống |

Hồ sơ và chế độ giao diện được lưu bằng `shared_preferences`, nên vẫn còn sau
khi tắt ứng dụng.

## Điều hướng và truyền dữ liệu

- **Bottom Navigation + Drawer**: `MainShell` dùng `NavigationBar` và
  `NavigationDrawer`; các tab nằm trong `IndexedStack` để giữ trạng thái.
  Drawer và Bottom Navigation dùng chung `ShellController` nên luôn đồng bộ.
- **Constructor**: Trang chủ mở `MovieDetailPage(movie: movie)` bằng
  `MaterialPageRoute`.
- **Route có tên + `arguments`**: `AppRoutes.onGenerateRoute` kiểm tra kiểu
  tham số cho `/category`, `/movie`, `/success`, `/profile/edit`.
- **Trả dữ liệu về (`Navigator.pop(context, result)`)**: màn hình chỉnh sửa hồ
  sơ trả về `UserProfile`, bottom sheet sắp xếp trả về `MovieSort`, hộp thoại
  xóa tất cả trả về `bool`.
- **Dữ liệu dùng chung (`InheritedNotifier`)**: `WatchlistScope`,
  `SettingsScope`, `ShellScope` đặt phía trên `MaterialApp` để mọi màn hình
  đều đọc và cập nhật được.

## Cấu trúc thư mục

```
lib/
├── app.dart, main.dart
├── data/        dữ liệu phim
├── models/      Movie, MovieCategory, UserProfile
├── pages/       các màn hình
├── routes/      tên route và onGenerateRoute
├── state/       controller + InheritedNotifier
├── theme/       màu, kiểu chữ, ThemeData Sáng/Tối (Material 3)
└── widgets/     widget dùng chung
```

Font BebasNeue không có đủ dấu tiếng Việt nên chỉ dùng cho chữ không dấu (tên
phim gốc, logo); các tiêu đề tiếng Việt dùng HankenGrotesk.
