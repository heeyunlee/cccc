# **CCCC: Food-Focused Expense Tracker**

### **Table of contents**
- [**CCCC: Food-Focused Expense Tracker**](#cccc-food-focused-expense-tracker)
    - [**Table of contents**](#table-of-contents)
  - [**Introduction**](#introduction)
  - [**Screenshots**](#screenshots)
    - [Using Plaid Link](#using-plaid-link)
  - [**Architecture**](#architecture)


## **Introduction**
CCCC is an food-focused expense tracking application built with [Flutter], [Firebase], and [Plaid API]. 

This project uses the following technologies:
- Dart and [Flutter] for building mobile application
- [Firebase Cloud Firestore] for NoSQL Database
- [Google Cloud Functions] for serverless functions
- [Plaid API] for connecting with bank accounts and fetching transactions data


## **Screenshots**

### Using Plaid Link
   Open Plaid Link         |   Connect Bank Account    |     Fetch Transactions    |
:-------------------------:|:-------------------------:|:-------------------------:|
<img src="readme_assets/plaid_ios_1.gif" width="200"/>|<img src="readme_assets/plaid_ios_2.gif" width="200"/>|<img src="readme_assets/plaid_ios_3.gif" width="200"/>


## **Architecture**

```
lib/
│───constants/
│───models/
│───routes/
│───services/
│───theme/
│───view/
│───view_models/
└───widgets/
```

- constants: constant values such as urls, keys, etc
- models: custom classes and enums
- routes: for routing within the app
- services: for using Firebase Authentication, Cloud Firestore, and Functions
- theme: app-level ThemeData, TextStyle, buttonTheme, and Color Palette
- view: [Scaffold]-level ui components
- view_models: view model for each view scaffolds
- widgets: widgets that are used in view
  

[Flutter]: https://flutter.dev/
[Firebase]: https://firebase.google.com/
[Plaid API]: https://plaid.com/
[Firebase Cloud Firestore]: https://firebase.google.com/products/firestore?gclid=EAIaIQobChMIudGSjImI9QIVSkpyCh2BiwOAEAAYASAAEgI5bPD_BwE&gclsrc=aw.ds
[Google Cloud Functions]: https://cloud.google.com/functions