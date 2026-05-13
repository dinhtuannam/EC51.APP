# EC51 SwiftUI App Architecture Design

Tài liệu này thiết kế kiến trúc source code cho app EC51 theo mô hình MVVM, dựa trên backend API, flow màn hình và roadmap SwiftUI cần học. Mục tiêu là giúp source code dễ đọc, dễ mở rộng theo từng module nghiệp vụ, đồng thời đủ rõ để bạn tự implement từng phần.

Phạm vi tài liệu này chỉ là kiến trúc. Không mô tả UI pixel-perfect và không viết code triển khai chi tiết.

## 1. Nguyên tắc kiến trúc

App dùng SwiftUI + MVVM, chia theo feature và theo layer.

```text
View
  -> ViewModel
      -> Repository
          -> API Service
              -> APIClient
                  -> Backend REST API
```

Quy tắc dependency:

| Layer | Được phụ thuộc vào | Không nên làm |
|---|---|---|
| View | ViewModel, UI component, route enum | Gọi API trực tiếp, parse JSON, chứa business rule phức tạp |
| ViewModel | Repository/service protocol, model, validator, router state | Biết chi tiết URLSession hoặc JSON raw |
| Repository | API service, local cache, mapper | Chứa logic hiển thị SwiftUI |
| API Service | APIClient, DTO/request/response | Chứa state của màn hình |
| APIClient | URLSession, Codable, ApiResponse | Biết màn hình nào đang dùng API |
| Model/DTO | Codable, Identifiable, Hashable nếu cần | Phụ thuộc SwiftUI View |

Nên ưu tiên protocol cho repository/service để sau này dễ mock dữ liệu khi preview hoặc test ViewModel.

## 2. Cấu trúc thư mục đề xuất

```text
MY_EC51/
  App/
    MY_EC51App.swift
    AppRootView.swift
    AppEnvironment.swift
    AppState.swift
    AppTab.swift
    AppRoute.swift

  Core/
    Network/
      APIClient.swift
      Endpoint.swift
      HTTPMethod.swift
      APIError.swift
      ApiResponse.swift
      PagedResponse.swift
    Storage/
      AuthTokenStore.swift
      UserSessionStore.swift
      AppSettingsStore.swift
      LocalCacheStore.swift
    Routing/
      DeepLinkRouter.swift
      NavigationCoordinator.swift
    Utils/
      CurrencyFormatter.swift
      DateFormatterFactory.swift
      Debouncer.swift
      ValidationRule.swift

  Domain/
    Models/
      User.swift
      DashboardSummary.swift
      Product.swift
      Customer.swift
      Supplier.swift
      SalesOrder.swift
      PurchaseOrder.swift
      InventoryStock.swift
      StockMovement.swift
      Employee.swift
      Warehouse.swift
    Enums/
      RecordStatus.swift
      SalesOrderStatus.swift
      PurchaseOrderStatus.swift
      StockMovementType.swift
      EmployeeRole.swift
    Repositories/
      AuthRepository.swift
      DashboardRepository.swift
      ProductRepository.swift
      OrderRepository.swift
      InventoryRepository.swift
      EmployeeRepository.swift
      MasterDataRepository.swift

  Data/
    DTOs/
      Requests/
      Responses/
    Mappers/
    Services/
      AuthAPIService.swift
      DashboardAPIService.swift
      ProductAPIService.swift
      SalesOrderAPIService.swift
      PurchaseOrderAPIService.swift
      InventoryAPIService.swift
      EmployeeAPIService.swift
      MasterDataAPIService.swift
    Repositories/
      DefaultAuthRepository.swift
      DefaultDashboardRepository.swift
      DefaultProductRepository.swift
      DefaultOrderRepository.swift
      DefaultInventoryRepository.swift
      DefaultEmployeeRepository.swift
      DefaultMasterDataRepository.swift

  Presentation/
    Common/
      Components/
        StatusBadge.swift
        MetricCard.swift
        SearchFilterBar.swift
        LoadingView.swift
        ErrorBanner.swift
        EmptyStateView.swift
      Modifiers/
        LoadingOverlayModifier.swift
        CardStyleModifier.swift
      State/
        ViewLoadState.swift
        PagedListState.swift
        FormMode.swift

    Features/
      Auth/
        LoginView.swift
        LoginViewModel.swift
      Dashboard/
        DashboardView.swift
        DashboardViewModel.swift
      Products/
        ProductListView.swift
        ProductListViewModel.swift
        ProductDetailView.swift
        ProductDetailViewModel.swift
        ProductFormView.swift
        ProductFormViewModel.swift
      Orders/
        OrdersHomeView.swift
        OrdersHomeViewModel.swift
        SalesOrders/
        PurchaseOrders/
      Inventory/
        InventoryView.swift
        InventoryViewModel.swift
        InventoryDetailView.swift
        InventoryDetailViewModel.swift
        StockMovementListView.swift
        StockMovementListViewModel.swift
        InventoryAdjustmentView.swift
        InventoryAdjustmentViewModel.swift
      Profile/
        ProfileView.swift
        ProfileViewModel.swift
      Employees/
        EmployeeListView.swift
        EmployeeListViewModel.swift
        EmployeeDetailView.swift
        EmployeeDetailViewModel.swift
        EmployeeFormView.swift
        EmployeeFormViewModel.swift
```

