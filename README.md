# College Placement Funnel Analyzer

A SQL-based analytics project that investigates drop-off patterns across a multi-round campus recruitment process.

## Project Overview

The College Placement Funnel Analyzer is a SQL-based analytics project that investigates drop-off patterns across a multi-round campus recruitment process. Using a simulated dataset of 1000 student records, this project applies SQL aggregation, conditional logic (`CASE`/`CASE WHEN`), and grouped analysis to answer 10 business questions — identifying which factors (CGPA, technical skills, branch, company) most influence selection outcomes, and at which exact stage of the funnel candidates are most likely to be filtered out.

## Dataset Description

- 1000 simulated student records
- **Columns:** `student_id`, `name`, `branch`, `cgpa`, `has_sql_skill`, `has_python_skill`, `company_name`, `role_type`, `year`, `round1_status`, `round2_status`, `round3_status`, `final_offer`
- **Tool used:** MySQL

## Business Questions & Analysis

### Q1: What is the overall funnel drop-off rate across rounds?

**Result:**
| Stage | Count | % of Total |
|---|---|---|
| Total Students | 1000 | 100% |
| Round 1 Pass | 608 | 60.80% |
| Round 2 Pass | 348 | 34.80% |
| Round 3 Pass / Final Offer | 194 | 19.40% |

**Insight:** The overall selection rate is only 19.4% (roughly 1 in 5 applicants receive an offer). Round 1 (resume/aptitude screening) acts as the single largest filter, eliminating nearly 40% of all applicants. However, once a candidate clears Round 1, the conversion rate for Round 1→2 (57.2%) and Round 2→3 (55.7%) is remarkably similar — meaning each subsequent round carries roughly the same level of risk, rather than getting progressively harder or easier.

---

### Q2: What is the year-over-year placement trend?

**Result:**
| Year | Selection % |
|---|---|
| 2023 | 19.23% |
| 2024 | 21.26% |
| 2025 | 17.68% |

**Insight:** Selection rate remains relatively stable across the three years, with no clear upward or downward trend. The minor fluctuations suggest a consistent placement process rather than improving or declining hiring conditions.

---

### Q3: Which branch has the highest final offer rate?

**Result:**
| Branch | Selection % |
|---|---|
| ECE | 26.51% |
| Civil | 25.27% |
| Mechanical | 18.08% |
| IT | 16.55% |
| CSE | 15.00% |
| Electrical | 13.95% |

**Insight:** ECE and Civil show the highest selection rates, while CSE and Electrical show the lowest. Cross-referencing with skill-based (Q5) and CGPA-based (Q7) analysis showed no meaningful correlation between branch and these factors, confirming this variation is likely due to sample randomness rather than a genuine branch-based pattern.

---

### Q4: At which round does each branch experience the highest drop-off?

**Result:**
| Branch | Round 1 % | Round 2 % | Round 3 % |
|---|---|---|---|
| Civil | 59.68% | 39.25% | 25.27% |
| CSE | 56.88% | 30.63% | 15.00% |
| ECE | 63.86% | 40.96% | 26.51% |
| Electrical | 63.37% | 32.56% | 13.95% |
| IT | 56.12% | 29.50% | 16.55% |
| Mechanical | 63.84% | 34.46% | 18.08% |

**Insight:** Electrical branch shows the steepest drop-off at the Round 1→2 transition (technical round), losing 30.81 percentage points — the highest among all branches. This suggests Electrical students clear initial screening reasonably well but face the most difficulty in technical assessments. Civil branch shows the most consistent performance across all stages, with comparatively smoother drop-offs.

---

### Q5: Does having SQL/Python skills improve selection rate?

**Result:**
| Skill | Has Skill | No Skill | Gap |
|---|---|---|---|
| SQL | 21.55% | 17.11% | +4.44 pp |
| Python | 19.92% | 18.93% | +0.99 pp |

**Insight:** SQL skill shows a meaningful positive correlation with selection rate (+4.44 percentage points), while Python skill shows a much weaker effect (+0.99 percentage points) — close enough to be within normal variation. This suggests SQL proficiency may carry more weight in the selection process represented by this dataset compared to Python.

---

### Q6: Is the impact of SQL skill stronger in the technical round or the final outcome?

**Result:**
| | Round 2 % | Round 3 % |
|---|---|---|
| No SQL | 28.66% | 17.11% |
| Has SQL | 40.58% | 21.55% |
| **Gap** | **+11.92 pp** | **+4.44 pp** |

