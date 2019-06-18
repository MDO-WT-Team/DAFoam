#!/bin/bash

########## user input ##########
nProcs=2
exec=mpirun
outputPath=../optOutput/
########## user input ##########

rm runCheckMesh
rm runFlowSolver
rm runAdjointSolver
rm runColoring

for n in `seq 0 1 1000000`; do

  if [ -e "runCheckMesh" ]
  then
    ${exec} -np $nProcs checkMesh -parallel > checkMeshLog
    rm runCheckMesh
    touch jobFinished
  fi

  if [ -e "runColoring" ]
  then
    ${exec} -np $nProcs coloringSolverIncompressible -parallel > coloringLog
    rm runColoring
    touch jobFinished
  fi

  if [ -e "runFlowSolver" ]
  then
    ${exec} -np $nProcs simpleTDAFoam -parallel > flowLog
    rm runFlowSolver
    touch jobFinished
  fi

  if [ -e "runAdjointSolver" ]
  then
    rm -rf optShapes*
    ${exec} -np $nProcs surfaceMeshTriangulate optShapes.stl -parallel > optShapesLog
    ${exec} -np $nProcs simpleTDAFoam -parallel > adjointLog
    rm runAdjointSolver
    touch jobFinished
  fi
  
  sleep 5
  
done

