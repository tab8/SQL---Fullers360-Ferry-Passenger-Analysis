# SQL---Fullers360-Ferry-Passenger-Analysis


***DISCLAIMER***: All data is fictional and generated for portfolio/demonstration purposes only. Not affiliated with or representative of Fullers360 or any real entity.


**Overview**
A relational MySQL database modelling a fictional ferry passenger operation, designed to demonstrate practical SQL skills including schema design, constraints, relationships, and analytical querying.


**Relationships**


`passenger_records` → `routes` (Many-to-One via `route_id`)


`passenger_records` → `vessels` (Many-to-One via `vessel_id`)



**Key Features**

Primary & Foreign Keys — referential integrity across all tables


CHECK Constraints — enforcing valid vessel types, seasons, and passenger counts


UNIQUE Constraints — preventing duplicate route names, vessel names, and daily records


Soft Deletes — `is_active` flag preserves historical data without hard deleting records


Indexes — on commonly queried columns for query performance-


**Analysis Queries Included**


Record count per table


Total passengers by route


Passengers by season (Peak / Shoulder / Off-Peak)


Busiest vessel ranking


Weekend vs weekday comparison


Monthly passenger trend


Three-table JOIN with occupancy percentage


**Tools Used**


MySQL 8.0


MySQL Workbench


**How to Run**
Open `fullers360_mysql.sql` in MySQL Workbench
Execute the full script — creates database, tables, and inserts data
Run the verification queries at the bottom to confirm

🙋Created by: Mark Thomas Bundang | March 2026