Giai đoạn đầu có thể chưa cần tạo đủ tất cả file. Tuy nhiên nên giữ đúng hướng tổ chức để mỗi feature có View + ViewModel riêng, còn API/cache nằm ngoài Presentation.

## 3. App Layer

### `MY_EC51App`

Vai trò:

| Trách nhiệm | Ghi chú |
|---|---|
| Tạo `AppEnvironment` | Khởi tạo APIClient, repository, store |
| Inject environment xuống root | Có thể dùng `@StateObject`, `environmentObject`, hoặc truyền qua initializer |
| Mở `AppRootView` | Root quyết định login/main |

### `AppRootView`

Root view quyết định app đang ở trạng thái nào:

```text
AppRootView
  |-- chưa có auth token -> LoginView
  |-- đã có auth token   -> MainTabView
```

State chính:

| State | Nơi lưu | Mục đích |
|---|---|---|
| `authToken` | `AuthTokenStore` / `@AppStorage` | Xác định login state |
| `currentUser` | `UserSessionStore` | Hiển thị profile, role, permission |
| `selectedTab` | `AppState` | Điều hướng giữa các tab |
| `navigationPaths` | `NavigationCoordinator` | Mỗi tab có một navigation path riêng |
| `pendingDeepLink` | `AppState` | Lưu route nếu user mở link khi chưa login |

### `AppEnvironment`

Là container dependency của toàn app.

Nên chứa:

| Dependency | Mục đích |
|---|---|
| `apiClient` | Gửi HTTP request tới `http://localhost:5188` |
| `authRepository` | Login/logout/session |
| `dashboardRepository` | Dashboard summary |
| `productRepository` | CRUD product |
| `orderRepository` | Sales/Purchase order |
| `inventoryRepository` | Stock, movement, adjustment |
| `employeeRepository` | Employee CRUD |
| `masterDataRepository` | Customer, supplier, warehouse, category picker data |
| `settingsStore` | Dark mode, offline cache |
| `deepLinkRouter` | Parse URL thành route |

## 4. Core Network Layer

Backend trả response chung:

```text
ApiResponse<T>
  success: Bool
  message: String
  data: T?
  errors: [String]?
```

API phân trang trả `data` dạng:

```text
PagedResponse<T>
  items: [T]
  pageIndex: Int
  pageSize: Int
  totalItems: Int
  totalPages: Int
  hasNextPage: Bool
  hasPreviousPage: Bool
```

`APIClient` chịu trách nhiệm:

| Trách nhiệm | Ghi chú |
|---|---|
| Build request | Base URL, path, query, method, body |
| Attach token nếu có | Dù token mock, vẫn thiết kế sẵn |
| Decode `ApiResponse<T>` | Nếu `success=false`, throw `APIError.apiMessage` |
| Decode paging | `ApiResponse<PagedResponse<T>>` |
| Map lỗi | Network, invalid URL, decoding, unauthorized, server message |

Không để ViewModel tự tạo URL string thủ công. ViewModel chỉ gọi repository với tham số đã có ý nghĩa nghiệp vụ.

## 5. Domain Model và DTO

Nên tách DTO từ backend và Domain Model của app.

```text
Backend JSON DTO -> Mapper -> Domain Model -> ViewModel -> View
```

Lý do:

| Lý do | Ví dụ |
|---|---|
| Backend thay đổi field ít ảnh hưởng UI | `imageUrl` có thể nil nhưng UI vẫn có placeholder |
| UI cần computed property | `isLowStock`, `formattedTotal`, `canConfirm` |
| Form cần request riêng | Product create/update request khác Product detail response |

Các enum cần map string từ API:

