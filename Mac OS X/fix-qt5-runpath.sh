#!/bin/sh

# firstly do it for the libraries itself except plugins and tools
find qtbase/src -name \*\.pro \! -path \*src/plugins\* \! -path \*src/tools\* | while read PROJECT_FILE;
do
	grep --silent TARGET\[\[\:space\:\]\]\*\= $PROJECT_FILE
	if [ $? -eq 0 ]; then
		echo $PROJECT_FILE
		echo >> $PROJECT_FILE
		echo 'macx {' >> $PROJECT_FILE
		echo 'QMAKE_RPATHDIR=' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS_RPATH=' >> $PROJECT_FILE

		# add rpath. This is added even to QtCore but is not needed
		echo 'QMAKE_LFLAGS += -Wl,-rpath,@loader_path/../../../' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS -= -mmacosx-version-min=10.4' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS -= -mmacosx-version-min=10.5' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS -= -mmacosx-version-min=10.7' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS -= -mmacosx-version-min=10.8' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS += -mmacosx-version-min=10.6' >> $PROJECT_FILE
		echo 'QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.6' >> $PROJECT_FILE
		echo 'QMAKE_CFLAGS -= -mmacosx-version-min=10.4' >> $PROJECT_FILE
		echo 'QMAKE_CFLAGS -= -mmacosx-version-min=10.5' >> $PROJECT_FILE
		echo 'QMAKE_CFLAGS -= -mmacosx-version-min=10.7' >> $PROJECT_FILE
		echo 'QMAKE_CFLAGS -= -mmacosx-version-min=10.8' >> $PROJECT_FILE
		echo 'QMAKE_CFLAGS += -mmacosx-version-min=10.6' >> $PROJECT_FILE
		echo 'QMAKE_CXXFLAGS -= -mmacosx-version-min=10.4' >> $PROJECT_FILE
		echo 'QMAKE_CXXFLAGS -= -mmacosx-version-min=10.5' >> $PROJECT_FILE
		echo 'QMAKE_CXXFLAGS -= -mmacosx-version-min=10.7' >> $PROJECT_FILE
		echo 'QMAKE_CXXFLAGS -= -mmacosx-version-min=10.8' >> $PROJECT_FILE
		echo 'QMAKE_CXXFLAGS += -mmacosx-version-min=10.6' >> $PROJECT_FILE

		# This line makes the right id of the library.
		# For example, QtCore will have an id '@rpath/QtCore.framework/Versions/5/QtCore'.
		echo 'QMAKE_LFLAGS_SONAME = $$quote(-install_name	@rpath/)' >> $PROJECT_FILE
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
		echo 'macx {' >> $PROJECT_FILE
		echo 'QMAKE_RPATHDIR=' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS_RPATH=' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS += -Wl,-rpath,@loader_path/../../../' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS -= -mmacosx-version-min=10.4' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS -= -mmacosx-version-min=10.5' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS -= -mmacosx-version-min=10.7' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS -= -mmacosx-version-min=10.8' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS += -mmacosx-version-min=10.6' >> $PROJECT_FILE
		echo 'QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.6' >> $PROJECT_FILE
		echo 'QMAKE_CFLAGS -= -mmacosx-version-min=10.4' >> $PROJECT_FILE
		echo 'QMAKE_CFLAGS -= -mmacosx-version-min=10.5' >> $PROJECT_FILE
		echo 'QMAKE_CFLAGS -= -mmacosx-version-min=10.7' >> $PROJECT_FILE
		echo 'QMAKE_CFLAGS -= -mmacosx-version-min=10.8' >> $PROJECT_FILE
		echo 'QMAKE_CFLAGS += -mmacosx-version-min=10.6' >> $PROJECT_FILE
		echo 'QMAKE_CXXFLAGS -= -mmacosx-version-min=10.4' >> $PROJECT_FILE
		echo 'QMAKE_CXXFLAGS -= -mmacosx-version-min=10.5' >> $PROJECT_FILE
		echo 'QMAKE_CXXFLAGS -= -mmacosx-version-min=10.7' >> $PROJECT_FILE
		echo 'QMAKE_CXXFLAGS -= -mmacosx-version-min=10.8' >> $PROJECT_FILE
		echo 'QMAKE_CXXFLAGS += -mmacosx-version-min=10.6' >> $PROJECT_FILE

		# This line makes the right id of the library.
		# For example, QtCore will have an id '@rpath/QtCore.framework/Versions/5/QtCore'.
		echo 'QMAKE_LFLAGS_SONAME = $$quote(-install_name	@rpath/)' >> $PROJECT_FILE
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
		echo 'macx {' >> $PROJECT_FILE
		echo 'QMAKE_RPATHDIR=' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS_RPATH=' >> $PROJECT_FILE
		# some tools are bundled so two runpaths are needed
		echo 'QMAKE_LFLAGS += -Wl,-rpath,@loader_path/../lib/' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS += -Wl,-rpath,@loader_path/../../../../lib/' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS -= -mmacosx-version-min=10.4' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS -= -mmacosx-version-min=10.5' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS -= -mmacosx-version-min=10.7' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS -= -mmacosx-version-min=10.8' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS += -mmacosx-version-min=10.6' >> $PROJECT_FILE
		echo 'QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.6' >> $PROJECT_FILE
		echo 'QMAKE_CFLAGS -= -mmacosx-version-min=10.4' >> $PROJECT_FILE
		echo 'QMAKE_CFLAGS -= -mmacosx-version-min=10.5' >> $PROJECT_FILE
		echo 'QMAKE_CFLAGS -= -mmacosx-version-min=10.7' >> $PROJECT_FILE
		echo 'QMAKE_CFLAGS -= -mmacosx-version-min=10.8' >> $PROJECT_FILE
		echo 'QMAKE_CFLAGS += -mmacosx-version-min=10.6' >> $PROJECT_FILE
		echo 'QMAKE_CXXFLAGS -= -mmacosx-version-min=10.4' >> $PROJECT_FILE
		echo 'QMAKE_CXXFLAGS -= -mmacosx-version-min=10.5' >> $PROJECT_FILE
		echo 'QMAKE_CXXFLAGS -= -mmacosx-version-min=10.7' >> $PROJECT_FILE
		echo 'QMAKE_CXXFLAGS -= -mmacosx-version-min=10.8' >> $PROJECT_FILE
		echo 'QMAKE_CXXFLAGS += -mmacosx-version-min=10.6' >> $PROJECT_FILE
		echo '}' >> $PROJECT_FILE
	fi
