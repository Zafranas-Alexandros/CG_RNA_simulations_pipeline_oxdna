#FOR POTENTIAL ENERGY
awk '/epot/ { print substr($0,1,8), substr($0, match($0, /epot =/)+7, 18) }' ./../working_dir/log.lammps > epot.xvg
sed -i '' -e "s/|//g" epot.xvg 
sed -i '' -e "s/e//g" epot.xvg
sed -i '' -e "s/t//g" epot.xvg
sed -i '' -e "s/k//g" epot.xvg
sed -i '' -e "s/o//g" epot.xvg
sed -i '' -e "s/i//g" epot.xvg
sed -i '' -e "s/n//g" epot.xvg
sed -i '' -e "s/m//g" epot.xvg
sed -i '' '1,5d' epot.xvg 


#FOR TOTAL ENERGY
awk '/etot/ { print substr($0,1,8), substr($0, match($0, /etot =/)+7, 18) }' ./../working_dir/log.lammps > etot.xvg
sed -i '' -e "s/|//g" etot.xvg 
sed -i '' -e "s/e//g" etot.xvg
sed -i '' -e "s/t//g" etot.xvg
sed -i '' -e "s/k//g" etot.xvg
sed -i '' -e "s/o//g" etot.xvg
sed -i '' -e "s/i//g" etot.xvg
sed -i '' -e "s/n//g" etot.xvg
sed -i '' -e "s/m//g" etot.xvg
sed -i '' '1,4d' etot.xvg 

#FOR TEMPERATURE
awk '/temp/ { print substr($0,1,8), substr($0, match($0, /temp =/)+7, 18) }' ./../working_dir/log.lammps > temp.xvg
sed -i '' -e "s/|//g" temp.xvg 
sed -i '' -e "s/e//g" temp.xvg
sed -i '' -e "s/t//g" temp.xvg
sed -i '' -e "s/k//g" temp.xvg
sed -i '' -e "s/o//g" temp.xvg
sed -i '' -e "s/i//g" temp.xvg
sed -i '' -e "s/n//g" temp.xvg
sed -i '' -e "s/m//g" temp.xvg
sed -i '' '1,5d' temp.xvg 