| Enum | Values |
|---|---|
| `RecordStatus` | `Active`, `Inactive`, `Deleted` |
| `SalesOrderStatus` | `Draft`, `Confirmed`, `Completed`, `Cancelled` |
| `PurchaseOrderStatus` | `Draft`, `Ordered`, `Received`, `Cancelled` |
| `StockMovementType` | `Import`, `Export`, `Adjustment` |
| `EmployeeRole` | `Admin`, `Sales`, `Warehouse`, `Manager` |

## 6. Presentation State

Mỗi ViewModel nên expose state rõ ràng cho View.

```text
ViewLoadState
  idle
  loading
  loaded
  empty
  failed(message)
```

Danh sách phân trang nên dùng state riêng:

| Field | Ý nghĩa |
|---|---|
| `items` | Dữ liệu đang hiển thị |
| `pageIndex` | Trang hiện tại |
| `pageSize` | Số item/trang |
| `hasNextPage` | Có thể load thêm |
| `isLoadingFirstPage` | Loading lần đầu |
| `isLoadingMore` | Loading cuối list |
| `keyword` | Từ khóa search |
| `selectedFilters` | Status, role, customer, supplier, date |
| `errorMessage` | Lỗi hiện tại |

Form ViewModel nên có:

| Field | Ý nghĩa |
|---|---|
| `mode` | create/update |
| `input` | Các field người dùng nhập |
| `validationErrors` | Lỗi theo field |
| `isSubmitting` | Đang gọi API |
| `submitErrorMessage` | Lỗi từ API |
| `canSubmit` | Kết quả validate phía app |

## 7. Navigation và Deep Link

App có 5 tab chính:

| Tab | Root View | Route chính |
|---|---|---|
| Dashboard | `DashboardView` | dashboard, product detail, inventory low stock |
| Products | `ProductListView` | product detail, product form |
| Orders | `OrdersHomeView` | sales order detail, purchase order detail |
| Inventory | `InventoryView` | inventory detail, movements, adjustment |
| Profile | `ProfileView` | employees |

Mỗi tab nên có `NavigationStack` riêng để đổi tab không làm mất vị trí điều hướng.

```text
MainTabView
  |-- DashboardNavigationStack(path: dashboardPath)
  |-- ProductNavigationStack(path: productsPath)
  |-- OrdersNavigationStack(path: ordersPath)
  |-- InventoryNavigationStack(path: inventoryPath)
  |-- ProfileNavigationStack(path: profilePath)
```

Route enum đề xuất:

| Route | Dùng cho |
|---|---|
| `productDetail(id)` | Product detail từ list, dashboard, deep link |
| `salesOrderDetail(id)` | Sales order detail |
| `purchaseOrderDetail(id)` | Purchase order detail |
| `inventoryDetail(id)` | Inventory detail |
| `stockMovements(filter)` | Movement list |
| `employeeDetail(id)` | Employee detail |

Deep link flow:

```text
onOpenURL
  -> DeepLinkRouter parse URL
  -> nếu chưa login: lưu pendingDeepLink
  -> nếu đã login: chọn tab phù hợp và push route
```

Mapping:

| URL | Tab | Route |
|---|---|---|
| `erpapp://products/1` | Products | `productDetail(1)` |
| `erpapp://sales-orders/1001` | Orders | `salesOrderDetail(1001)` |
| `erpapp://purchase-orders/2001` | Orders | `purchaseOrderDetail(2001)` |
| `erpapp://inventory/1` | Inventory | `inventoryDetail(1)` |

## 8. Feature MVVM Design

### Auth

| Thành phần | Trách nhiệm |
|---|---|
| `LoginView` | Nhập username/password, hiển thị loading/error |
| `LoginViewModel` | Validate input, gọi `AuthRepository.login`, lưu session |
| `AuthRepository` | Gọi login API, lưu token/user vào store |
| `AuthAPIService` | `POST /api/auth/login` |

Sau login thành công:

```text
save token
save current user
clear login form
open MainTabView
if pendingDeepLink exists -> route to target screen
```

### Dashboard

| Thành phần | Trách nhiệm |
|---|---|
| `DashboardView` | Metric cards, top selling products |
| `DashboardViewModel` | Load/refresh summary, handle tap actions |
| `DashboardRepository` | Lấy summary, cache nếu bật offline |
| `DashboardAPIService` | `GET /api/dashboard/summary` |

Tap action không push trực tiếp trong card. View gọi ViewModel hoặc coordinator để:

