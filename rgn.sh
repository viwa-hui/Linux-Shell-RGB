#!/bin/bash

echo "Start Radxa E25 RGB"

color=(ffffff ff00ff 00ffff ffff00)

rgbinit()
{
for i in 0 1 2
do
    echo 0 > /sys/class/pwm/pwmchip${i}/export
    echo 255000 > /sys/class/pwm/pwmchip${i}/pwm0/period
    echo normal  > /sys/class/pwm/pwmchip${i}/pwm0/polarity
    echo 0 > /sys/class/pwm/pwmchip${i}/pwm0/duty_cycle
    echo 1 > /sys/class/pwm/pwmchip${i}/pwm0/enable
done
}

colorful(){

while true ;
do

    local r=255
    local g=0
    local b=1
    for ((i=0;i<255;i++))
        do
        let r=$r-1
        let g=$g+1
        echo `expr ${r} \* 1000`  > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
        echo `expr ${g} \* 1000`  > /sys/class/pwm/pwmchip1/pwm0/duty_cycle
        echo `expr ${b} \* 1000`  > /sys/class/pwm/pwmchip2/pwm0/duty_cycle
        done
    r=1
    g=255
    b=0
    for ((i=0;i<255;i++))
        do
        let g=$g-1
        let b=$b+1
        echo `expr ${r} \* 1000`  > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
        echo `expr ${g} \* 1000`  > /sys/class/pwm/pwmchip1/pwm0/duty_cycle
        echo `expr ${b} \* 1000`  > /sys/class/pwm/pwmchip2/pwm0/duty_cycle
        done

    r=0
    g=1
    b=255
    for ((i=0;i<255;i++))
        do
        let r=$r+1
        let b=$b-1
        echo `expr ${r} \* 1000`  > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
        echo `expr ${g} \* 1000`  > /sys/class/pwm/pwmchip1/pwm0/duty_cycle
        echo `expr ${b} \* 1000`  > /sys/class/pwm/pwmchip2/pwm0/duty_cycle
        done
done

}

blink()
{
while true ;
do

    for ((i=0;i<${#color[*]};i++)) 
        do
        r=`echo ${color[$i]:0:2}`
        g=`echo ${color[$i]:2:2}`
        b=`echo ${color[$i]:4:2}`
        r=`echo $((16#$r))`
        g=`echo $((16#$g))`
        b=`echo $((16#$b))`
        echo `expr ${r} \* 1000`  > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
        echo `expr ${g} \* 1000` > /sys/class/pwm/pwmchip1/pwm0/duty_cycle
        echo `expr ${b} \* 1000` > /sys/class/pwm/pwmchip2/pwm0/duty_cycle
        sleep 1
  done
done
}

rgb_breathe(){
while true ;
do
for ((x=0;x<3;x++))
do
    for ((i=1;i<255;i++))
    do
    j=$(expr $i \* 1000)
    echo ${j} > /sys/class/pwm/pwmchip${x}/pwm0/duty_cycle
    #echo $j
    sleep 0.0002
    done
    sleep 0.5
    for ((i=255;i>1;i--))
    do
    j=$(expr $i \* 1000)
    echo ${j} > /sys/class/pwm/pwmchip${x}/pwm0/duty_cycle
    #echo $j
    sleep 0.0001
    done
done
done
}
none(){
    echo 0  > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
    echo 0 > /sys/class/pwm/pwmchip1/pwm0/duty_cycle
    echo 0 > /sys/class/pwm/pwmchip2/pwm0/duty_cycle
}
path="/sys/class/pwm/pwmchip0/pwm0"
if [ ! -d "$path" ]; then
    rgbinit
fi

case "$1" in

blink)
    blink
    ;;
rgb_breathe)
    rgb_breathe
    ;;
colorful)
    colorful
    ;;
none)
    none
    ;;
*)
        echo "Usage: $0 {blink|rgb_breathe|colorful}"
        exit 1
esac

exit 0
