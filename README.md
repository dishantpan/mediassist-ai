# 🏥 MediAssist — Symptom Based Department Recommendation System

![Java](https://img.shields.io/badge/Java-11-orange?style=flat-square&logo=java)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?style=flat-square&logo=mysql)
![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3-purple?style=flat-square&logo=bootstrap)
![Tomcat](https://img.shields.io/badge/Tomcat-9.x-yellow?style=flat-square&logo=apache-tomcat)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

> A web-based clinical triage system that recommends the correct hospital OPD department based on patient-selected symptoms — built with pure Java Servlets, MySQL, and Bootstrap 5.

---

## 📌 Problem Statement

In Indian hospitals, OPD patients often visit the wrong department due to lack of medical knowledge, leading to:
- Long wait times
- Physician burnout
- Delayed treatment for critical patients

**MediAssist** solves this by guiding patients to the correct department before they even enter the hospital.

---

## 🎯 Features

- ✅ Symptom-based department recommendation (12 departments)
- ✅ Medically validated 3-Tier triage engine (Emergency → Pathognomonic → Diagnostic Combinations → Weighted Scoring)
- ✅ Emergency red flag detection
- ✅ User registration and login with session management
- ✅ Consultation history tracking
- ✅ Admin dashboard with Chart.js pie chart
- ✅ Nearby hospital suggestions per department
- ✅ Responsive UI with Bootstrap 5

---

## 🏗️ Tech Stack

| Layer | Technology |
|---|---|
| Frontend | HTML5, CSS3, Bootstrap 5 (CDN), Chart.js (CDN) |
| Backend | Java Servlets (Pure — No Spring Boot) |
| Database | MySQL 8.x with JDBC |
| Server | Apache Tomcat 9.x |
| IDE | IntelliJ IDEA |
| Build | Maven |

---

## 🧠 Core — Rule Engine Architecture

The recommendation engine uses a **3-Tier Triage System** validated against:
- WHO Triage Protocols
- AIIMS Triage Protocol (ATP)
- MSD Manual Symptom Classification
- CDC Stroke & Emergency Guidelines
- Mayo Clinic Clinical References

### Tier 0 — Emergency Red Flags
Certain symptom combinations bypass OPD entirely and redirect to Emergency/Casualty.

```
Chest Pain + Breathlessness + Fainting → ⚠️ Possible Heart Attack → EMERGENCY
Slurred Speech + Severe Headache + Facial Droop → ⚠️ Possible Stroke → EMERGENCY
Fever + Severe Headache + Neck Stiffness → ⚠️ Possible Meningitis → EMERGENCY
```

### Tier 1 — Pathognomonic Symptoms
Single symptoms that definitively point to one department.

```
Seizures → Neurology
Jaundice → Gastroenterology
Thyroid Swelling → Endocrinology
Hallucinations → Psychiatry
Fracture → Orthopedic
Blood in Urine → Urology
```

### Tier 2 — Diagnostic Combinations
Clinically validated symptom pairs/triples that confirm a department.

```
Chest Pain + Palpitations → Cardiology (Arrhythmia pattern)
Excessive Thirst + Hunger + Frequent Urination → Endocrinology (Diabetes Triad)
Burning Urination + Frequent Urination → Urology (UTI pattern)
Ear Pain + Hearing Loss → ENT (Otitis Media pattern)
```

### Tier 3 — Weighted Scoring
Fallback scoring when no Tier 0/1/2 rule matches. Each symptom has a weight (1-3) based on its specificity for a department.

```
Weight 3 → Almost always this department
Weight 2 → Commonly this department
Weight 1 → Sometimes this department
```

---

## 🏥 Supported Departments

| # | Department | Example Symptoms |
|---|---|---|
| 1 | General Medicine | Fever, Cough, Cold, Body Ache |
| 2 | Cardiology | Chest Pain, Palpitations, Breathlessness |
| 3 | Neurology | Seizures, Slurred Speech, Tremors |
| 4 | Orthopedic | Joint Pain, Fracture, Back Pain |
| 5 | ENT | Ear Pain, Hearing Loss, Throat Pain |
| 6 | Ophthalmology | Eye Pain, Blurred Vision, Eye Redness |
| 7 | Dermatology | Skin Rash, Itching, Acne |
| 8 | Gastroenterology | Jaundice, Blood in Stool, Stomach Pain |
| 9 | Psychiatry | Hallucinations, Depression, Panic Attacks |
| 10 | Urology | Burning Urination, Blood in Urine |
| 11 | Endocrinology | Excessive Thirst, Thyroid Swelling |
| 12 | Dentistry | Tooth Pain, Gum Bleeding |

---

## 📁 Project Structure

```
mediassist/
├── src/main/java/
│   └── com/mediassist/
│       ├── model/
│       │   ├── User.java
│       │   └── Consultation.java
│       ├── dao/
│       │   ├── UserDAO.java
│       │   └── ConsultationDAO.java
│       ├── rules/
│       │   ├── SymptomRule.java        ← Interface
│       │   ├── DepartmentMapper.java   ← 3-Tier Engine
│       │   ├── GeneralRule.java
│       │   ├── CardiologyRule.java
│       │   ├── NeurologyRule.java
│       │   ├── OrthopedicRule.java
│       │   ├── ENTRule.java
│       │   ├── OphthalmologyRule.java
│       │   ├── DermatologyRule.java
│       │   ├── GastroRule.java
│       │   ├── PsychiatryRule.java
│       │   ├── UrologyRule.java
│       │   ├── EndocrinologyRule.java
│       │   └── DentistryRule.java
│       ├── servlet/
│       │   ├── LoginServlet.java
│       │   ├── RegisterServlet.java
│       │   ├── SymptomServlet.java
│       │   ├── HistoryServlet.java
│       │   └── AdminServlet.java
│       └── util/
│           └── DBConnection.java
├── src/main/webapp/
│   ├── index.html
│   ├── register.html
│   ├── symptoms.html
│   ├── result.jsp
│   ├── history.jsp
│   ├── admin.jsp
│   └── WEB-INF/
│       └── web.xml
└── pom.xml
```

---

## 🗄️ Database Schema

```sql
CREATE DATABASE mediassist;
USE mediassist;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE consultations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    symptoms_selected TEXT NOT NULL,
    department_suggested VARCHAR(100) NOT NULL,
    consultation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE hospitals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    city VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    contact VARCHAR(50)
);
```

---

## ⚙️ Installation & Setup

### Prerequisites
- Java JDK 11 or 17
- Apache Tomcat 9.x
- MySQL 8.x
- IntelliJ IDEA
- Maven 3.x

### Step 1 — Clone the Repository
```bash
git clone https://github.com/yourusername/mediassist.git
cd mediassist
```

### Step 2 — Database Setup
Open MySQL Workbench and run the SQL from `database/schema.sql`, or paste the schema above.

### Step 3 — Configure Database Connection
Open `src/main/java/com/mediassist/util/DBConnection.java` and update:

```java
private static final String URL  = "jdbc:mysql://localhost:3306/mediassist";
private static final String USER = "root";
private static final String PASS = "your_password_here"; // ← Change this
```

### Step 4 — Build the Project
```bash
mvn clean package
```

### Step 5 — Deploy on Tomcat
- Copy the generated `mediassist.war` from `/target` to Tomcat's `webapps` folder
- Or configure Tomcat in IntelliJ and run directly

### Step 6 — Access the Application
```
http://localhost:8080/mediassist
```

---

## 🖥️ Application Flow

```
User opens index.html
        ↓
   Login / Register
        ↓
  symptoms.html → Select symptoms from checklist
        ↓
  SymptomServlet → DepartmentMapper (3-Tier Engine)
        ↓
  result.jsp → Shows department + nearby hospitals
        ↓
  history.jsp → User's past consultations
        ↓
  admin.jsp → Admin dashboard with Chart.js
```

---

## 📸 Screenshots

> _Add screenshots of your running application here_

| Login Page | Symptom Selection | Result Page |
|---|---|---|
| ![Login](#) | ![Symptoms](#) | ![Result](#) |

---

## 🔬 Medical References Used

This system's triage logic is validated against the following sources:

- **WHO** — Adult Triage Protocols & mhGAP Mental Health Guidelines
- **AIIMS** — Triage Protocol (ATP) — Emergency Classification
- **CDC** — Stroke FAST Signs & Emergency Symptom Guidelines
- **MSD Manual** — Symptom Classification by Organ System
- **Mayo Clinic** — Diabetes Triad & Thyroid Disorder Symptoms
- **MedlinePlus** — Emergency Red Flag Combinations

---

## 🚀 Future Scope

- [ ] Phase 2 — NLP text input in Hinglish using Python Flask + scikit-learn
- [ ] Mobile app version (Android)
- [ ] Integration with real hospital appointment systems
- [ ] Multi-language support (Hindi, Gujarati)
- [ ] Doctor login panel for feedback on recommendations

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

> ⭐ If this project helped you, please give it a star on GitHub!