| Action | Điều hướng |
|---|---|
| Tap Sales Orders | Chọn Orders tab |
| Tap Low Stock | Chọn Inventory tab với `lowStockOnly=true` |
| Tap Top Product | Chọn Products tab và push `productDetail(id)` |

### Products

| ViewModel | Trách nhiệm |
|---|---|
| `ProductListViewModel` | Load list, search debounce, filter, paging, delete |
| `ProductDetailViewModel` | Load detail, delete, refresh sau edit |
| `ProductFormViewModel` | Create/update, validate SKU/name/category/supplier/price/stock |

Repository/API:

| Use case | API |
|---|---|
| List/search/filter | `GET /api/products` |
| Detail | `GET /api/products/{id}` |
| Create | `POST /api/products` |
| Update | `PUT /api/products/{id}` |
| Delete | `DELETE /api/products/{id}` |

Picker data cho category/supplier không nên hard-code trong form. Nên lấy qua `MasterDataRepository`.

### Orders

Orders tab gồm `OrdersHomeView` với segmented control:

```text
OrdersHomeView
  |-- SalesOrderListView
  |-- PurchaseOrderListView
```

Sales order:

| ViewModel | Trách nhiệm |
|---|---|
| `SalesOrderListViewModel` | Search/filter/paging |
| `SalesOrderDetailViewModel` | Load detail, confirm, cancel, complete |
| `SalesOrderFormViewModel` | Create/update draft, validate customer/items/discount |

API:

| Use case | API |
|---|---|
| List | `GET /api/sales-orders` |
| Detail | `GET /api/sales-orders/{id}` |
| Create | `POST /api/sales-orders` |
| Update draft | `PUT /api/sales-orders/{id}` |
| Confirm | `POST /api/sales-orders/{id}/confirm` |
| Cancel | `POST /api/sales-orders/{id}/cancel` |
| Complete | `POST /api/sales-orders/{id}/complete` |

Purchase order:

| ViewModel | Trách nhiệm |
|---|---|
| `PurchaseOrderListViewModel` | Search/filter/paging |
| `PurchaseOrderDetailViewModel` | Load detail, mark ordered, receive, cancel |
| `PurchaseOrderFormViewModel` | Create/update draft, validate supplier/items/unit cost |

API:

| Use case | API |
|---|---|
| List | `GET /api/purchase-orders` |
| Detail | `GET /api/purchase-orders/{id}` |
| Create | `POST /api/purchase-orders` |
| Update draft | `PUT /api/purchase-orders/{id}` |
| Mark ordered | `POST /api/purchase-orders/{id}/order` |
| Receive | `POST /api/purchase-orders/{id}/receive` |
| Cancel | `POST /api/purchase-orders/{id}/cancel` |

Business rule hiển thị button nên nằm trong ViewModel hoặc computed property của Domain Model, ví dụ `canConfirm`, `canReceive`, `canEdit`.

### Inventory

| ViewModel | Trách nhiệm |
|---|---|
| `InventoryViewModel` | Load grid, search/filter, low stock only, paging |
| `InventoryDetailViewModel` | Load stock detail và recent movements |
| `StockMovementListViewModel` | Filter movement theo product/warehouse/type/keyword |
| `InventoryAdjustmentViewModel` | Validate quantity change, submit adjustment |

API:

| Use case | API |
|---|---|
| Inventory list | `GET /api/inventory` |
| Inventory detail | `GET /api/inventory/{id}` |
| Movements | `GET /api/inventory/movements` |
| Adjustment | `POST /api/inventory/adjustments` |

Quy tắc form adjustment:

| Rule | Ghi chú |
|---|---|
| `quantityChange != 0` | Không submit adjustment rỗng |
| New quantity không âm | Validate trước khi gọi API |
| Note nên có khi giảm kho | Giúp audit movement |

### Profile và Employees

Profile:

| Thành phần | Trách nhiệm |
|---|---|
| `ProfileView` | Hiển thị user, role, settings, logout |
| `ProfileViewModel` | Đọc current user, cập nhật settings, logout |
| `AppSettingsStore` | `@AppStorage` dark mode/offline cache |
| `AuthRepository` | Clear token/user session |

Employees:

| ViewModel | Trách nhiệm |
|---|---|
| `EmployeeListViewModel` | Load/search/filter/paging/delete |
| `EmployeeDetailViewModel` | Load detail |
| `EmployeeFormViewModel` | Create/update, validate employee code/full name/username/password/role |

API:

