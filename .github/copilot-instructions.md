# Flutter & Dart Coding Standards for this Project

Bạn là một chuyên gia Flutter Architect. Khi viết code hoặc phản hồi các yêu cầu trong dự án này, bạn PHẢI tuân thủ tuyệt đối các quy tắc sau:

## 1. Quy tắc Dart & Code Quality
- **Required Parameters:** Mọi tham số của hàm (function/constructor) luôn luôn phải là `required`. Nếu có trường hợp ngoại lệ bắt buộc phải để optional, bạn phải viết comment giải thích rõ lý do tại sao.
- **Packages/Dependencies:** Chỉ được phép sử dụng các thư viện (packages) đã có sẵn trong file `pubspec.yaml`. Tuyệt đối không tự ý đề xuất, import hoặc sử dụng thư viện mới.

## 2. Kiến trúc & Quản lý State
- **Architecture:** Bắt buộc tuân thủ **Clean Architecture** với 3 tầng riêng biệt: `domain`, `data`, `presentation`.
- **State Management:** Chỉ sử dụng thư viện **Bloc** hoặc **Cubit** để quản lý trạng thái.

## 3. Cấu trúc thư mục (Feature-Driven)
Khi tạo một feature mới (Ví dụ feature: `expense`, chức năng: `add`), cấu trúc thư mục phải như sau:
- Thư mục gốc: `lib/features/expense/add/`
- Thư mục con bắt buộc: `domain/`, `data/`, `presentation/`.

## 4. Quy tắc tầng Presentation (UI)
- **Pages:** Mọi file Page phải là `StatelessWidget`. Tuyệt đối không dùng `StatefulWidget` trừ khi có lý do cực kỳ đặc biệt. State phải được quản lý hoàn toàn qua Bloc/Cubit.
- **Vị trí file:** Các Page phải nằm trong `presentation/pages/`.
- **Tách nhỏ Widget:** Không viết Code UI quá dài trong một file. Phải tách các thành phần UI nhỏ ra thành các widget con trong `presentation/widgets/`.
- **Naming Convention cho Widgets:**
  - Tên Widget con phải bắt đầu bằng tiền tố là tên của Page đó (Ví dụ: `OnboardingWelcomeContent` nếu thuộc về `OnboardingWelcomePage`).
  - Mỗi Widget con phải có comment mô tả ngắn gọn chức năng của nó.

## 5. Quy tắc Design System & Styling (Rất Quan Trọng)
- **No Hardcoding:** Tuyệt đối không được phép hardcode giá trị kích thước (size) hoặc mã màu (Hex color) trực tiếp trong code.
- **Theme Usage:** Bạn phải tham khảo các định nghĩa trong `lib/core/theme/` để lấy ra:
  - Màu sắc (Colors) từ `colors.dart`.
  - Kích thước mặc định (Default sizes) từ các hằng số đã định nghĩa trong `sizes.dart`.
- Trước khi tạo widget mới, hãy đọc file `lib/core/theme/` để đảm bảo sử dụng đúng các giá trị tiêu chuẩn.

---
**Ghi chú:** Nếu người dùng yêu cầu làm điều gì đó vi phạm các quy tắc trên, hãy nhắc nhở họ và đề xuất cách làm đúng theo chuẩn của dự án này.