done

# and at the end fix RPATH for the plugins
# they should have two runpaths:
#    1) for installed Qt;
#    2) for deployed Qt; I don't know how Qt will be deployed so
#      the step is passed. One can later add/change runpaths
#      with install_name_tool.
find . -name \*\.pro | while read PROJECT_FILE;
do
	grep -E --silent 'load\(qt_plugin' $PROJECT_FILE
	if [ $? -eq 0 ]; then
		echo $PROJECT_FILE
		echo >> $PROJECT_FILE
		echo 'macx {' >> $PROJECT_FILE
		echo 'QMAKE_RPATHDIR=' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS_RPATH=' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS += -Wl,-rpath,@loader_path/../../lib/' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS -= -mmacosx-version-min=10.4' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS -= -mmacosx-version-min=10.5' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS -= -mmacosx-version-min=10.7' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS -= -mmacosx-version-min=10.8' >> $PROJECT_FILE
		echo 'QMAKE_LFLAGS += -mmacosx-version-min=10.6' >> $PROJECT_FILE
		echo 'QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.6' >> $PROJECT_FILE
		echo 'QMAKE_CFLAGS -= -mmacosx-version-min=10.4' >> $PROJECT_FILE
		echo 'QMAKE_CFLAGS -= -mmacosx-version-min=10.5' >> $PROJECT_FILE
		echo 'QMAKE_CFLAGS -= -mmacosx-version-min=10.7' >> $PROJECT_FILE
		echo 'QMAKE_CFLAGS -= -mmacosx-version-min=10.8' >> $PROJECT_FILE
		echo 'QMAKE_CFLAGS += -mmacosx-version-min=10.6' >> $PROJECT_FILE
		echo 'QMAKE_CXXFLAGS -= -mmacosx-version-min=10.4' >> $PROJECT_FILE
		echo 'QMAKE_CXXFLAGS -= -mmacosx-version-min=10.5' >> $PROJECT_FILE
		echo 'QMAKE_CXXFLAGS -= -mmacosx-version-min=10.7' >> $PROJECT_FILE
		echo 'QMAKE_CXXFLAGS -= -mmacosx-version-min=10.8' >> $PROJECT_FILE
		echo 'QMAKE_CXXFLAGS += -mmacosx-version-min=10.6' >> $PROJECT_FILE
		echo '}' >> $PROJECT_FILE
	fi
done
