#!/bin/sh

# all this stuff is going to bin/ directory
# and is not deployed
find tools/ -name \*\.pro | while read PROJECT_FILE;
do
	grep --silent TARGET\[\[\:space\:\]\]\*\= $PROJECT_FILE
	if [ $? -eq 0 ]; then
		echo $PROJECT_FILE
		echo >> $PROJECT_FILE
		echo 'unix {' >> $PROJECT_FILE
		echo 'QMAKE_RPATHDIR=' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS_RPATH=' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS+="-Wl,-rpath,'\''\$$ORIGIN/../lib/'\'\" >> $PROJECT_FILE
		echo '}' >> $PROJECT_FILE
	fi
done

find src/tools/ -name \*\.pro | while read PROJECT_FILE;
do
	grep --silent TARGET\[\[\:space\:\]\]\*\= $PROJECT_FILE
	if [ $? -eq 0 ]; then
		echo $PROJECT_FILE
		echo >> $PROJECT_FILE
		echo 'unix {' >> $PROJECT_FILE
		echo 'QMAKE_RPATHDIR=' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS_RPATH=' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS+="-Wl,-rpath,'\''\$$ORIGIN/../lib/'\'\" >> $PROJECT_FILE
		echo '}' >> $PROJECT_FILE
	fi
done

# fix RPATH for the plugins
# plugins should have two RUNPATHS - first for installed Qt and the second
# for deployed Qt
find src/plugins -name \*\.pro | while read PROJECT_FILE;
do
	grep --silent TARGET\[\[\:space\:\]\]\*\= $PROJECT_FILE
	if [ $? -eq 0 ]; then
		echo $PROJECT_FILE
		echo >> $PROJECT_FILE
		echo 'unix {' >> $PROJECT_FILE
		echo 'QMAKE_RPATHDIR=' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS_RPATH=' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS+="-Wl,-rpath,'\''\$$ORIGIN/../../lib/'\'\" >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS+="-Wl,-rpath,'\''\$$ORIGIN/../'\'\" >> $PROJECT_FILE
		echo '}' >> $PROJECT_FILE
	fi
done

# and at last turn fix RUNPATH for the libraries
find src/ -name \*\.pro \! -path \*plugins\* \! -path \*3rdparty\* \! -path \*activeqt\* \! -path \*imports\* \! -path \*tools\* \! -path \*winmain\* | while read PROJECT_FILE;
do
	grep --silent TARGET\[\[\:space\:\]\]\*\= $PROJECT_FILE
	if [ $? -eq 0 ]; then
		echo $PROJECT_FILE
		echo >> $PROJECT_FILE
		echo 'unix {' >> $PROJECT_FILE
		echo 'QMAKE_RPATHDIR=' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS_RPATH=' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS+="-Wl,-rpath,'\''\$$ORIGIN/'\'\" >> $PROJECT_FILE
		echo '}' >> $PROJECT_FILE
	fi
done
