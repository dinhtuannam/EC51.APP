## Nguyên tắc bắt buộc

- UI dùng SwiftUI. Chỉ dùng UIKit khi SwiftUI không đáp ứng được và phải có lý do trong design/review.
- Kiến trúc mặc định: MVVM + UseCase + Repository + Coordinator + Realm Persistence.
- View chỉ render state và gửi action. Không chứa business logic.
- ViewModel không import RealmSwift và không thao tác Realm trực tiếp.
- UseCase và Domain không phụ thuộc Realm.
- Data access phải đi qua Repository Protocol.
- Repository trả về Domain Model, không trả Realm Object ra ngoài Data layer.
- Mỗi business rule quan trọng phải có traceability tới source/design, iOS code và testcase.