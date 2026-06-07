WITH skills_demand as (
    SELECT skills_dim.skill_id,
        skills_dim.skills,
        COUNT (skills_job_dim.job_id) as Demand_Count
    FROM job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst'
        AND job_work_from_home = TRUE
        AND salary_year_avg is NOT NULL
    GROUP BY skills_dim.skill_id
),
Avg_Salary as (
    SELECT skills,
        skills_dim.skill_id,
        round(avg(salary_year_avg), 0) as Salary
    FROM job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst'
        AND salary_year_avg is NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY skills_dim.skill_id
)
SELECT skills_demand.skill_id,
    skills_demand.skills,
    Demand_Count,
    Salary
from skills_demand
    INNER join Avg_Salary on skills_demand.skill_id = Avg_Salary.skill_id
WHERE Demand_Count > 10
ORDER BY Demand_Count DESC,
    Salary DESC