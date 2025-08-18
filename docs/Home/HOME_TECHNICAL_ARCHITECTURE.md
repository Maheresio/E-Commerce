# Home Feature - Technical Architecture

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              PRESENTATION LAYER                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────┐  ┌──────────────────────┐  ┌───────────────────────────┐   │
│  │  HomeView   │  │  HomeViewBody        │  │  ProductDetailsView       │   │
│  │             │  │  (Sections + Lists)  │  │  (Details UI)             │   │
│  └─────────────┘  └──────────────────────┘  └───────────────────────────┘   │
│           │                   │                          │                   │
│           ▼                   ▼                          ▼                   │
│  ┌─────────────────┐  ┌──────────────────────────────┐  ┌─────────────────┐ │
│  │ Widgets         │  │ Riverpod Consumers           │  │ State Notifier  │ │
│  │ (Banner/List)   │  │ (StreamProvider bindings)    │  │ (Selection)     │ │
│  └─────────────────┘  └──────────────────────────────┘  └─────────────────┘ │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                               DOMAIN LAYER                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────────┐ │
│  │   Use Cases     │  │    Entities     │  │  Repositories (Interface)  │ │
│  │                 │  │                 │  │                             │ │
│  │ ┌─────────────┐ │  │ ┌─────────────┐ │  │ ┌────────────────────────┐ │ │
│  │ │ GetSale     │ │  │ │ Product     │ │  │ │ HomeRepository        │ │ │
│  │ ├─────────────┤ │  │ └─────────────┘ │  │ └────────────────────────┘ │ │
│  │ │ GetNew      │ │  │                 │  │                             │ │
│  │ ├─────────────┤ │  │                 │  │                             │ │
│  │ │ UpdateProd  │ │  │                 │  │                             │ │
│  │ └─────────────┘ │  │                 │  │                             │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────────────────┘ │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                                DATA LAYER                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌──────────────────────────┐  ┌──────────────────────────┐  ┌───────────┐ │
│  │ Repository Impl          │  │   Data Source            │  │  Models   │ │
│  │ (HomeRepositoryImpl)     │  │ (HomeDataSourceImpl)     │  │ (DTOs)    │ │
│  │                          │  │                          │  │           │ │
│  │  Error mapping           │  │ Firestore queries/stream │  │ Mapping   │ │
│  └──────────────────────────┘  └──────────────────────────┘  └───────────┘ │
│                                      │                                      │
│                                      ▼                                      │
│                        ┌────────────────────────────────┐                   │
│                        │        Firestore Services      │                   │
│                        │  (collectionsStream, getDoc)   │                   │
│                        └────────────────────────────────┘                   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Data Flow

```
UI Widget ─► StreamProvider.watch ─► UseCase.execute ─► HomeRepository
          ◄────────────────────────◄──────────────────◄──────────────── Streams
```

### Sequence: Sale Products Section

```
User            HomeHorizontalListViewSection   StreamProvider     UseCase       Repository      DataSource     Firestore
 │                          │                         │              │              │              │             │
 │ ─ open home ────────────►│                         │              │              │              │             │
 │                          │ ─ watch(sale) ────────► │              │              │              │             │
 │                          │                         │ ─ execute ──►│              │              │             │
 │                          │                         │              │ ─ sale ────►│              │             │
 │                          │                         │              │             │ ─ query ────►│             │
 │                          │                         │              │             │             │ ─ stream ───►│
 │                          │                         │              │             │ ◄─ map errs ─┤             │
 │                          │ ◄────── render data ────┤              │              │              │             │
```

## Component Dependencies

### Dependency Graph (Providers)

```
firestoreServicesProvider ─► HomeDataSourceImpl ─► HomeRepositoryImpl ─► GetSale/GetNew ─► StreamProviders
```

### Injection Configuration (excerpt)
```dart
final homeDataSourceProvider = Provider<HomeDataSource>(
  (ref) => HomeDataSourceImpl(ref.read(firestoreServicesProvider)),
);
final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HomeRepositoryImpl(ref.read(homeDataSourceProvider)),
);
```

## Error Handling Architecture

### Failure Hierarchy (reused from core)
```
Failure
├── FirestoreFailure
├── SocketFailure
├── ServerFailure
└── Unknown Failure (generic Failure)
```

### Mapping Strategy
- Repository converts external exceptions to `Failure`
- UI renders human-readable messages from `Failure.message`

## State Management

### Patterns
- Riverpod `StreamProvider` for Firestore streams
- Riverpod `StateNotifier` for transient UI-only state (`ProductSelection`)
- `select` to narrow rebuild scopes (favorites heart status)

## Performance Considerations

1) Limit Firestore query result size with `limit(10)` for carousels
2) Use indexed fields: `discountValue`, `createdAt`
3) Minimize widget rebuilds via Riverpod and granular widgets
4) Use efficient images (cached network, clipped, fixed aspect ratio)

## Testing Architecture

### Suggested Tests
- Repository: exception-to-failure mapping
- Use cases: stream pass-through behavior
- Widgets: loading/data/empty/error branches
- Navigation: hero tag and route extra correctness

---

This technical guide complements the main HOME_FEATURE_DOCUMENTATION.md.


