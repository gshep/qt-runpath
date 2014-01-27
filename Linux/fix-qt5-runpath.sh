#!/bin/sh

# firstly do it for the libraries itself
find qtbase/src -name \*\.pro \! -path \*plugins\* | while read PROJECT_FILE;
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

# then do it for the rest modules except QtQuick1 as it has been
# deprecated
# also ignore qttools -
find . -name \*\.pro \! -path \*qtbase\* \! -path \*qtquick1\* \! -path \*qttools\* | while read PROJECT_FILE;
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

# fix rpath in qttools
find qttools/ -name \*\.pro | while read PROJECT_FILE;
do
	grep --silent TARGET\[\[\:space\:\]\]\*\= $PROJECT_FILE
	if [ $? -eq 0 ]; then
		echo $PROJECT_FILE
		echo >> $PROJECT_FILE
		echo 'unix {' >> $PROJECT_FILE
		echo 'QMAKE_RPATHDIR=' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS_RPATH=' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS+="-Wl,-rpath,'\''\$$ORIGIN/../'\'\" >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS+="-Wl,-rpath,'\''\$$ORIGIN/../lib/'\'\" >> $PROJECT_FILE
		echo '}' >> $PROJECT_FILE
	fi
done

# and at the end fix RPATH for the plugins
find qtbase/src/plugins -name \*\.pro | while read PROJECT_FILE;
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
