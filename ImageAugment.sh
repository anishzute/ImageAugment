#!/bin/sh

echo "Please enter the image directory:"
read imageDir
echo "Please enter the number of copies:"
read numCopies
echo "Please enter the average x dimensions of the images (+- 10%)"
read xDim
echo "Please enter the average y dimensions of the images (+-10%)"
read yDim




#checking if the scikit-image package is installed
if python -c 'import pkgutil; exit(not pkgutil.find_loader("scikit-image"))'; then
    echo 'Dependencies met. Continuing process.'
else
    echo 'Scikit-image not found. Installing scikit-image'
    pip install scikit-image
fi

git clone https://github.com/codebox/image_augmentor.git
cd image_augmentor

getRandomTransform()
{
	randomNum=$[RANDOM%7]
	case $randomNum in
		1 )
			echo "fliph"
			;;
		2 )
			echo "flipv"
			;;
	    3 )
			randomNoise=$(echo "scale=2; $[RANDOM%3]/10+.01"|bc)
			echo "noise_$randomNoise"
			;;
		4 )
			randomRot=$(echo "scale=0; $[RANDOM%359]+1"|bc)
			echo "rot_$randomRot"
			;;
		5 )
			randomX=$(echo "scale=1; $[RANDOM%10]+1"|bc)
			randomY=$(echo "scale=1; $[RANDOM%10]+1"|bc)
			randomXdir=$(echo "scale=1; $[RANDOM%10]+1"|bc)
			randomYdir=$(echo "scale=1; $[RANDOM%10]+1"|bc)
			if [[ $randomXdir -gt 5 ]]; then
				if [[ $randomYdir -gt 5 ]]; then
					echo "trans_${randomX}_${randomY}"
				else
					echo "trans_${randomX}_-${randomY}"
				fi
			else
				if [[ $randomYdir -gt 5 ]]; then
					echo "trans_-${randomX}_${randomY}"
				else
					echo "trans_-${randomX}_-${randomY}"
				fi
			fi
			

			;;

		6 )
			xSize=$(echo "scale=0; $xDim/2"|bc)
			ySize=$(echo "scale=0; $yDim/2"|bc)
			xError=$(echo "scale=0; $xDim/2/10"|bc)
			yError=$(echo "scale=0; $yDim/2/10"|bc)
			randomX=$(echo "scale=0; $[RANDOM%${xSize}]"|bc)
			randomY=$(echo "scale=0; $[RANDOM%${ySize}]"|bc)
			randomZ=$(echo "scale=0; $[RANDOM%${xSize}]+${xSize}-${xError}"|bc)
			randomH=$(echo "scale=0; $[RANDOM%${ySize}]+${ySize}-${yError}"|bc)
			echo "zoom_${randomX}_${randomY}_${randomZ}_${randomH}"
			;;

		0 )
			randomBlur=$(echo "scale=2; $[RANDOM%40]/10+.01"|bc)
			echo "blur_$randomBlur"
			;;
	esac
}

makeTransforms()
{
	for i in 1 2 3 4 5 6 0
	do
		randomNum=$(echo "scale=0; $[RANDOM%100]+1"|bc)
		if [[ $randomNum -gt 50 ]]; then
			if [[ $transforms == "" ]]; then
				transforms=$(echo "$(getRandomTransform)")
			else
				transforms=$(echo "$transforms,$(getRandomTransform)")
			fi
			
		fi
	done	
	echo "$transforms"
}

for (( i = 0; i < $numCopies+1; i++ )); do
	python main.py ${imageDir} $(makeTransforms)
done

cd ..
rm -rf image_augmentor
