# SafeReach App 🛡️

A modern mobile security and emergency response system. This repository is structured as a monorepo containing:
* **/backend**: NestJS JavaScript API server.
* **/frontend**: Flutter mobile application.

---

## 🛠️ Prerequisites for Windows

Before starting, ensure your system has the following tools installed:

1. **Git**: [Download Git for Windows](https://git-scm.com/download/win)
2. **Node.js** (v18+ recommended): [Download Node.js](https://nodejs.org/)
3. **Flutter SDK**: Follow the [Flutter Windows installation guide](https://docs.flutter.dev/get-started/install/windows)

---

## 🚀 How to Clone and Setup

Open **Command Prompt**, **PowerShell**, or **Git Bash** on your Windows machine and follow these steps:

### 1. Clone the Repository
```cmd
git clone https://github.com/Sothiphak/safereach-app.git
cd safereach-app
```

---

## 🖥️ Running the Backend (NestJS Server)

1. Navigate to the backend directory:
   ```cmd
   cd backend
   ```

2. Install the server dependencies:
   ```cmd
   npm install
   ```

3. Create your local environment configuration file:
   ```cmd
   copy .env.example .env
   ```

4. Configure the database:
   * Open the newly created `.env` file in a text editor (like Notepad or VS Code).
   * **Easiest Option (SQLite)**: Change `DB_TYPE=postgres` to `DB_TYPE=sqlite` to run with an in-memory database without needing to install PostgreSQL:
     ```env
     DB_TYPE=sqlite
     ```
   * **PostgreSQL Option**: If you have PostgreSQL running locally, set your matching database credentials (`DB_USERNAME`, `DB_PASSWORD`, `DB_DATABASE`).

5. Start the backend development server:
   ```cmd
   npm run start:dev
   ```
   *The server will start up and listen on `http://localhost:3000` (or the port defined in your configuration).*

---

## 📱 Running the Frontend (Flutter Mobile App)

1. Open a new terminal window, navigate back to the root, and go to the frontend directory:
   ```cmd
   cd frontend
   ```

2. Retrieve the Flutter dependencies:
   ```cmd
   flutter pub get
   ```

3. Find your connected devices (e.g., Chrome, Edge, connected Android/iOS device, or emulator):
   ```cmd
   flutter devices
   ```

4. Launch the application:
   * **Run on Web (Chrome)**:
     ```cmd
     flutter run -d chrome
     ```
   * **Run on a specific connected device / emulator**:
     ```cmd
     flutter run -d <DEVICE_ID>
     ```
