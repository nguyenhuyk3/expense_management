## 1. Quy tắc chung
- Các tham số của hàm luôn luôn phải là **required**. Nếu có trường hợp đặc biệt thì bắt buộc phải có comment giải thích lý do tại sao không thể là required.
- Kiến trúc bắt buộc: **Clean Architecture** (domain, data, presentation).
- Quản lý state: Sử dụng **Bloc/Cubit**.
- **QUAN TRỌNG:** Chỉ được phép sử dụng các thư viện (packages) đã có sẵn trong file `pubspec.yaml`. Tuyệt đối không tự ý đề xuất hoặc sử dụng thư viện mới nếu chưa có sự đồng ý của tôi.
- Khi xây dựng widgets hãy tham khảo các files lib/core/theme để lấy ra size mặc định và màu sắc đã được định nghĩa sẵn. Không được phép hardcode giá trị size hoặc màu sắc trực tiếp trong code.