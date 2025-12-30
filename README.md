This project focuses on building a production-style relational healthcare database and delivering analytical insights through advanced SQL.

I designed and developed a fully normalized MySQL database consisting of Patients, Doctors, Hospitals, Appointments, Payments, and appointment tables, ensuring referential integrity with primary/foreign keys, cascading rules, indexes, and constraints. Each entity was populated with 1,000+ synthetic yet realistic records to mimic large-scale healthcare operations.

On top of this data layer, I built a SQL analytics workflow, where I wrote and optimized complex SQL queries—including multi-table joins, CTEs, and window functions—to extract actionable healthcare KPIs. The analysis delivers insights such as:

📊 HCP / Patient activity metrics – patient touchpoints, repeat visits, and appointment behavior

💰 Patient Lifetime Value (LTV) based on treatment costs and recurring payments

🏨 Hospital utilization – occupancy ratios, patient flow, throughput, and wait-time patterns

👨‍⚕️ Doctor workload analytics – volume of appointments per clinician, utilization %, cancellations

❌ Cancellation behavior – cancellation rate by patient segment, doctor, time of day

📈 Financial & Revenue trends – payment volume, outstanding balances, revenue growth by hospital

🗓️ Time-based trends – monthly appointment volume, demand spikes, seasonality

⛓️ Data Quality & Governance:
Implemented validation rules such as NOT NULL checks, controlled vocabularies, uniqueness constraints, foreign-key relationships, and referential-integrity tests. Robust cleaning logic helped ensure standardized patient demographics, hospital metadata, appointment timestamps, and payment formats.

⚙️ Technical Stack / Features:

MySQL Workbench – schema design (ERD), DDL creation, indexes
Synthetic data generation using Python & SQL insert scripts
Query optimization (EXPLAIN plan review, index tuning)
KPI reporting queries suitable for BI ingestion (Power BI / Tableau)
