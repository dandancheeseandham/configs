M561                         ; clear any existing bed transform
G1 Z5						 ; _RRF3_ remove S2 
G30 P0 X30 Y35 Z-99999       ;
G30 P1 X280 Y35 Z-99999      ;
G30 P2 X280 Y265 Z-99999     ;
G30 P3 X30 Y265 Z-99999 S3   ;
G1 X0 Y0 F5000               ; move the head to the corner (optional)
