# Pewlett_Hackard_Analysis_ADominguez-
Create Entity Relationship Diagrams(ERDs), perform data modeling, and complete analysis on an employee database using SQL techniques.

BRIEF PROJECT SUMMARY
      A company's baby boomer cohort wil be retiring at a rapid rate. The compnay wants to 
      who would be retiring in the next few years, who would meet the crietria for retirement packages
      and how many positions will come available as a result. The database analysis will future proof 
      the company by generating a list of all employees getting ready to retire, who is eligible for the retirement package and retirees       who could be potential mentors and a resource for the company. 
      
      The following are the findings from the database analysis:   
        Number of Individuals retiring: 443,308
        Number of Individuals being hired: 32,860
        Number of individuals available for mentorship role:2382
      
      Recommendation for further analysis on this data set.
      Further analysis of this data set could involve quering for a list of eligible retirees per department by title by date.
      
      

PNG OF YOUR ERD









Code for the requested queries, with examples of each output:

                  -----Part 1: Number of [titles] Retiring---------

SELECT cur.emp_no,
	   cur.first_name,
	   cur.last_name,
	   cur.to_date,
	   t.title
INTO ret_titles
FROM current_emp as cur
RIGHT JOIN titles as t
ON cur.emp_no = t.emp_no;

SELECT * FROM ret_titles


Examples of each output:
