#!/bin/sh

fix_library_runpath()
{
	local PROJECT_FILE="$1"

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
	# For example, QtCore will have an id '@rpath/QtCore.framework/Versions/4/QtCore'.
	echo 'QMAKE_LFLAGS_SONAME = $$quote(-install_name	@rpath/)' >> $PROJECT_FILE
	echo '}' >> $PROJECT_FILE
}

fix_plugin_runpath()
{
	local PROJECT_FILE="$1"

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
}

fix_tool_runpath()
{
	local PROJECT_FILE="$1"

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
}

# almost all this stuff is going to bin/ directory
# and is not deployed
find tools/ -name \*\.pro | while read PROJECT_FILE;
do
	grep --silent CONFIG\[\[\:space\:\]\]\*\+\*=\.\*plugin $PROJECT_FILE
	if [ $? -eq 0 ]; then
		fix_plugin_runpath "$PROJECT_FILE"
	else
		grep --silent TEMPLATE\[\[\:space\:\]\]\*\=\[\[\:space\:\]\]\*lib $PROJECT_FILE
		if [ $? -eq 0 ]; then
			fix_library_runpath "$PROJECT_FILE"
		else
			grep --silent TARGET\[\[\:space\:\]\]\*\= $PROJECT_FILE
			if [ $? -eq 0 ]; then
				fix_tool_runpath "$PROJECT_FILE"
			fi
		fi
	fi
done

find src/tools/ -name \*\.pro | while read PROJECT_FILE;
do
	grep --silent TARGET\[\[\:space\:\]\]\*\= $PROJECT_FILE
	if [ $? -eq 0 ]; then
		fix_tool_runpath "$PROJECT_FILE"
	fi
done

# fix RPATH for the plugins
# they should have two runpaths:
#    1) for installed Qt;
#    2) for deployed Qt; I don't know how Qt will be deployed so
#      the step is passed. One can later add/change runpaths
#      with install_name_tool.
find src/plugins -name \*\.pro | while read PROJECT_FILE;
do
	grep --silent TARGET\[\[\:space\:\]\]\*\= $PROJECT_FILE
	if [ $? -eq 0 ]; then
		fix_plugin_runpath "$PROJECT_FILE"
	fi
done

# and at last turn fix RUNPATH for the libraries
find src -name \*\.pro \! -path \*/plugins\* \! -path \*/3rdparty\* \! -path \*/activeqt\* \! -path \*/imports\* \! -path \*/tools\* \! -path \*/winmain\* | while read PROJECT_FILE;
do
	grep --silent TARGET\[\[\:space\:\]\]\*\= $PROJECT_FILE
	if [ $? -eq 0 ]; then
		fix_library_runpath "$PROJECT_FILE"
	fi
done
