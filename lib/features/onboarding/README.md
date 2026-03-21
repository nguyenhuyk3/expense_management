# Module Onboarding

Mô-đun onboarding xử lý luồng thiết lập ban đầu khi người dùng mở ứng dụng lần đầu tiên. Luồng gồm ba bước tuần tự: **Splash → Nhập tên → Chào mừng**.

```
onboarding/
└── presentation/
    ├── pages/
    │   ├── onboarding_splash_page.dart
    │   ├── onboarding_name_page.dart
    │   └── onboarding_welcome_page.dart
    └── widgets/
        ├── onboarding_fade_up_widget.dart
        ├── onboarding_name_confirm_button.dart
        ├── onboarding_name_header.dart
        ├── onboarding_name_star_field.dart
        ├── onboarding_name_text_field.dart
        ├── onboarding_spinning_ring.dart
        ├── onboarding_splash_brand.dart
        ├── onboarding_splash_dots.dart
        ├── onboarding_splash_logo.dart
        ├── onboarding_welcome_content.dart
        └── onboarding_welcome_greeting.dart
```

---

## Pages

### 1. `OnboardingSplashPage`

**File:** `presentation/pages/onboarding_splash_page.dart`

Màn hình đầu tiên hiển thị khi người dùng chưa thiết lập hồ sơ. Chạy chuỗi animation theo pha rồi tự động điều hướng sang `OnboardingNamePage`.

#### Luồng Phase

| Phase | Thời điểm | Nội dung |
|-------|-----------|----------|
| `0`   | 0 ms      | Chỉ hiển thị logo |
| `1`   | 900 ms    | Xuất hiện tagline + ba chấm nhảy |
| `2`   | 2200 ms   | Bắt đầu fade-out toàn màn hình |
| —     | 2900 ms   | Điều hướng sang `OnboardingNamePage` |

#### Các hàm quan trọng

```dart
void _setPhase(int p)
```
Cập nhật pha hiển thị hiện tại. Khi chuyển sang pha `2`, kích hoạt `AnimationController` fade-out để màn hình mờ dần trước khi rời trang.

---

```dart
void _navigateNext()
```
Điều hướng sang `OnboardingNamePage` bằng `Navigator.pushReplacement` với hiệu ứng `FadeTransition` (500 ms). Kiểm tra `mounted` để tránh lỗi khi widget đã bị dispose.

---

```dart
@override
void initState()
```
Khởi tạo `AnimationController` fade-out và lên lịch bốn `Future.delayed` để điều khiển chuỗi phase và điều hướng tự động.

---

```dart
@override
void dispose()
```
Giải phóng `_fadeOut` controller để tránh memory leak.

---

### 2. `OnboardingNamePage`

**File:** `presentation/pages/onboarding_name_page.dart`

Trang cho phép người dùng nhập tên hoặc biệt danh (tối đa 30 ký tự). Sau khi xác nhận, tên được lưu xuống local storage và điều hướng sang `OnboardingWelcomePage`.

#### Các hàm quan trọng

```dart
String get _name
```
Getter trả về giá trị trong `TextEditingController` sau khi đã trim khoảng trắng hai đầu. Được dùng để kiểm tra trạng thái hợp lệ của nút xác nhận và truyền sang trang tiếp theo.

---

```dart
Future<void> _onConfirm() async
```
Hàm xử lý sự kiện khi người dùng nhấn nút xác nhận:
1. Guard: trả về ngay nếu `_name` rỗng.
2. Gọi `UserLocalService.saveName(name)` để lưu tên vào local storage.
3. Kiểm tra `mounted` sau `await`.
4. Điều hướng sang `OnboardingWelcomePage` bằng `pushReplacement` với `FadeTransition` (500 ms), truyền `name` làm tham số.

---

```dart
@override
void dispose()
```
Giải phóng `TextEditingController` để tránh memory leak.

---

### 3. `OnboardingWelcomePage`

**File:** `presentation/pages/onboarding_welcome_page.dart`

Màn hình chào mừng hiển thị sau khi người dùng nhập tên. Phát animation nhập cảnh (fade + slide), sau đó tự động điều hướng về trang Home sau 2,8 giây.

> **Lưu ý:** Hiện tại trang Home là `Placeholder`. Cần thay bằng widget Home thực tế theo chú thích `TODO` trong file.

#### Các hàm quan trọng

```dart
@override
void initState()
```
Khởi tạo ba animation:
- `_enter`: `AnimationController` 600 ms, tự chạy ngay (`..forward()`).
- `_fade`: `CurvedAnimation` với curve `easeOut` — điều khiển độ trong suốt.
- `_slide`: `Tween<Offset>` từ `(0, 0.08)` → `Offset.zero` với curve `easeOut` — hiệu ứng trượt lên nhẹ.

Đồng thời lên lịch `Future.delayed(2800 ms, _navigateHome)` để tự động chuyển trang.

---

```dart
void _navigateHome()
```
Điều hướng sang trang Home bằng `Navigator.pushReplacement` với `FadeTransition` (500 ms). Kiểm tra `mounted` trước khi điều hướng.

---

```dart
@override
void dispose()
```
Giải phóng `_enter` controller để tránh memory leak.

---

## Luồng điều hướng

```
OnboardingSplashPage
        │  (tự động sau ~2,9 s)
        ▼
OnboardingNamePage
        │  (người dùng nhập tên & nhấn xác nhận)
        ▼
OnboardingWelcomePage
        │  (tự động sau ~2,8 s)
        ▼
      HomePage
```

Tất cả các bước điều hướng đều dùng `PageRouteBuilder` với `FadeTransition` để tạo sự chuyển cảnh mượt mà, đồng thời sử dụng `pushReplacement` để loại bỏ màn hình trước khỏi navigation stack (người dùng không thể quay lại màn hình onboarding).

---

## Dependencies nội bộ

| Pages | Widgets sử dụng | Services |
|-------|-----------------|----------|
| `OnboardingSplashPage` | `OnboardingSplashBrand`, `OnboardingNameStarField` | — |
| `OnboardingNamePage` | `OnboardingNameHeader`, `OnboardingNameTextField`, `OnboardingNameConfirmButton`, `OnboardingNameStarField` | `UserLocalService.saveName()` |
| `OnboardingWelcomePage` | `OnboardingWelcomeContent`, `OnboardingNameStarField` | — |
