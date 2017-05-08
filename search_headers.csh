#!/bin/csh -f

# Name: search_headers.csh
# Author: Evan Keane
# Description: A quick and dirty script to find the nearest PMPS beam to a queried sky position
# Date: 10/11/2011

if ( $#argv != 3 ) then
    goto usage
endif
set raj = $1
set decj = $2
set tolerance = $3    # tolerance in arc minutes

set raj_deg = `echo $raj | sed s/:/" "/g | awk '{print (((($3/60.0)+$2)/60.0)+$1)*15.0}'`
set decj_deg = `echo $decj | sed s/:/" "/g | awk '{if ($1>0.0) print ((($3/60.0)+$2)/60.0)+$1; if ($1<0.0) print -((($3/60.0)+$2)/60.0)+$1}'`
set tolerance_deg = `echo $tolerance | awk '{print $1/60.0}'`
#echo $raj_deg $decj_deg $tolerance

cat ~`whoami`/Work/LISTS/PMPS_HEADERS/BIGHEADERFILE_1_70 ~`whoami`/Work/LISTS/PMPS_HEADERS/BIGHEADERFILE_71_127 ~`whoami`/Work/LISTS/PMPS_HEADERS/BIGHEADERFILE_128_161 ~`whoami`/Work/LISTS/PMPS_HEADERS/BIGHEADERFILE_PRO_BLEM | awk -v ra=$raj_deg -v dec=$decj_deg -v tol=$tolerance_deg '{deg2rad=3.13149/180.0; rad2deg=180.0/3.14159; costheta=sin(dec*deg2rad)*sin($3*deg2rad)+cos(dec*deg2rad)*cos($3*deg2rad)*cos((ra-$2)*deg2rad); theta=rad2deg*atan2(sqrt(1-(costheta)*(costheta)),costheta); thetapositive=sqrt((theta)^2); if (thetapositive < tol) print $1,$4,$5,theta*60.0}'

goto death

usage:
    echo "Usage: search_headers.csh RA DEC TOLERANCE_ARCMIN"
    echo ""
    echo "Outputs: PMPS_BEAM RA_BEAM DEC_BEAM OFFSET_ARCMIN"
    goto death
death:
    exit
