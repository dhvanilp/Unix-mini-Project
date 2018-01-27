#!/bin/bash

# initialise the board
init(){

	((temp=$d*$d-1))
	for((i=0; i<d; i++))
	do
		for((j=0; j<d; j++))
		do
			(($1[$i,$j]=$temp))
			((temp=$temp-1))
		done
	done
	((temp3=$d-1))
	((temp4=$d-2))
	((temp5=$d-3))
	(($1[$temp3,$temp3]=0))
	((temp2=$d%2))
	if [ $temp2 -eq 0 ]
	then
		(($1[$temp3,$temp4]=2))
		(($1[$temp3,$temp5]=1))
	fi
}

# draw the board
display(){
	board=$1
	println
	for((i=0; i<d; i++))
	do  echo -n "|"
		for((j=0; j<d; j++))
		do	
			if [ ${board[$i,$j]} -gt 0 ]
			then
				printf '%3d |' "${board[$i,$j]}"
			elif [ ${board[$i,$j]} -eq 0 ]
			then
				echo -n "    |"
			else
				echo -n " _|"
			fi 
		done
		echo
		println
	done
}

println()
{	
	local i
	echo -n "+"
	for((i=0;i<d;i++))
	do
		echo -n "----+"
	done
	echo
	return
}

# make a move
mov1()
{	board=$2
	echo "$1"
	for((i=0; i<d; i++))
	do
		for((j=0; j<d; j++))
		do
			if [ ${board[$i,$j]} -eq $1 ]
            then
            	((temp1=$i+1))
            	((temp2=$j+1))
            	((temp3=$i-1))
            	((temp4=$j-1))
            	((temp5=$d-1))
                if [[ ( ${board[$i,$temp2]} -eq 0 )  && ( $j -lt $temp5 ) ]]
                then
                    swap $i $j $i $temp2 board
                    return 1
                fi
                if [[ (${board[$i,$temp4]} -eq 0) && ( $j -gt 0 ) ]]
                then
                    swap $i $j $i $temp4 board
                    return 1
                fi
                if [[ (${board[$temp1,$j]} -eq 0) && ( $i -lt $temp5) ]]
                then
                    swap $i $j $temp1 $j board
                    return 1
                fi
                if [[ (${board[$temp3,$j]} -eq 0) && ( $i -gt 0 ) ]]
                then
                    swap $i $j $temp3 $j board
                    return 1
                fi
                return 0
            fi
		done
	done
	return 0
}

swap(){
	board=$5
	((tempor=${board[$1,$2]}))
	((board[$1,$2]=${board[$3,$4]}))
	((board[$3,$4]=$tempor))
}

# check whether the user won or not
won(){
	board=$1
	k=1
	((tem=$d-1))
	for((i=0; i<d; i++))
	do
		for((j=0; j<d; j++))
		do
			if [[ ( $i -ne $tem ) || ( $j -ne $tem ) ]]
				then
				if [[ ( ${board[$i,$j]} -ne k ) ]]
					then 
					return 0
				fi
			fi
			((k=$k+1))
		done
	done
	return 1
}

# initializing variables
sleep .5
clear

dmin=3
dmax=9
move=0

# game starts
echo -e "Welcome to THE GAME OF TILES\n"
if [ $# -eq 0 ]
then
	t=true
	j=0
	while $t                 
	do
		echo -n "Enter the size of the grid (3-9): "
		read d
		if [[ ( d -lt dmin ) || ( d -gt dmax ) ]]
		then
			echo "Invalid Input"
		else
			t=false
		fi	
	done
elif [ $# -eq 1 ]
then
	if [ "$1" == "solve" ]
	then
		t=true
		declare -a mo
		while $t                 
		do
			echo -n "Enter the size of the grid (3-4): "
			read d
			if [[ ( d -lt 3 ) || ( d -gt 4 ) ]]
			then
				echo "Invalid Input"
			else
				t=false
			fi	
		done
		if [ $d -eq 3 ]
		then
			./p1.sh < solution3
		else
			./p1.sh < solution4
		fi
		exit
	elif [ "$1" == "highscore" ]
	then
		echo -e "High Scores :-\n\nN TIME MOVES"
		cat highscores
		exit
	else
		echo "Invalid Argument"
		sleep .5
		exit
	fi
else
	echo "Invalid Argument"
	sleep .5
	exit
fi

clear
declare -A board 
init board

startTime=`date +%s`
for((s=1; s>0; s++))
do  	
	printf "\033c"
	display board

	#check if won
	won board
	m=$?
	if [[ $m == 1 ]]
	then
		echo -e "\nYOU WIN!!!\n"
		echo "Number of moves used: $move"
		endTime=`date +%s`
		time=`expr $endTime - $startTime`
		echo -e "Time: $time\n"
		# printf "%d %3d %5d\n" $d $time $move | cat >> highscores
		o=`grep ^$d highscores | tr -s " " | cut -d " " -f 3`
		if [ "$o" == "--" ]
		then
			l=`expr $d - 2`
			s=`printf "%d %3d %5d\n" $d $time $move`
			sed "$l s/.*/$s/" highscores > temp
			cat temp | cat > highscores
		elif [ $move -lt $o ] 
		then
			l=`expr $d - 2`
			s=`printf "%d %3d %5d\n" $d $time $move`
			sed "$l s/.*/$s/" highscores > temp
			cat temp | cat > highscores
		elif [ $move -eq $o ] 
		then
			t=`grep ^$d highscores | tr -s " " | cut -d " " -f 2`
			if [ $time -lt $t ] 
			then
				l=`expr $d - 2`
				s=`printf "%d %3d %5d\n" $d $time $move`
				sed "$l s/.*/$s/" highscores > temp
				cat temp | cat > highscores
			fi
		fi
		break
	else
		echo "Moves used $move"
	fi
	echo -n "Tile to move: "
	
	read tile
	sleep .2
	
	if [ $tile -eq 0 ]
		then
		echo "Exiting"
		break
	fi

	mov1 $tile board
	n=$?
	if [[ $n == 0 ]]
		then
		echo "Invalid Move"
		sleep 2
	else
		((move=$move+1))
	fi
done






                                                                                                                    
