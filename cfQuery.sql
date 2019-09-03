
SELECT ceasefires.*, actors.actor_name 
   FROM ceasefires 
      JOIN head ON head.locid = ceasefires.locid 
      JOIN actors ON head.acid = actors.acid 
      JOIN locations ON head.CC = locations.CC
   WHERE locations.Location = 'Colombia' 
