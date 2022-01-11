# Change Log

## [0.0.8]
### New Features & Screens
- Create `ScanReceiptsScreenModel`
- Create `FirebaseStorageService` to use Firebase Storage
- Finish building `process_receipt_texts` function in python
- Add `google_ml_kit` library to read texts on image

## [0.0.7] Jan. 7th, 2022
### New Features & Screens
- Add `DevicePreview` library for better debugging over all across platforms
- Add `Transaction` dummy data
- Add `TransactionItem` class
- Add `PaymentChannel` enum
- Add `TransactionItemType` enum
- Add color swatch
- Add `AddReceiptScreen` screen
- Add `ReceiptWidget`
- Add `showCustomBottomSheet`

### Bug Fix & Refactor
- Build on web works now
- Modify `toEnum` function

## [0.0.6]: Jan. 3rd, 2022
### New Features & Screens
- Add `TransactionDetailScreen` and `TransactionDetailScreenModel`
- Create `HomeScreenModel`
- Add `AccountDetailScreen` and `AccountDetailScreenModel`

### Bug Fix & Refactor
- Restructure functions folder


## [0.0.5] - Jan. 2nd, 2022
### New Features & Screens
- Add `SignInWithGoogle` feature
- Finish pull to refresh feature
- Add Accounts StreamBuilder
- Use `groupListsBy` function from [collection] library to group accounts by type
- Create [ExpansionTile] for accounts
- Update Readme

### Bug Fix & Refactor
- Separate [Widgets] and [Views]

## [0.0.4] - Dec. 29th, 2021
### Bug Fix & Refactor
- Create [CloudFunctions] service
- Update readme.md

## [0.0.3] - Dec. 19th, 2021
### New Features & Screens
- Updated  `fetch_transaction_data` function to make a update on a firestore
- Added `StreamBuilder` to stream list of `Transaction` from the Firestore
- Added `TransactionsScreen`

### Bug Fix & Refactor
- Used `Freezed` package to generate classes

## [0.0.2] - Dec. 17th, 2021
### New Features & Screens
- Add `FirebaseAuthService`, `FirestoreDatabase`, and `FirestoreService` class to network with Firebase effectively
- Add signing in with anonymous feature
- Create `user` class using Freezed package

### Bug Fix & Refactor

[0.0.7]: https://github.com/heeyunlee/cccc/commit/e3d944be91e599146db2ef94a64112858fad7760
[0.0.6]: https://github.com/heeyunlee/cccc/commit/491bbb9d227f6d26649f4f048ceb7b9c00b2c1f6
[0.0.5]: https://github.com/heeyunlee/cccc/commit/3ce45d9d293c912f3791acaeda7d2c91b860a4cf
[0.0.4]: https://github.com/heeyunlee/cccc/commit/2da3d6c1eb83d3d82ddaf7442c4e9d20f8e6f7c8
[0.0.3]: https://github.com/heeyunlee/cccc/commit/0a5cdbd76996599dfd01a4c290ab7d0723d1e523
[0.0.2]: https://github.com/heeyunlee/cccc/commit/96682cce01f88cd05830057fc17f703601fc936a
[collection]: https://pub.dev/packages/collection