| Use case | API |
|---|---|
| List | `GET /api/employees` |
| Detail | `GET /api/employees/{id}` |
| Create | `POST /api/employees` |
| Update | `PUT /api/employees/{id}` |
| Delete | `DELETE /api/employees/{id}` |

Menu Employees chỉ nên hiển thị hoặc enable cho role `Admin` và `Manager`.

## 9. Shared UI Components

Các component dùng lại nhiều nơi:

| Component | Dùng ở |
|---|---|
| `StatusBadge` | Product, sales order, purchase order, employee |
| `MetricCard` | Dashboard |
| `SearchFilterBar` | Products, orders, inventory, employees |
| `ProductRowView` | Product list, product picker |
| `OrderRowView` | Sales/Purchase order list |
| `InventoryTileView` | Inventory grid |
| `MovementRowView` | Stock movement list |
| `LoadingView` | First load |
| `LoadingOverlay` | Submit form/API action |
| `ErrorBanner` | API error có thể retry |
| `EmptyStateView` | List rỗng |

Component chỉ nhận data đã sẵn sàng hiển thị. Không để component row tự gọi API.

## 10. Search, Filter, Paging

Danh sách có paging nên theo cùng một flow:

```text
loadFirstPage()
  -> reset pageIndex = 1
  -> call repository with current filters
  -> replace items

loadNextPageIfNeeded(currentItem)
  -> nếu currentItem gần cuối và hasNextPage
  -> pageIndex += 1
  -> append items

refresh()
  -> giữ filter hiện tại
  -> loadFirstPage()
```

Search nên debounce trước khi gọi API để tránh spam request khi user gõ.

Filter object đề xuất:

| Filter | Feature |
|---|---|
| `ProductFilter` | keyword, categoryId, supplierId, status |
| `SalesOrderFilter` | keyword, customerId, status, fromDate, toDate |
| `PurchaseOrderFilter` | keyword, supplierId, status, fromDate, toDate |
| `InventoryFilter` | keyword, warehouseId, productId, lowStockOnly, status |
| `StockMovementFilter` | keyword, warehouseId, productId, type |
| `EmployeeFilter` | keyword, role, status |

## 11. Validation Design

Validation nên đặt ở Form ViewModel, có thể tách thành validator riêng nếu form lớn.

| Form | Rule chính |
|---|---|
| Login | username/password không rỗng |
| Product | SKU/name không rỗng, category/supplier đã chọn, price > 0, stock >= 0 |
| Sales Order | customer đã chọn, ít nhất 1 item, quantity > 0, discount >= 0 |
| Purchase Order | supplier đã chọn, ít nhất 1 item, quantity > 0, unit cost > 0 |
| Inventory Adjustment | quantityChange khác 0, không làm tồn kho âm |
| Employee | employeeCode/fullName/username/password/role hợp lệ |

API vẫn là nguồn kiểm tra cuối cùng. ViewModel chỉ validate sớm để UX tốt hơn.

## 12. Local Storage và Offline Cache

Tối thiểu:

| Dữ liệu | Công cụ |
|---|---|
| Token | `@AppStorage` hoặc `AuthTokenStore` bọc `UserDefaults` |
| Current user | `UserDefaults` + Codable |
| Dark mode/offline setting | `@AppStorage` |

Cache nâng cao:

| Giai đoạn | Công cụ |
|---|---|
| Giai đoạn học FileManager | Lưu JSON Codable theo feature |
| Giai đoạn học Realm | Lưu entity local và pending sync action |

Flow cache đọc danh sách:

```text
ViewModel load
  -> nếu offline cache bật: đọc cache trước
  -> gọi API mới nhất
  -> cập nhật UI
  -> ghi cache
```

Flow mutation khi offline có thể thiết kế sau:

```text
create/update/delete offline
  -> lưu pending action local
  -> hiển thị trạng thái waiting to sync
  -> khi online: sync lần lượt
```

Ở bản đầu tiên, chỉ cần cache read-only là đủ để học `FileManager`, `Codable`, `Realm` theo roadmap.

## 13. Error Handling

Các loại lỗi nên chuẩn hóa:

| Lỗi | UI |
|---|---|
| Không có mạng | Error banner + Retry |
| API `success=false` | Hiển thị `message` từ backend |
| Decode lỗi | Thông báo dữ liệu không hợp lệ |
| Unauthorized | Clear token và quay về Login |
| Validate form | Hiển thị lỗi cạnh field hoặc dưới section |
| Delete/confirm/cancel lỗi | Alert giữ người dùng ở màn hình hiện tại |

