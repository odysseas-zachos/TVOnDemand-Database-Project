# TVOnDemand Database Project

## 📌 Project Overview

**TVOnDemand** is a comprehensive database system designed for a Video on Demand / Streaming Services platform. The architecture is based on the recognized **Sakila Sample Database (v1.2)** schema, adapted and extended to meet modern requirements for managing users, movies, actors, categories, stores/servers, and transactions.

## 📁 Repository Structure & Contents

The repository contains the following core files:

* **`README.md`**: Project documentation and setup instructions.

* **`ER BY WORKBENCH GENERATOR.png`**: The official Entity-Relationship Diagram (ERD) generated automatically via **MySQL Workbench**. It visually illustrates table structures, primary and foreign keys, as well as 1:N and N:M relationships across entities.

* **`FINAL DATA.sql`**: The SQL Script containing schema selection (`USE tvondemand;`) and Data Manipulation Language (DML `INSERT`) statements to populate all database tables (such as actors, films, categories, users, etc.), ensuring a fully operational dataset out-of-the-box.

## 🏗️ Database Architecture (`tvondemand`)

The database consists of interconnected tables covering the following core modules:

1. **Content & Media Catalog:**

   * `film`: Detailed movie metadata (title, description, release year, duration, rating, etc.).

   * `actor` & `film_actor`: Actor details and N:M relationship mapping with films.

   * `category` & `film_category`: Movie genres and N:M relationship mapping.

   * `language`: Audio and subtitle language availability.

2. **User & Staff Management:**

   * `customer`: Registered platform subscribers and user profiles.

   * `staff`: Administrators and support staff profiles.

   * `address`, `city`, `country`: Geographic data and addresses for users and physical/digital nodes.

3. **Inventory & Transaction Management:**

   * `inventory`: Available streams/copies mapped per store or distribution server.

   * `rental`: History of content streams and rentals initiated by users.

   * `payment`: Transaction history and payment records.

   * `store`: Information on service points and server branches.

## 🚀 Setup & Installation Guide

### Prerequisites

* **RDBMS**: MySQL Server 8.0+ or MariaDB 10.4+

* **GUI Client (Optional)**: MySQL Workbench, DBeaver, or phpMyAdmin

### Execution Steps

1. **Create the Database:**
   Ensure the database target named `tvondemand` exists:

   ```sql
   CREATE DATABASE IF NOT EXISTS tvondemand 
   DEFAULT CHARACTER SET utf8mb4 
   COLLATE utf8mb4_unicode_ci;
   ```

2. **Import Schema & Data:**
   Execute the `FINAL DATA.sql` script via your preferred CLI or database management software:

   * **Via Command Line Interface (CLI):**

     ```bash
     mysql -u [username] -p tvondemand < "FINAL DATA.sql"
     ```

   * **Via MySQL Workbench / DBeaver:**

     1. Open the `FINAL DATA.sql` file in the SQL editor.

     2. Ensure execution is targeted at the `tvondemand` schema.

     3. Run/Execute the script.

3. **Verify Installation:**
   Run the following query to confirm data was successfully populated:

   ```sql
   USE tvondemand;
   SELECT COUNT(*) FROM actor;
   SELECT * FROM film LIMIT 10;
   ```

## 📊 Entity-Relationship Diagram

Refer to the **`ER BY WORKBENCH GENERATOR.png`** image file to review the database design and table relationships.

## 🛠️ Technologies Used

* **SQL / MySQL**: Data Definition & Manipulation Languages (DDL / DML).

* **MySQL Workbench**: ERD modeling and automated diagram generation.

* **Sakila DB Schema (v1.2)**: Reference model foundation.
