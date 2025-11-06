# 📝 Flutter Todo List

> My first Flutter app - A clean and intuitive todo list with priority management and local storage

## ✨ What It Does

A simple yet powerful todo app that helps you organize tasks by priority. Swipe to complete or delete, and never lose your todos thanks to local persistence with Hive.

## 🎯 Features

- **Priority System** - Categorize todos as Urgent, High, Medium, or Low with color-coded indicators
- **Swipe Actions** - Swipe right to complete ✅, swipe left to delete 🗑️
- **Local Storage** - All todos persist locally using Hive (no internet needed!)
- **Clean UI** - Modern card-based design with smooth animations
- **Bulk Delete** - Clear all todos with one tap (with confirmation, of course)

## 🛠️ Built With

- **Flutter** - UI framework
- **Hive** - Lightweight local database
- **Material Design** - For that clean, native feel

## 📁 Project Structure

```
lib/
├── add_todo_task/
│   └── add_todo.dart          # Add new todo screen
├── home_page/
│   └── home_screen.dart       # Main todo list view
├── hive_db/
│   ├── hive_db.dart           # Hive data model
│   └── hive_db.g.dart         # Generated adapter
├── todo_widgets/
│   ├── todo.dart              # Todo model & Priority enum
│   └── todo_tile.dart         # Custom todo card widget
└── main.dart                  # App entry point
```

## 🚀 Getting Started

1. **Clone the repo**
   ```bash
   git clone https://github.com/Shahroz5373/Shahroz5373-Flutter-Todo-App.git
   cd Shahroz5373-Flutter-Todo-App
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📄 License

This project is open source and available under the MIT License.

## 📧 Contact

**Shahroz Javid**  
📧 shahrozjavid5373@gmail.com  
🔗 [GitHub](https://github.com/Shahroz5373)

---


