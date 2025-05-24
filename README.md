# 🏭US_Candy-_Distribution_SQL
![ Cover](Profile.jpg)
## 🍬 About the Project
This is a self-guided SQL portfolio project where we load and analyze a real-world candy distribution dataset. Our goal is to showcase core SQL skills while answering meaningful business questions.

---

## 🎯 Objectives
- **Learn & Demonstrate** advanced SQL techniques on a mid-size dataset (~10 000 rows).  
- **Solve Real Business Problems**: identify high-margin SKUs, optimize routes, and compare actual sales to division targets.  
- **Produce Portfolio-Ready Deliverables**: clean database schema, documented GitHub repo, and clear ER diagram.

---

## 🗂️ Data Source & Context
- **Source**: Maven Analytics “US Candy Distributor” CSV export  
- **Why This Data?**  
  - **Balanced Size**: Large enough to require meaningful SQL, small enough for rapid iteration.  
  - **Geospatial & Time Series**: Contains lat/longs, order dates, shipping info—perfect for joins, distance calculations, and time-based analyses.  
  - **Business Relevance**: SKU-level sales, factory origins, customer locations, and division targets mimic typical retail/distribution analytics.

---

## 📑 Phase 1: Business & Data Understanding

1. **Project Setup**  
   - 🤝 Created a dedicated PostgreSQL database `candy_distributor`.  
   - 🗂️ Initialized VS Code workspace & Git repo.

2. **Schema Design & Table Creation**  
   - Drafted `schema.sql` with DDL for five tables:  
     - `factories` (factory_id, name, lat, long)  
     - `targets` (division, the_target)  
     - `products` (division ▶ targets, product_name, factory_name ▶ factories, product_id, unit_price, unit_cost)  
     - `us_zips` (zip, lat, lng, city, state, county, population, density, timezone)  
     - `sales` (row_id, dates, customer info, postal_code ▶ us_zips, division ▶ targets, product_id ▶ products, financials)

3. **Data Ingestion**  
   - 🚚 Converted each Excel sheet to UTF-8 CSV.  
   - 📥 Used server-side `COPY` in VS Code to load `factories`, `targets`, `products`, `us_zips`, and `sales`.  
   - 🔄 Handled format quirks: re-created `us_zips` to match all CSV columns, set `DateStyle = 'DMY'` for `DD-MM-YY` dates.

4. **ER Diagram & Relationships**  
   - Diagrammed table joins:  
     ```
     FACTORIES ||--o{ PRODUCTS   : factory_name  
     TARGETS   ||--o{ PRODUCTS   : division  
     TARGETS   ||--o{ SALES      : division  
     PRODUCTS  ||--o{ SALES      : product_id  
     US_ZIPS   ||--o{ SALES      : postal_code  
     ```  
   - Ensured referential integrity via FKs on `division`, `factory_name`, `factory_id`, `product_id`, and `postal_code`.

5. **Validation & Cleanup**  
   - ✅ Verified row counts for each table matched CSV sources.  
   - 🧹 Dropped unused columns from `us_zips` to keep only zip, zcta, state, county, population, density, timezone.  
   - ✔️ Committed `schema.sql`, import scripts, and ER diagram to GitHub.

> With Phase 1 complete, our foundation is rock-solid. Next up: **Phase 2 – Data Cleaning & Transformation!**  

