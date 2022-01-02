# Change Log

## [0.0.5] - Jan. 2nd, 2022
### New Features & Screens
- Add `SignInWithGoogle` feature
- Finish pull to refresh feature
- Add Accounts StreamBuilder
- Use `groupListsBy` function from [collection] library to group accounts by type
- Create [ExpansionTile] for accounts

### Bug Fix & Refactor

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

[0.0.2]: https://github.com/heeyunlee/cccc/commit/96682cce01f88cd05830057fc17f703601fc936a
[0.0.3]: https://github.com/heeyunlee/cccc/commit/0a5cdbd76996599dfd01a4c290ab7d0723d1e523
[0.0.4]: https://github.com/heeyunlee/cccc/commit/2da3d6c1eb83d3d82ddaf7442c4e9d20f8e6f7c8
[0.0.5]: https://github.com/heeyunlee/cccc/commit
[collection]: https://pub.dev/packages/collection