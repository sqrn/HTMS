CREATE OR REPLACE PACKAGE BODY HTMS
AS
  FUNCTION distance(lat1_in IN NUMBER,
                    lon1_in IN NUMBER,
                    lat2_in IN NUMBER,
                    lon2_in IN NUMBER,
                    radius IN NUMBER DEFAULT 6387.7)
  RETURN NUMBER
  IS
     -- Convert degrees to radians
    l_deg_to_rad number := 57.29577951;
  BEGIN
    RETURN(NVL(radius,0) * ACOS((sin(NVL(lat1_in,0) / l_deg_to_rad) * SIN(NVL(lat2_in,0) / l_deg_to_rad)) +
          (COS(NVL(lat1_in,0) / l_deg_to_rad) * COS(NVL(lat2_in,0) / l_deg_to_rad) *
           COS(NVL(lon2_in,0) / l_deg_to_rad - NVL(lon1_in,0)/ l_deg_to_rad))));
  END;
  
  FUNCTION count_cost
  RETURN NUMBER
  IS
  BEGIN
    NULL;
  END;
  
  FUNCTION count_distance
  RETURN NUMBER
  IS
  BEGIN
    NULL;
  END;
  
  FUNCTION find_nearest_hub(shipno_in NUMBER, type_in VARCHAR2 DEFAULT 'LOAD')
  RETURN NUMBER
  IS
    CURSOR hub_cur IS
      SELECT * FROM hubs;
    l_ship_lat   shipments.load_lat%TYPE;
    l_ship_lon   shipments.load_lon%TYPE;
    TYPE hubs_aat IS TABLE OF hubs%ROWTYPE
      INDEX BY PLS_INTEGER;
    l_hubs hubs_aat;
    l_distance_pont   NUMBER := 0;
    l_distance        NUMBER;
    l_hub_target_id   NUMBER;
    l_hubname         hubs.hubname%TYPE;
  BEGIN
    DBMS_OUTPUT.put_line('I am looking for the nearest HUB');
    OPEN hub_cur;
    LOOP
      FETCH hub_cur BULK COLLECT INTO l_hubs;
      
      IF type_in = 'UNLOAD' THEN
        SELECT unload_lat, unload_lon INTO
          l_ship_lat, l_ship_lon 
        FROM shipments WHERE num = shipno_in;
      ELSE
        SELECT load_lat, load_lon INTO
          l_ship_lat, l_ship_lon 
        FROM shipments WHERE num = shipno_in;
      END IF;
      
        FOR indx IN 1 .. l_hubs.COUNT
        LOOP
          l_distance      := l_distance_pont; -- before distance (initial=0)
          l_distance_pont := htms.distance(
            l_ship_lat,
            l_ship_lon,
            l_hubs(indx).latitude,
            l_hubs(indx).longtitude); -- estimate current distance
          IF l_distance_pont < l_distance THEN
            l_hub_target_id := l_hubs(indx).hub_id; -- save hub id
          END IF; 
        END LOOP;
      EXIT WHEN l_hubs.COUNT = 0;
    END LOOP;
    SELECT hubname INTO l_hubname 
      FROM hubs
      WHERE hub_id = l_hub_target_id;
    
    DBMS_OUTPUT.PUT_LINE('shipment: '
      || shipno_in 
      || '; HUB name for '
      || type_in
      || ' point: '
      || l_hubname
      || ' distance: '
      || l_distance_pont);

    CLOSE hub_cur;
    RETURN l_hub_target_id;
  END;
  
  PROCEDURE generate_population
  IS
  BEGIN
    NULL;
  END;
  
  PROCEDURE generate_candidate
  IS
  BEGIN
    NULL;
  END;
  
  PROCEDURE search
  IS
  BEGIN
    NULL;
  END;
  
  PROCEDURE find_best
  IS
  BEGIN
    NULL;
  END;
  
  PROCEDURE update_tabu
  IS
  BEGIN
    NULL;
  END;
END;
/