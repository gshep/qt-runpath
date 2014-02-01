#!/bin/sh

# firstly do it for the libraries itself except plugins and tools
find qtbase/src -name \*\.pro \! -path \*src/plugins\* \! -path \*src/tools\* | while read PROJECT_FILE;
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

# then do it for the rest modules except qtbase
# ignore plugins, tools and apps
find . -name \*\.pro \! -path \*qtbase\* | while read PROJECT_FILE;
do
	grep -E --silent 'load\(qt_(plugin|tool|app)' $PROJECT_FILE
	if [ $? -eq 0 ]; then
		continue
	fi

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

# fix rpath for not deployed tools and apps
find . -name \*\.pro | while read PROJECT_FILE;
do
	grep -E --silent 'load\(qt_(tool|app)' $PROJECT_FILE
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
# they should have two runpaths:
#    1) for installed Qt
#    2) for deployed Qt
find . -name \*\.pro | while read PROJECT_FILE;
do
	grep -E --silent 'load\(qt_plugin' $PROJECT_FILE
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