**Insight:** SQL skill has a much stronger impact at the technical round stage (11.92 pp gap) compared to the final offer stage (4.44 pp gap). This suggests SQL proficiency primarily helps candidates clear technical screening, while other factors (likely communication/soft skills) play a larger role in the final HR round.

---

### Q7: How does CGPA band affect selection rate?

**Result:**
| CGPA Band | Selection % |
|---|---|
| 6-7 | 14.07% |
| 7-8 | 17.13% |
| 8-9 | 20.52% |
| 9+ | 27.06% |

**Insight:** CGPA shows a clear, consistent, monotonically increasing relationship with selection rate — nearly doubling from the lowest band (14.07%) to the highest band (27.06%). This is the strongest and most predictable correlation observed across all factors analyzed in this project, making CGPA the single most influential variable for placement success in this dataset.

---

### Q8: Does a high CGPA (9+) guarantee selection?

**Result:**
| Metric | Value |
|---|---|
| Total 9+ CGPA students | 218 |
| Got offer | 59 (27.06%) |
| Failed Round 1 | 66 |
| Failed Round 2 | 45 |
| Failed Round 3 | 48 |

**Insight:** Despite having the highest CGPA band, nearly 73% of 9+ CGPA students did not receive an offer. Failures were distributed fairly evenly across all three rounds (66, 45, 48), proving that high CGPA alone is not sufficient for selection — it improves odds but doesn't guarantee outcomes, reinforcing that round-specific performance and skills still matter significantly.

---

### Q9: Which company has the highest/lowest selection rate?

**Result:**
| Company | Selection % |
|---|---|
| Capgemini | 23.91% (highest) |
| HCL | 22.00% |
| Cognizant | 20.83% |
| Amazon | 20.41% |
| Deloitte | 20.00% |
| Wipro | 19.13% |
| EY | 18.26% |
| TCS | 17.48% |
| Infosys | 17.44% |
| Accenture | 15.24% (lowest) |

**Insight:** Selection rates range from 15.24% (Accenture) to 23.91% (Capgemini) across companies — an 8.67 percentage point gap. Since company assignment in this dataset was randomized rather than tied to a deliberate difficulty factor, this variation likely reflects sample randomness. In a real-world dataset, this same query would reveal genuine differences in company-specific hiring stringency.

---

### Q10: Does the round-wise drop-off pattern vary across companies?

**Result:**
| Company | Round 1 % | Round 2 % | Round 3 % |
|---|---|---|---|
| Accenture | 60.00% | 30.48% | 15.24% |
| Amazon | 57.14% | 32.65% | 20.41% |
| Capgemini | 58.70% | 38.04% | 23.91% |
| Cognizant | 56.25% | 33.33% | 20.83% |
| Deloitte | 56.67% | 31.11% | 20.00% |
| EY | 60.87% | 33.91% | 18.26% |
| HCL | 63.00% | 40.00% | 22.00% |
| Infosys | 67.44% | 39.53% | 17.44% |
| TCS | 65.05% | 38.83% | 17.48% |
| Wipro | 62.61% | 31.30% | 19.13% |

**Insight:** All companies show a broadly consistent funnel shape — the steepest drop-off occurs at Round 1→2 (technical screening) across the board (-19% to -30%), followed by a smaller drop at Round 2→3 (-11% to -22%). No company shows a drastically different pattern, which aligns with the random nature of company assignment in this simulated dataset. Companies with smaller R1→2 drops (Capgemini, Wipro) also showed higher overall selection rates in Q9, reinforcing internal consistency of the findings.

## Key Findings / Summary

This analysis examined the placement funnel across 1000 simulated student records, identifying where and why candidates drop off in the recruitment process. CGPA emerged as the strongest predictor of selection — moving from the lowest to highest CGPA band nearly doubled the offer rate (14% to 27%) — though even top-CGPA students faced a 73% rejection rate, confirming that high CGPA alone is not sufficient. SQL proficiency showed a meaningful positive impact (+4.4 percentage points), concentrated mainly at the technical screening stage, while Python skill showed minimal effect. Round 1 (resume/aptitude screening) was identified as the single largest filter across the entire funnel, eliminating ~40% of applicants before technical assessment even begins. Branch and company-level variations were observed but did not show consistent patterns when cross-validated against skill and CGPA factors, suggesting these differences are likely attributable to sample variation in this dataset rather than systemic bias.

## Tech Stack

SQL (MySQL), CASE statements, Aggregate Functions, GROUP BY, Subqueries, WHERE clause filtering

## Files in this Repository

- `placement_data.csv` — Simulated dataset (1000 records)
- `queries.sql` — All 10 SQL queries used in this analysis
- `README.md` — This file (full analysis and insights)
