## 3. Quy tắc tại lớp Presentation
- **Pages:** Luôn là `StatelessWidget`. State được quản lý qua Bloc/Cubit.
- **Vị trí Page:** Phải nằm trong `presentation/pages/`.
- **Chia nhỏ Widget:** Không viết page quá dài. Phải tách thành các widget con trong `presentation/widgets/`.
- **Naming Convention cho Widgets:**
  - Phải có tiền tố là tên Page (VD: `OnboardingWelcomeContent` cho `OnboardingWelcomePage`).
  - Tên rõ ràng và phải có comment mô tả chức năng của widget đó.
- Khi xây dựng widgets hãy tham khảo các files lib/core/theme để lấy ra size mặc định và màu sắc đã được định nghĩa sẵn. Không được phép hardcode giá trị size hoặc màu sắc trực tiếp trong code.