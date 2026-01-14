# Project Structure

This project demonstrates a professional, modular Flutter application structure following best practices.

## 📁 Folder Structure

```
lib/
├── main.dart                          # App entry point
├── config/
│   └── sdk_config.dart               # SDK configuration (centralized)
└── screens/
    ├── home/                          # Home/Dashboard screen
    │   ├── home_screen.dart
    │   └── widgets/
    │       └── dashboard_card.dart
    │
    ├── payment_intent/                # Payment Intent feature
    │   ├── payment_intent_screen.dart
    │   └── widgets/
    │       ├── amount_input_card.dart
    │       ├── billing_info_card.dart
    │       ├── error_card.dart
    │       ├── expiration_date_picker.dart
    │       ├── info_row_widget.dart
    │       ├── items_form_card.dart
    │       ├── items_list_card.dart
    │       └── payment_intent_result_card.dart
    │
    ├── payment_link/                  # Payment Link feature
    │   ├── payment_link_screen.dart
    │   └── widgets/
    │       ├── error_card.dart
    │       ├── payment_link_form_card.dart
    │       └── payment_link_result_card.dart
    │
    ├── transactions/                  # Transactions listing feature
    │   ├── transactions_screen.dart
    │   └── widgets/
    │       ├── error_state_widget.dart
    │       └── transaction_card.dart
    │
    └── transaction_details/           # Transaction details feature
        ├── transaction_details_screen.dart
        └── widgets/
            ├── amount_card.dart
            ├── error_state_widget.dart
            └── transaction_detail_card.dart
```

## 🏗️ Architecture Principles

### 1. **Feature-Based Organization**
Each feature has its own folder containing:
- The main screen file
- A `widgets/` subfolder for reusable components

### 2. **Separation of Concerns**
- **Config**: Centralized SDK configuration
- **Screens**: Feature screens organized by functionality
- **Widgets**: Reusable UI components scoped to their feature

### 3. **Widget Decomposition**
Large screens are broken down into smaller, focused widgets:
- Each widget has a single responsibility
- Widgets are reusable and testable
- Code is more maintainable and readable

### 4. **Navigation Flow**
```
Home Screen (Dashboard)
  ├── Payment Intent Screen
  ├── Payment Link Screen
  ├── Transactions Screen
  │     └── Transaction Details Screen (on tap)
  └── About Dialog
```

## 📦 Key Features

### Home Screen
- **Dashboard with 4 cards**: Payment Intent, Payment Link, Transactions, About
- Clean, modern UI with Material Design 3
- Easy navigation to all features

### Payment Intent Screen
- **Modular widgets** for each section:
  - Amount input
  - Items form and list
  - Billing information
  - Expiration date picker
  - Result display
- Clean separation of UI and logic

### Payment Link Screen
- Simple, focused interface
- Reusable form components
- Consistent error handling

### Transactions Screen
- List view with pull-to-refresh
- Click to navigate to details
- Professional card-based UI

### Transaction Details Screen
- Detailed transaction information
- Modular card-based layout
- Clear visual hierarchy

## 🎯 Benefits of This Structure

1. **Maintainability**: Easy to find and modify code
2. **Scalability**: Simple to add new features
3. **Testability**: Small, focused widgets are easier to test
4. **Reusability**: Widgets can be shared across features
5. **Readability**: Clear organization and separation of concerns
6. **Professional**: Industry-standard Flutter project structure

## 🔄 Migration from Old Structure

The old structure had:
- All screens in one `screens/` folder
- Long, monolithic screen files (400+ lines)
- Mixed concerns (UI + logic + widgets in one file)

The new structure provides:
- Feature-based organization
- Modular, composable widgets
- Clean, readable code files (50-150 lines each)
- Centralized configuration

