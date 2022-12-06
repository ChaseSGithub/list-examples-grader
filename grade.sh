# Create your grading script here



rm -rf student-submission
echo "Cloning student submission..."
git clone $1 student-submission 2> /dev/null
echo "Cloning completed!"
error=0
javac -target 1.8 -cp ".:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar" ListExamples.java TestListExamples.java
rm ListExamples.class
CP="..:../lib/hamcrest-core-1.3.jar:../lib/junit-4.13.2.jar"
cd student-submission

ls -a > fileList.txt
if [ $(grep -c "ListExamples.java" fileList.txt) -eq 0 ]
then
    echo "\"ListExamples.java\" not found, check to see that you've submitted the proper files"
    exit 1
fi

echo "Attempting to compile..."
javac -cp $CP *.java

if [ $? -ne 0 ]
then
    echo "COMPILE ERROR, Score: 0.00/2.00"
    echo "Make sure that your program compiles properly"
    exit 1
fi

echo "COMPILE SUCCESS"
echo "Running tests..."
cp ListExamples.class ..
java -cp $CP org.junit.runner.JUnitCore TestListExamples > error.txt
cp ../ListExamples.class .
if [ $(grep -c "testFilter" error.txt) -ne 0 ]
then
    let "error+=1"
    echo "[01 FAILED 0.00/1.00] testFilterFunctionality"
else
    echo "[01 PASSED 1.00/1.00] testFilterFunctionality"
fi

if [ $(grep -c "testMerge" error.txt) -ne 0 ]
then
    let "error+=1"
    echo "[02 FAILED 0.00/1.00] testMergeFunctionality"
else
    echo "[02 PASSED 1.00/1.00] testMergeFunctionality"
fi

if [ $error -eq 2 ]
then
    echo "Score: 0.00/2.00"
    echo "See error.txt file in student-submission for details"
fi

if [ $error -eq 1 ]
then
    echo "Score: 1.00/2.00"
    echo "See error.txt file in student-submission for details"
fi

if [ $error -eq 0 ]
then
    echo "Score: 2.00/2.00"
    echo "All tests passed!"
fi

