-- =========================================================
-- COLLEGE PLACEMENT FUNNEL ANALYZER
-- SQL Queries for Business Questions Q1-Q10
-- Tool: MySQL
-- =========================================================

-- Q1: What is the overall funnel drop-off rate across rounds?
SELECT 
    COUNT(student_id) AS total_students,
    SUM(CASE WHEN round1_status = 'Pass' THEN 1 ELSE 0 END) AS round1_pass_count,
    SUM(CASE WHEN round2_status = 'Pass' THEN 1 ELSE 0 END) AS round2_pass_count,
    SUM(CASE WHEN round3_status = 'Pass' THEN 1 ELSE 0 END) AS round3_pass_count,
    ROUND(SUM(CASE WHEN round1_status = 'Pass' THEN 1 ELSE 0 END) * 100.0 / COUNT(student_id), 2) AS round1_pct,
    ROUND(SUM(CASE WHEN round2_status = 'Pass' THEN 1 ELSE 0 END) * 100.0 / COUNT(student_id), 2) AS round2_pct,
    ROUND(SUM(CASE WHEN round3_status = 'Pass' THEN 1 ELSE 0 END) * 100.0 / COUNT(student_id), 2) AS round3_pct
FROM placements;


-- Q2: What is the year-over-year placement trend?
SELECT 
    year,
    COUNT(student_id) AS total_students,
    SUM(CASE WHEN final_offer = 'Yes' THEN 1 ELSE 0 END) AS total_offers,
    ROUND(SUM(CASE WHEN final_offer = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(student_id), 2) AS selection_pct
FROM placements
GROUP BY year
ORDER BY year;


-- Q3: Which branch has the highest final offer rate?
SELECT 
    branch,
    COUNT(student_id) AS total_students,
    SUM(CASE WHEN final_offer = 'Yes' THEN 1 ELSE 0 END) AS total_offers,
    ROUND(SUM(CASE WHEN final_offer = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(student_id), 2) AS selection_pct
FROM placements
GROUP BY branch
ORDER BY selection_pct DESC;


-- Q4: At which round does each branch experience the highest drop-off?
SELECT 
    branch,
    COUNT(student_id) AS total_students,
    SUM(CASE WHEN round1_status = 'Pass' THEN 1 ELSE 0 END) AS round1_pass,
    SUM(CASE WHEN round2_status = 'Pass' THEN 1 ELSE 0 END) AS round2_pass,
    SUM(CASE WHEN round3_status = 'Pass' THEN 1 ELSE 0 END) AS round3_pass,
    ROUND(SUM(CASE WHEN round1_status = 'Pass' THEN 1 ELSE 0 END) * 100.0 / COUNT(student_id), 2) AS round1_pct,
    ROUND(SUM(CASE WHEN round2_status = 'Pass' THEN 1 ELSE 0 END) * 100.0 / COUNT(student_id), 2) AS round2_pct,
    ROUND(SUM(CASE WHEN round3_status = 'Pass' THEN 1 ELSE 0 END) * 100.0 / COUNT(student_id), 2) AS round3_pct
FROM placements
GROUP BY branch
ORDER BY branch;


-- Q5: Does having SQL/Python skills improve selection rate?
SELECT 
    has_sql_skill,
    COUNT(student_id) AS total_students,
    SUM(CASE WHEN final_offer = 'Yes' THEN 1 ELSE 0 END) AS total_offers,
    ROUND(SUM(CASE WHEN final_offer = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(student_id), 2) AS selection_pct
FROM placements
GROUP BY has_sql_skill;

SELECT 
    has_python_skill,
    COUNT(student_id) AS total_students,
    SUM(CASE WHEN final_offer = 'Yes' THEN 1 ELSE 0 END) AS total_offers,
    ROUND(SUM(CASE WHEN final_offer = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(student_id), 2) AS selection_pct
FROM placements
GROUP BY has_python_skill;


-- Q6: Is the impact of SQL skill stronger in the technical round or the final outcome?
SELECT 
    has_sql_skill,
    COUNT(student_id) AS total_students,
    ROUND(SUM(CASE WHEN round2_status = 'Pass' THEN 1 ELSE 0 END) * 100.0 / COUNT(student_id), 2) AS round2_pct,
    ROUND(SUM(CASE WHEN round3_status = 'Pass' THEN 1 ELSE 0 END) * 100.0 / COUNT(student_id), 2) AS round3_pct
FROM placements
GROUP BY has_sql_skill;


-- Q7: How does CGPA band affect selection rate?
SELECT 
    CASE 
        WHEN cgpa >= 6.0 AND cgpa < 7.0 THEN '6-7'
        WHEN cgpa >= 7.0 AND cgpa < 8.0 THEN '7-8'
        WHEN cgpa >= 8.0 AND cgpa < 9.0 THEN '8-9'
        ELSE '9+'
    END AS cgpa_band,
    COUNT(student_id) AS total_students,
    SUM(CASE WHEN final_offer = 'Yes' THEN 1 ELSE 0 END) AS total_offers,
    ROUND(SUM(CASE WHEN final_offer = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(student_id), 2) AS selection_pct
FROM placements 
GROUP BY cgpa_band 
ORDER BY cgpa_band;


-- Q8: Does a high CGPA (9+) guarantee selection?
SELECT 
    COUNT(student_id) AS total_9plus_students,
    SUM(CASE WHEN round1_status = 'Fail' THEN 1 ELSE 0 END) AS failed_round1,
    SUM(CASE WHEN round2_status = 'Fail' THEN 1 ELSE 0 END) AS failed_round2,
    SUM(CASE WHEN round3_status = 'Fail' THEN 1 ELSE 0 END) AS failed_round3,
    SUM(CASE WHEN final_offer = 'Yes' THEN 1 ELSE 0 END) AS got_offer,
    ROUND(SUM(CASE WHEN final_offer = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(student_id), 2) AS selection_pct
FROM placements
WHERE cgpa >= 9.0;


-- Q9: Which company has the highest/lowest selection rate?
SELECT 
    company_name,
    COUNT(student_id) AS total_students,
    SUM(CASE WHEN final_offer = 'Yes' THEN 1 ELSE 0 END) AS total_offers,
    ROUND(SUM(CASE WHEN final_offer = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(student_id), 2) AS selection_pct
FROM placements
GROUP BY company_name
ORDER BY selection_pct DESC;


-- Q10: Does the round-wise drop-off pattern vary across companies?
SELECT 
    company_name,
    COUNT(student_id) AS total_students,
    ROUND(SUM(CASE WHEN round1_status = 'Pass' THEN 1 ELSE 0 END) * 100.0 / COUNT(student_id), 2) AS round1_pct,
    ROUND(SUM(CASE WHEN round2_status = 'Pass' THEN 1 ELSE 0 END) * 100.0 / COUNT(student_id), 2) AS round2_pct,
    ROUND(SUM(CASE WHEN round3_status = 'Pass' THEN 1 ELSE 0 END) * 100.0 / COUNT(student_id), 2) AS round3_pct
FROM placements
GROUP BY company_name
ORDER BY company_name;
