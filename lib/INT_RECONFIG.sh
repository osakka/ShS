#!/bin/bash
# Change Interface State.

STATE="$1";
INT="$2";
VINT="$3";
RIP="$4";
VIP="$5";
MASK="$6";
RMAC="$7";
VMAC="$8";
DGW="$9";

I="/sbin/ifconfig";
R="/sbin/route";

function die() {
  echo "$0: [state int vint rip vip mask rmac vmac gw] required";
  exit 3;
}

[ -z "$1" -o \
  -z "$2" -o \
  -z "$3" -o \
  -z "$4" -o \
  -z "$5" -o \
  -z "$6" -o \
  -z "$7" -o \
  -z "$8" -o \
  -z "$9" ] && die;

case "$STATE" in
   active) $I $INT down &&
            $I $INT hw ether $VMAC &&
             $I $INT $VIP netmask $MASK up &&
              $I $INT:$VINT $RIP netmask $MASK up && 
               $R add default gw $DGW && {
                 echo "ok";
                 exit 0; 
              }
           ;; 
   backup) $I $INT:$VINT down;
           $I $INT down &&
            $I $INT hw ether $RMAC &&
             $I $INT $RIP netmask $MASK up &&
               $R add default gw $DGW && {
                 echo "ok";
                 exit 0;
              }
           ;;
        *) die; ;;
esac

echo "fail";
exit 1;

