# **CCCC: Food-Focused Expense Tracker**

### **Table of contents**
- [**CCCC: Food-Focused Expense Tracker**](#cccc-food-focused-expense-tracker)
    - [**Table of contents**](#table-of-contents)
  - [**Introduction**](#introduction)
  - [**Features**](#features)
    - [Using Plaid Link to link bank accounts and fetch transaction data](#using-plaid-link-to-link-bank-accounts-and-fetch-transaction-data)
    - [Scan Receipt Image Using Google ML and Python](#scan-receipt-image-using-google-ml-and-python)
  - [**Architecture**](#architecture)


## **Introduction**
CCCC is an food-focused expense tracking application built with [Flutter], [Firebase], and [Plaid API]. 

This project uses the following technologies:
- Dart and [Flutter] for building mobile application
- [Firebase Cloud Firestore] for NoSQL Database
- [Google Cloud Functions] for serverless functions
- [Plaid API] for connecting with bank accounts and fetching transactions data


## **Features**

### Using Plaid Link to link bank accounts and fetch transaction data
   Open Plaid Link         |   Connect Bank Account    |     Fetch Transactions    |
:-------------------------:|:-------------------------:|:-------------------------:|
<img src="readme_assets/plaid_ios_1.gif" width="200"/>|<img src="readme_assets/plaid_ios_2.gif" width="200"/>|<img src="readme_assets/plaid_ios_3.gif" width="200"/>

### Scan Receipt Image Using Google ML and Python


## **Architecture**

```
lib/
│───constants/
│───extensions/
│───models/
│───routes/
│───services/
│───theme/
│───view/
│───view_models/
└───widgets/
```

- constants: constant values such as urls, keys, etc
- extensions: custom extensions for `String` or `Enum`
- models: custom classes and enums
- routes: for routing within the app
- services: for using Firebase Authentication, Cloud Firestore, and Functions
- theme: app-level ThemeData, TextStyle, buttonTheme, and Color Palette
- view: `Scaffold`-level ui components
- view_models: view model for each view scaffolds
- widgets: widgets that are used in view
  

[Flutter]: https://flutter.dev/
[Firebase]: https://firebase.google.com/
[Plaid API]: https://plaid.com/
[Firebase Cloud Firestore]: https://firebase.google.com/products/firestore?gclid=EAIaIQobChMIudGSjImI9QIVSkpyCh2BiwOAEAAYASAAEgI5bPD_BwE&gclsrc=aw.ds
[Google Cloud Functions]: https://cloud.google.com/functions