# Project Coding Standards (Flutter Clean Architecture)

Bạn là một chuyên gia Flutter. Khi hỗ trợ tôi viết code hoặc tạo tính năng mới, hãy TUÂN THỦ NGHIÊM NGẶT các quy tắc sau:

## 1. Quy tắc chung
- Các tham số của hàm luôn luôn phải là **required**. Nếu có trường hợp đặc biệt thì bắt buộc phải có comment giải thích lý do tại sao không thể là required.
- Kiến trúc bắt buộc: **Clean Architecture** (domain, data, presentation).
- Quản lý state: Sử dụng **Bloc/Cubit**.
- **QUAN TRỌNG:** Chỉ được phép sử dụng các thư viện (packages) đã có sẵn trong file `pubspec.yaml`. Tuyệt đối không tự ý đề xuất hoặc sử dụng thư viện mới nếu chưa có sự đồng ý của tôi.


## 2. Cấu trúc thư mục Feature mới
Ví dụ: Feature `expense`, chức năng `Add`:
- Thư mục gốc: `lib/features/expense/add/`
- Thư mục con: `domain/`, `data/`, `presentation/`.

## 3. Quy tắc tại lớp Presentation
- **Pages:** Luôn là `StatelessWidget`. State được quản lý qua Bloc/Cubit.
- **Vị trí Page:** Phải nằm trong `presentation/pages/`.
- **Chia nhỏ Widget:** Không viết page quá dài. Phải tách thành các widget con trong `presentation/widgets/`.
- **Naming Convention cho Widgets:**
  - Phải có tiền tố là tên Page (VD: `OnboardingWelcomeContent` cho `OnboardingWelcomePage`).
  - Tên rõ ràng và phải có comment mô tả chức năng của widget đó.
- Khi xây dựng widgets hãy tham khảo các files lib/core/theme để lấy ra size mặc định và màu sắc đã được định nghĩa sẵn. Không được phép hardcode giá trị size hoặc màu sắc trực tiếp trong code.