# PlatinumRx Assignment

Folder structure:
- SQL/
  - 01_Hotel_Schema_Setup.sql
  - 02_Hotel_Queries.sql
  - 03_Clinic_Schema_Setup.sql
  - 04_Clinic_Queries.sql
- Spreadsheets/
  - Ticket_Analysis.xlsx (example workbook + formulas provided)
- Python/
  - 01_Time_Converter.py
  - 02_Remove_Duplicates.py

Usage:
- Load the SQL files into MySQL 8+ or PostgreSQL (adjust DATE_FORMAT -> TO_CHAR if using PG).
- Open Ticket_Analysis.xlsx in Excel or Google Sheets and review formulas in the 'README' sheet.
- Run Python scripts with Python 3.x.

Assumptions:
- Date-time formats align with 'YYYY-MM-DD hh:mm:ss'.
- MySQL 8+ used for window functions. For earlier versions, replace with equivalent subqueries/joins.
