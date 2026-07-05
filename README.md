# Hospital Management Analytics Dashboard

## 📊 Overview

This project demonstrates an end-to-end Business Intelligence workflow using a simulated hospital dataset, covering revenue tracking, collections performance, patient demographics, and clinical insights. The solution was built using MySQL for data preparation and Power BI for data modeling, DAX, Power Query, and interactive dashboard development.

---

## 🎯 Business Problem

Hospitals collect and bill patients, but not every rupee billed actually gets paid. Without a clear view of the numbers, it's hard for hospital management to answer basic but important questions:

- How much money is the hospital actually collecting versus how much is still pending?
- Which payment methods (Cash, Card, UPI, Insurance) are performing worst when it comes to getting paid?
- Which departments bring in the most revenue, and which patients are being treated for what?
- Is patient satisfaction consistent across departments, or are some falling behind?

Without a dashboard, these answers are scattered across raw records, making it slow to spot problems or make decisions.

## ✅ Solution

This dashboard brings all of that data into one place and turns it into clear, visual answers:

- A single view of **total revenue, total collected, and total pending**, so leadership can immediately see the size of the collections gap
- A breakdown of **collection performance by payment mode and department**, showing exactly where money is being left uncollected
- **Patient demographic and clinical breakdowns**, so the hospital understands who it treats and where feedback is lowest
- A **drillthrough view** that lets anyone click into a department and instantly see the individual patient records behind the summary numbers

In short: instead of digging through raw data, hospital managers can quickly monitor financial performance, patient trends, and collection efficiency without analyzing raw data.

---

## ✨ Features

- Interactive KPI cards for revenue, collections, pending amount, patient count, and average rating.
- Dynamic slicers for Year, Department, Gender, and Age Group
- Drill-through navigation from summary charts to patient-level detail
- Dynamic, context-aware page titles based on the selected department
- Department-level revenue and collection analysis
- Payment mode performance comparison
- Patient demographics and diagnosis breakdown
- Custom sidebar navigation across all pages

---

## 🗂️ Dashboard Pages

| Page | Purpose |
|---|---|
| **Home** | Landing page with dashboard overview and navigation |
| **Executive Summary** | High-level KPIs — revenue, collection rate, patient count, and department performance |
| **Financial Insights** | Collection rate breakdown by payment mode and department, billing status distribution |
| **Patient Insights** | Diagnosis distribution, age/gender demographics, feedback ratings by department |
| **Patient Details** *(hidden, drillthrough only)* | Record-level patient detail, dynamically filtered and titled based on the department drilled into |

---

## 🏗️ Data Model

- **Fact table:** `hospital_management` — 10,000 patient visit records
- **Dimension table:** `DimDate` — custom calendar table built with `CALENDAR()`, supporting time-based slicing
- **Relationships:** One-to-many, `DimDate[Date]` → `hospital_management[AdmissionDate]`

**Calculated columns added:**
- `AgeGroup` — banded age categories for demographic analysis
- `PaymentStatus` — Fully Paid / Partially Paid / Unpaid, derived from payment ratio thresholds

---

## 🧮 Key DAX Measures

Developed custom DAX measures for:
- Revenue, collections, and pending amount KPIs
- Collection rate calculation
- Payment mode collections (Cash, Card, UPI, Insurance)
- Patient count and surgery rate
- Average age and average length of stay
- Dynamic page titles for drill-through navigation

---

## 🧹 Data Cleaning Process

The dataset started as a randomly generated 10,000-record CSV, so most fields were evenly distributed with little real-world variation. Significant cleanup was done directly in **MySQL** before building the dashboard:

1. **Data profiling** — checked for realistic patterns and correlation between fields
2. **Realistic variance** — adjusted billing amounts and collection rates based on department, room type, and payment mode, so numbers reflect real-world patterns instead of flat randomness
3. **Data reconciliation** — verified `AmountPaid + PendingAmount = TotalBillAmount` holds true across all 10,000 rows
4. **Diagnosis correction** — remapped `Diagnosis` values to match `Department` (e.g., Cardiology → Hypertension/Diabetes, Ortho → Fracture/Hypertension), fixing an unrealistic random pairing in the original data

---

## 📈 Key Insights

- Surgery and Neurology generated the highest revenue.
- Overall collection rate is **57.75%**.
- UPI achieved the highest collection rate.
- 12% of accounts remain unpaid.
- Patient feedback varies across departments.
---

## 🛠️ Tech Stack

- **Power BI Desktop** — Data modeling, Power Query, DAX, and dashboard development
- **MySQL / MySQL Workbench** — Data cleaning and transformation
- **DAX** — KPI calculations and business metrics

---

## 📁 Repository Contents

├── Hospital_Management.pbix
├── sql/
│   └── 01Changes.sql
├── screenshots/
├── icons/
└── README.md
