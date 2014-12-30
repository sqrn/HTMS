CREATE OR REPLACE PACKAGE HTMS -- Heurystic Transport Management System
AS
  FUNCTION distance(lat1_in IN NUMBER,
                    lon1_in IN NUMBER,
                    lat2_in IN NUMBER,
                    lon2_in IN NUMBER,
                    radius IN NUMBER DEFAULT 6387.7)
  RETURN NUMBER;
  
  FUNCTION count_cost
  RETURN NUMBER;
  
  FUNCTION find_nearest_hub(shipno_in NUMBER, type_in VARCHAR2 DEFAULT 'LOAD')
  RETURN NUMBER;
  
  FUNCTION count_distance
  RETURN NUMBER;
  
  PROCEDURE generate_population;
  
  PROCEDURE generate_candidate;
  
  PROCEDURE search;
  
  PROCEDURE find_best;
  
  PROCEDURE update_tabu; 
END HTMS;
/