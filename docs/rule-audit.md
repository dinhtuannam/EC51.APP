# EC51.APP Rule Audit

Ngay kiem tra: 15/05/2026

## Tom tat

Da refactor luong Auth/Login va dieu huong root de dua code ve dung huong MVVM + UseCase + Repository + Coordinator. Hanh vi chuc nang duoc giu nguyen: nguoi dung nhap username/password, app goi API login, luu token/user session, sau do vao man hinh main tab.

## Cac diem sai va cach sua

| Rule | Sai trong code cu | Cach sua hien tai |
|---|---|---|
| View chi render state va gui action | `LoginView` tu quyet dinh chuyen sang `MainView` bang `viewModel.isLoggedIn`. | Them `AppRootView` de quyet dinh Login/Main theo `AppState.isAuthenticated`. `LoginView` chi hien thi form va goi `viewModel.handleSignIn()`. |
| MVVM + UseCase + Repository + Coordinator | `LoginViewModel` goi thang `AuthService.login`, khong co UseCase/Repository/Coordinator. | Them `LoginUseCase`, `AuthRepository`, `DefaultAuthRepository`, `NavigationCoordinator`. Luong moi: `LoginView -> LoginViewModel -> LoginUseCase -> AuthRepository -> AuthAPIService -> APIClient`. |
| Data access phai di qua Repository Protocol | Data login duoc lay truc tiep tu service trong ViewModel. | `LoginViewModel` chi biet `LoginUseCaseProtocol`. Data layer duoc boc sau `AuthRepository`. |
| Repository tra Domain Model, khong lo DTO/Data model ra ngoai Data layer | `LoginResponse`/`AuthUser` tu API duoc dung truc tiep trong ViewModel. | DTO nam o `Data/DTOs/AuthDTOs.swift`. Repository map sang Domain model `UserSession` truoc khi tra ve UseCase/ViewModel. |
| ViewModel khong thao tac persistence truc tiep | `LoginViewModel.saveSession()` tu ghi `UserDefaults`. | Session duoc luu trong `DefaultAuthRepository` qua `UserSessionStoreProtocol`. ViewModel khong con biet `UserDefaults`. |
| API/cache nam ngoai Presentation | Thu muc `Services/AuthService` chua API service va model dung chung voi Presentation. | Chuyen thanh `Data/Services/AuthAPIService.swift`, `Data/DTOs/AuthDTOs.swift`, `Data/Repositories/DefaultAuthRepository.swift`. |
| Coordinator quan ly dieu huong | Login state nam trong `LoginViewModel`; tab chinh khong co coordinator/root state. | Them `AppState` va `NavigationCoordinator`. Login thanh cong goi coordinator cap nhat `AppState`, root view tu render main. |
| Moi tab nen co `NavigationStack` rieng | `MainView` chi dung `TabView`, khong co navigation path rieng cho tung tab. | `MainView` dung `NavigationStack` rieng cho Dashboard/Product/Inventory/Profile voi path nam trong `AppState`. |
| SwiftUI uu tien hon UIKit | `MainView` cau hinh `UITabBar.appearance()` trong View. | Thay bang SwiftUI `.toolbarBackground(.white, for: .tabBar)` va `.tint(.blue)`. |
| UI component khong doc storage truc tiep | `AlxScreenHeader`/`AlxBaseLayout` doc `UserDefaults.standard` de lay ten user. | Header nhan `subtitle` tu caller. `MainView` truyen `appState.currentSession?.user.fullName` vao `DashboardView`. |

## File da thay doi chinh

- `MY_EC51/AppEnvironment.swift`: container tao dependency live/preview.
- `MY_EC51/AppRootView.swift`: root chon Login/Main theo `AppState`.
- `MY_EC51/AppState.swift`: auth session, selected tab, navigation path tung tab.
- `MY_EC51/Core/Storage/UserSessionStore.swift`: persistence abstraction cho session.
- `MY_EC51/Core/Routing/NavigationCoordinator.swift`: coordinator cho chuyen man hinh sau login.
- `MY_EC51/Domain/Models/UserSession.swift`: Domain model thay cho response DTO.
- `MY_EC51/Domain/Repositories/AuthRepository.swift`: repository protocol.
- `MY_EC51/Domain/UseCases/LoginUseCase.swift`: use case dang nhap.
- `MY_EC51/Data/DTOs/AuthDTOs.swift`: request/response DTO cua API.
- `MY_EC51/Data/Services/AuthAPIService.swift`: service goi endpoint login.
- `MY_EC51/Data/Repositories/DefaultAuthRepository.swift`: map DTO sang Domain va luu session.
- `MY_EC51/Features/Login/LoginView.swift`: chi render form login.
- `MY_EC51/Features/Login/LoginViewModel.swift`: chi validate, quan ly state, goi use case.
- `MY_EC51/Features/Main/MainView.swift`: tab SwiftUI + NavigationStack rieng.
- `MY_EC51/Core/Components/AlxScreenHeader.swift`: bo doc `UserDefaults`.
- `MY_EC51/Core/Components/AlxBasicLayout.swift`: truyen subtitle vao header.

## Ghi chu ve Realm

Source hien tai khong co import/thao tac Realm truc tiep, nen khong co vi pham kieu "ViewModel/Domain phu thuoc Realm". Chuc nang hien tai moi luu auth session, va theo design auth token/current user co the luu bang `UserDefaults`. Khi them offline cache/CRUD local, Realm nen duoc dat sau Repository/Data persistence, khong dua Realm object ra ngoai Data layer.

## Kiem tra sau sua

- Khong con tham chieu `AuthService`, `AuthModels`, `isLoggedIn`, `UITabBar`, `UserDefaults.standard` trong UI/header.
- Khong co `RealmSwift` trong ViewModel/Domain.
- Da cap nhat `MY_EC51.xcodeproj/project.pbxproj` de bo file service cu va them cac file App/Core/Domain/Data moi vao target.

