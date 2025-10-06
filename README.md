# MediCrush

Ứng dụng thông tin y tế đáng tin cậy và dễ tiếp cận được xây dựng bằng Flutter.

## Tính năng

- **Trang chủ**: Giao diện chính với thanh tìm kiếm và logo MediCrush
- **Chia sẻ**: Chia sẻ kinh nghiệm, câu hỏi và thông tin y tế với cộng đồng
- **Cài đặt**: Quản lý tài khoản và tùy chọn ứng dụng

## Yêu cầu hệ thống

- Flutter SDK (phiên bản 3.9.2 trở lên)
- Dart SDK
- Android Studio / VS Code với Flutter extension
- iOS Simulator (cho macOS) hoặc Android Emulator

## Cài đặt

1. Clone repository:
```bash
git clone <repository-url>
cd MediCrush_FAA
```

2. Cài đặt dependencies:
```bash
flutter pub get
```

3. Chạy ứng dụng:
```bash
flutter run
```

## Cấu trúc dự án

```
MediCrush_FAA/
├── lib/
│   ├── main.dart              # Entry point của ứng dụng
│   ├── screens/
│   │   ├── main_screen.dart       # Màn hình chính với bottom navigation
│   │   ├── home_screen.dart       # Màn hình trang chủ
│   │   ├── share_screen.dart      # Màn hình chia sẻ
│   │   └── settings_screen.dart   # Màn hình cài đặt
│   └── theme/
│       ├── app_colors.dart        # Định nghĩa màu sắc
│       └── app_theme.dart         # Theme của ứng dụng
├── assets/
│   ├── images/                    # Hình ảnh
│   └── icons/                     # Icons
├── pubspec.yaml                   # Dependencies và cấu hình
└── README.md
```

## Công nghệ sử dụng

- **Flutter**: Framework phát triển ứng dụng di động
- **Dart**: Ngôn ngữ lập trình
- **Material Design 3**: Thiết kế giao diện
- **Google Fonts**: Typography
- **Flutter SVG**: Hỗ trợ SVG icons

## Giao diện

Ứng dụng có 3 tab chính:
- **Home**: Trang chủ với logo MediCrush lớn và thanh tìm kiếm
- **Share**: Chia sẻ nội dung với cộng đồng
- **Settings**: Cài đặt tài khoản và ứng dụng

## Màu sắc chủ đạo

- Primary: #2E86AB (Xanh dương)
- Background: #F8F9FA (Xám nhạt)
- Text: #333333 (Đen nhạt)
- Secondary: #666666 (Xám)
- Success: #4CAF50 (Xanh lá)
- Error: #F44336 (Đỏ)
- Warning: #FF9800 (Cam)

## Tính năng chi tiết

### Trang chủ (Home)
- Logo MediCrush với gradient background
- Thanh tìm kiếm với icon microphone
- Các tính năng nổi bật với icons
- Thao tác nhanh (Lịch hẹn, Hồ sơ, Liên hệ)
- Hoạt động gần đây

### Chia sẻ (Share)
- Chọn danh mục (Kinh nghiệm, Câu hỏi, Thông tin, Đánh giá)
- Nhập nội dung chia sẻ
- Đính kèm (Hình ảnh, Tài liệu, Vị trí)
- Cài đặt quyền riêng tư
- Lịch sử chia sẻ gần đây

### Cài đặt (Settings)
- Thông tin profile với avatar
- Cài đặt chung (Thông báo, Chế độ tối, Đồng bộ)
- Quản lý tài khoản
- Cài đặt ứng dụng
- Hỗ trợ và liên hệ
- Khu vực nguy hiểm (Đăng xuất, Xóa tài khoản)

## Chạy trên các nền tảng

### Android
```bash
flutter run -d android
```

### iOS
```bash
flutter run -d ios
```

### Web
```bash
flutter run -d web
```

### Desktop
```bash
flutter run -d windows  # Windows
flutter run -d macos    # macOS
flutter run -d linux    # Linux
```

## Build ứng dụng

### Android APK
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```