ViewModel chỉ expose message đã thân thiện với UI. View không nên tự phân tích `Error`.

## 14. Dependency Injection

Khuyến nghị dùng initializer injection cho ViewModel:

```text
ProductListViewModel(
  productRepository,
  navigationCoordinator
)
```

Với View, có thể truyền dependency theo hai cách:

| Cách | Khi dùng |
|---|---|
| `environmentObject(AppEnvironment)` | App còn nhỏ, muốn setup nhanh |
| Factory trong `AppEnvironment` | Khi nhiều ViewModel và muốn preview/test dễ hơn |

Không tạo trực tiếp `URLSession` hoặc `APIClient` trong ViewModel. ViewModel nhận abstraction từ ngoài.

## 15. Mapping Roadmap SwiftUI vào Kiến trúc

| Kiến thức cần học | Áp dụng trong kiến trúc |
|---|---|
| Swift cơ bản, enum, struct, class | Domain Model, DTO, Route enum, ViewModel |
| Project structure | Chia `App/Core/Domain/Data/Presentation` |
| `@State`, `@Binding` | Input nhỏ trong View, reusable filter/form components |
| `ObservableObject` hoặc `@Observable` | ViewModel quản lý state màn hình |
| Custom View, ViewModifier | Common components và loading/error/card style |
| `List`, custom cell, swipe actions | Product/order/employee/movement list |
| `LazyVGrid` | Dashboard metric và Inventory grid |
| `TabView` | Main tab |
| `NavigationStack`, `NavigationPath` | Per-tab navigation và deep link |
| Sheet, Alert, ConfirmationDialog | Form create/update, confirm delete/logout/order action |
| `async/await`, `Task`, `MainActor` | API call trong ViewModel |
| URLSession, JSONDecoder | `APIClient` |
| `AsyncImage` | Product image |
| `@AppStorage`, UserDefaults | Token, user session, settings |
| FileManager + Codable | Offline JSON cache |
| Realm CRUD | Cache nâng cao và pending sync |

## 16. Thứ tự implement đề xuất

1. Tạo cấu trúc thư mục `App/Core/Domain/Data/Presentation`.
2. Tạo `APIClient`, `ApiResponse<T>`, `PagedResponse<T>`, `APIError`.
3. Tạo session/auth: `AppRootView`, `LoginView`, `LoginViewModel`.
4. Tạo `MainTabView` với 5 tab và `NavigationStack` riêng.
5. Implement Dashboard để kiểm tra API flow đơn giản.
6. Implement Products đầy đủ list/detail/form/delete để học CRUD chuẩn.
7. Implement Orders với sales order trước, sau đó purchase order.
8. Implement Inventory và Stock Movements.
9. Implement Profile, Settings, Employees.
10. Thêm deep link.
11. Thêm offline cache bằng FileManager, sau đó nâng cấp Realm nếu muốn.

## 17. Quy ước đặt tên

| Loại | Quy ước |
|---|---|
| View | `FeatureNameView` |
| ViewModel | `FeatureNameViewModel` |
| Repository protocol | `FeatureRepository` |
| Repository implementation | `DefaultFeatureRepository` |
| API service | `FeatureAPIService` |
| Request DTO | `CreateProductRequest`, `UpdateProductRequest` |
| Response DTO | `ProductResponse`, `SalesOrderDetailResponse` |
| Domain model | `Product`, `SalesOrder`, `InventoryStock` |
| Filter | `ProductFilter`, `SalesOrderFilter` |
| Route | `AppRoute.productDetail(id)` |

## 18. Ranh giới trách nhiệm quan trọng

| Không nên | Nên |
|---|---|
| View gọi URLSession | View gọi ViewModel action |
| ViewModel build URL string thủ công | ViewModel gọi repository method |
| DTO backend đi thẳng vào mọi View | Map sang Domain Model |
| Mỗi màn hình tự định nghĩa loading/error khác nhau | Dùng `ViewLoadState` chung |
| Form submit khi input chưa validate | Validate ở Form ViewModel trước |
| Một ViewModel quản lý quá nhiều màn hình | List/detail/form tách ViewModel |
| Deep link xử lý rải rác trong View | Tập trung ở `DeepLinkRouter` và `NavigationCoordinator` |

Thiết kế này giữ app đúng tinh thần MVVM: View mỏng, ViewModel quản lý state và action, data layer xử lý API/cache, domain model biểu diễn nghiệp vụ, còn navigation được điều phối tập trung để không làm rối từng màn hình.
