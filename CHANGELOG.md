# Change Log

## [0.0.13]
### New Features & Screens
- Add more Button interactivity by modifying `ButtonStyle`
- Added a function where user can use local authentication such as fingerprint or face ID using [LocalAuthentication] package
- Created `LocalAuthenticationService` class to deal with [LocalAuthentication] package

### Bug Fix & Refactor

## [0.0.12]: Feb. 22nd, 2022
### New Features & Screens
- Created Firestore pagination for `AllTransactions` screen using query
- Created `PaginatedListView` and `PaginatedCustomScrollView` widget to use query
- Created `ChooseMerchantForTransaction` and `ChooseMerchantForTransactionModel` screen to change the merchant for each transaction
- Enable users to mark transaction as duplicate

### Bug Fix & Refactor
- Updated and restructured Python Google Cloud Functions


## [0.0.11]: Feb. 7th, 2022
### New Features & Screens
- Add a Google Cloud Functions that fixes `ITEM_LOGIN_REQUIRED` error from Plaid Link
- Add a `LinkedAccounts` screen where user can see all the linked accounts grouped by `institution_id`
- Create a Google Cloud Function that deletes accounts, transactions, and other data related to institution when the user unlinks
- Update `CheckItemsWidget` so that user can modify the `TransactionItem`
  
### Bug Fix & Refactor
- Add a `DateTime` extension that creates a timeago string
- Create `enumToTitle` extension for general type
- Also create `lowerCamelCase` extension for String that creates a lowerCamelCase from different types of sentences
- Update `process_receipt_texts` function to get the better result

## [0.0.10]: Jan. 28th, 2022
### New Features & Screens
- Show logo image for `AccountListTile`

### Bug Fix & Refactor
- Refactor some code
- Update Cloud Function that is called to reload transactions data
- Create test for `Formatter` class
- Create Plaid's `Institution` class, including all the other classes and enums required to make one
- Refactor `functions/sources` folder
- Add `enumExtension` and `stringExtension`

## [0.0.9] Jan 15th, 2022
### New Features & Screens
- Add iOS and Android icon

### Bug Fix & Refactor
- Update `process_receipts_texts` google cloud functions
- Fix RenderFlex overflowed problem with `ScanReceiptBottomSheet` widget

## [0.0.8] Jan. 12th, 2022
### New Features & Screens
- Add a feature to read receipt image and update transaction
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

[0.0.12]: https://github.com/heeyunlee/cccc/commit/6340afe7d1f7ef3fbab10557a15668ab68bd2ceb
[0.0.11]: https://github.com/heeyunlee/cccc/commit/214b6b4496c0e6a14ff83828b0438cd12f17fb46
[0.0.10]: https://github.com/heeyunlee/cccc/commit/d33697280ac20257cd13f409835d8559533ac8b4
[0.0.9]: https://github.com/heeyunlee/cccc/commit/168154fd54fee57a68a75c2b2339068c9a5cf21f
[0.0.8]: https://github.com/heeyunlee/cccc/commit/424609ca970fcc04657240673cd7a3ddf38c7bdc
[0.0.7]: https://github.com/heeyunlee/cccc/commit/e3d944be91e599146db2ef94a64112858fad7760
[0.0.6]: https://github.com/heeyunlee/cccc/commit/491bbb9d227f6d26649f4f048ceb7b9c00b2c1f6
[0.0.5]: https://github.com/heeyunlee/cccc/commit/3ce45d9d293c912f3791acaeda7d2c91b860a4cf
[0.0.4]: https://github.com/heeyunlee/cccc/commit/2da3d6c1eb83d3d82ddaf7442c4e9d20f8e6f7c8
[0.0.3]: https://github.com/heeyunlee/cccc/commit/0a5cdbd76996599dfd01a4c290ab7d0723d1e523
[0.0.2]: https://github.com/heeyunlee/cccc/commit/96682cce01f88cd05830057fc17f703601fc936a
[collection]: https://pub.dev/packages/collection
[LocalAuthentication]: https://pub.dev/packages/local_auth