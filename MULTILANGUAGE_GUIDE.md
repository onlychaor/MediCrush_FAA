# Hướng dẫn sử dụng Đa ngôn ngữ trong MediCrush

## Tổng quan
Ứng dụng MediCrush hiện đã hỗ trợ **ĐẦY ĐỦ** 3 ngôn ngữ cho toàn bộ ứng dụng:
- 🇬🇧 **Tiếng Anh** (English)
- 🇻🇳 **Tiếng Việt** (Vietnamese) - Mặc định
- 🇫🇷 **Tiếng Pháp** (French)

### Các màn hình đã được dịch hoàn toàn:
✅ **Home Screen** - Trang chủ với thanh tìm kiếm, kết quả tìm kiếm
✅ **Share Screen** - Chia sẻ với cộng đồng, danh mục, quyền riêng tư
✅ **Settings Screen** - Cài đặt ứng dụng, tài khoản, bảo mật
✅ **Bottom Navigation** - Menu điều hướng phía dưới

## Cách thay đổi ngôn ngữ

### Trong ứng dụng
1. Mở ứng dụng MediCrush
2. Chuyển đến tab **Settings** (Cài đặt)
3. Trong phần **Application** (Ứng dụng), chọn **Language** (Ngôn ngữ)
4. Chọn ngôn ngữ bạn muốn từ danh sách
5. Ứng dụng sẽ tự động cập nhật ngôn ngữ ngay lập tức

### Lưu trữ ngôn ngữ
- Ngôn ngữ được chọn sẽ được lưu trữ trong `SharedPreferences`
- Khi mở lại ứng dụng, ngôn ngữ đã chọn sẽ được tự động áp dụng

## Cấu trúc kỹ thuật

### Files quan trọng
- **lib/l10n/** - Thư mục chứa các file ngôn ngữ
  - `app_en.arb` - Bản dịch tiếng Anh
  - `app_vi.arb` - Bản dịch tiếng Việt
  - `app_fr.arb` - Bản dịch tiếng Pháp
  - `app_localizations.dart` - File tự động generate

- **lib/services/language_service.dart** - Service quản lý ngôn ngữ
- **l10n.yaml** - Cấu hình cho Flutter localization

### Dependencies đã thêm
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any
  shared_preferences: ^2.2.2
  provider: ^6.1.1
```

## Thêm bản dịch mới

### Để thêm text mới vào ứng dụng:

1. Mở file `lib/l10n/app_en.arb` (file template)
2. Thêm key và value mới:
```json
{
  "yourNewKey": "Your English text"
}
```

3. Thêm bản dịch tương ứng vào `app_vi.arb`:
```json
{
  "yourNewKey": "Văn bản tiếng Việt của bạn"
}
```

4. Thêm bản dịch tương ứng vào `app_fr.arb`:
```json
{
  "yourNewKey": "Votre texte en français"
}
```

5. Chạy lệnh để generate lại code:
```bash
flutter gen-l10n
```

6. Sử dụng trong code:
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.yourNewKey)
```

## Thêm ngôn ngữ mới

### Để thêm ngôn ngữ mới (ví dụ: tiếng Hàn):

1. Tạo file mới `lib/l10n/app_ko.arb` với locale code `ko`
2. Copy nội dung từ `app_en.arb` và dịch sang tiếng Hàn
3. Cập nhật `lib/services/language_service.dart`:
```dart
static const List<Locale> supportedLocales = [
  Locale('en'),
  Locale('vi'),
  Locale('fr'),
  Locale('ko'), // Thêm ngôn ngữ mới
];

static const Map<String, String> languageNames = {
  'en': 'English',
  'vi': 'Tiếng Việt',
  'fr': 'Français',
  'ko': '한국어', // Thêm tên ngôn ngữ
};
```

4. Cập nhật file ARB với key tên ngôn ngữ mới
5. Chạy `flutter gen-l10n`

## Lưu ý kỹ thuật

- Files trong `lib/l10n/` được generate tự động khi build
- Không chỉnh sửa trực tiếp các file `app_localizations_*.dart`
- Chỉ chỉnh sửa các file `.arb`
- Ngôn ngữ mặc định: Tiếng Việt (`vi`)
- Nếu có lỗi về generated files, chạy:
  ```bash
  flutter clean
  flutter pub get
  flutter gen-l10n
  ```

## Demo
Xem video demo hoặc screenshot trong thư mục `docs/screenshots/`

---
© 2024 MediCrush Team

