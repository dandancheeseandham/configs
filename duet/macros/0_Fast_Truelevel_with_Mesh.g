;File     : Fast_TrueLevel_and_Probe.g
;Effect   : Homes, performs 3 bed-levelling routines and probes the bed for information (mesh comp. disabled afterwards)
;Use-case : Time-saving macro, in order to get the bed as level as possible and then measured to check rail alignment.
;NOTE     : you must create a bed-nodrop.g in your sys directory.Copy you bed.g and remove any G1 Z moves to save going up more and probing down.
          ; Alter the H height on the "3) Home Z" line to at least 1mm more than your typical probe height.

M561                     ; Clear bed transforms
M558 T18000 F500 H7.5    ; Match H to your M561 setting (normally 7.5mm). (T)ravel 18000 (F)Probe speed 500
                         ; A large dive height will tolerate a very uneven bed or poor calibration

G91 G1 Z7.5 F800 S2      ; Lift Z so we don't crash. match M561 & M558 probe height 
G28 X Y                  ; You can further optimise by creating a homexy-nodrop.g, calling it here and commenting out this line
;M98 P"/sys/homexy-nodrop.g" ; An optimised home X and Y script in one file (examples in config-user examples) with no Z raises or drops, to replace "G28 X Y" above

; #### 1a) Home Z - First probe with largest offset possible and fast speed
G90                      ; Absolute Positioning
G1 X150 Y150 F18000      ; Move to the center of the bed fast. (T)ravel 18000
G30                      ; Probe single Z at current location (fast). (T)ravel 18000 (F)Probe speed 150. (H)eight 7.5

; #### 1b) Home Z - second slower probe
M558 F150                ; (F)Probe speed 150 - Medium speed probe
G30                      ; Probe single Z at current location (medium)

M98 P"/sys/bed-nodrop.g" ; bed-nodrop.g is your bed.g with any G1 Z moves removed for speed.

; #### 2) Home Z - Small offset slow
M558 H3                  ; **** Set H to a dive height that you are comfortable with. ****
                         ; Set to twice your typical probe height for safety, but you can set this down to 1mm for super-fast probing.
                         ; the firmware moves the Z probe to this height above where it expects the bed to be before commencing probing. The maximum depth of probing from this position is
                         ; twice the dive height. A small dive height will make probing faster, because the Z probe has less distance to travel before reaching the bed.
M558 T15000 F50          ; (T)ravel 15000 (F)Probe speed 50
G1 X150 Y150 Z3 F15000   ; Move to the center of the bed (F)Travel speed 15000 , bring Z to 3 for first quick probe.
G30                      ; Probe single Z at current location (slow). (H)eight from M558 above

M98 P"/sys/bed-nodrop.g" ; bed-nodrop.g is your bed.g with any G1 Z moves removed for speed. (H)eight from M558 above

; #### 3) Home Z - Small offset slow
M558 T12000              ; Slower speed probe  (T)ravel 12000. (
G1 X150 Y150 F12000      ; Move to the center of the bed. (F)Travel speed 12000
G30                      ; Probe single Z at current location (slow). (H)eight from M558 above

M98 P"/sys/bed-nodrop.g" ; bed-nodrop.g is your bed.g with any G1 Z moves removed for speed.

; #### Get a mesh report
G29                      ; Probe the bed to get a mesh.
M561                     ; Clear bed transforms - stop mesh compensation being used during normal operation

; #### Put things back to conservative defaults - Match your config-user.g if possible
M558 H7.5 T6000          ; Probe height to 7.5mm , (T)ravel 6000
