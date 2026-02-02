# Netflix Relational Database Project

Author: Polina Adamovich

This project was completed as part of the _Managing, Querying, and Preserving Data_ class in my Data Science Master's program at the University of Pittsburgh.

## Project Overview
This project demonstrates the design and implementation of a relational database for the Netflix Movies & TV Shows dataset (sourced from Kaggle). The goal was to transform a flat, semi-structured dataset into a clean relational schema by normalizing the data to Third Normal Form (3NF), properly handling many-to-many relationships, and creating a fully queryable database.

## Conceptual Decisions & Assumptions
The original dataset contained missing values and multiple many-to-many relationships, which required explicit modeling decisions:

- ### Shows & Countries
A show can be associated with multiple production countries, while a country may produce zero or many shows. Missing country values were treated as missing data under the assumption that every show must have at least one production country.

- ### Shows & Directors
Exploratory analysis showed that some shows have multiple directors. Although the dataset includes missing director values, I assumed that every show must have at least one director and treated blanks as missing data.

- ### Shows & Actors
Actors may appear in zero or many shows. Some shows (e.g., docuseries or reality TV) legitimately have no listed cast.

- ### Shows & Genres
Each show must belong to at least one genre and may belong to many. Genres themselves may be associated with zero or many shows.

- ### Shows & Maturity Ratings
Each show is assigned exactly one maturity rating, while a rating category may apply to multiple shows.

These assumptions guided the use of lookup tables and intersection tables to enforce referential integrity while keeping the schema normalized.
  
## Database Design
### Entities
The dataset was decomposed into 11 tables:

#### Core Tables
- `SHOW_DETAILS`: Central table containing single-valued, non-redundant attributes (e.g., title, release year, duration).
- `COUNTRY`
- `DIRECTOR`
- `ACTOR`
- `SHOW_GENRE`
- `SHOW_TYPE`: Each show has exactly one type (e.g., Movie or TV Show).
- `MATURITY_RATING`

#### Intersection Tables
- `SHOW_COUNTRY_INT`
- `SHOW_DIRECTOR_INT`
- `SHOW_ACTOR_INT`
- `SHOW_GENRE_INT`

These intersection tables manage all many-to-many relationships in the schema.

### Logical & Physical Design
- All tables are normalized to 3NF.
- Minor changes were made when transitioning from the logical to the physical model:
  - Duration Splitting: The source `Duration` field (e.g., “90 min”, “2 Seasons”) was split into `Duration_Value` and `Duration_Unit` for cleaner analysis.
  - Automatic Timestamps: A `Last_Updated` column was added to `SHOW_DETAILS` to track row modifications.
- The final schema minimizes redundancy while supporting flexible and efficient querying.

## Data Loading & Cleaning
- The data loading stage required extensive preprocessing:
- Splitting comma-separated values for actors, directors, and genres.
- Parsing full names into `First_Name` and `Last_Name`.
- Converting duration strings into numeric and unit components.
- Handling missing values in mandatory fields by inserting standardized "Unknown" placeholders.
- Adjusting ENUM fields to VARCHAR to simplify data loading.

## Lessons Learned
This project was a valuable exercise in designing and implementing a relational database from real-world data. It strengthened my SQL skills and reinforced the importance of normalization, careful constraint design, and data cleaning. While some non-Latin characters were imported inconsistently, I am confident in the overall structure and integrity of the database.

## What’s in this Folder
- Physical_Diagram.png: A visual of the final database structure.
  
- 01_db_setup.sql: DDL statements creating all tables, primary and foreign keys, constraints, and a VIEW reconstructing the original dataset.

- 02_data_loading.sql: DML statements used to clean and populate the database.

- 03_data_analysis.sql: Example analytical SQL queries demonstrating how the database can be queried.

- netflix_sample.csv: A 100-row sample of the original dataset for quick testing.
