#/bin/sh

function getcomposer ()
{
	if type "php" > /dev/null; then
	    php -r "readfile('https://getcomposer.org/installer');" | php
	else
	    echo "Please install php first or add php bin path to PATH variable."
	fi	
}

function create_project ()
{
	./composer.phar create-project symfony/framework-standard-edition $1 2.4.4
}

function call_add_require ()
{
	# add packages from file
	filename="${PWD}/default.packages"
	# exec < $filename

	while read line
	do
		add_require $line
	done < $filename

	# add packages from parameters
	for var in $*
	do
		if [ $var != $1 ];
		then
			add_require $var
		fi
	done
}

function add_require ()
{
    ./composer.phar require "$1"
}

function init ()
{
	getcomposer
	create_project $1
	call_add_require $*
}

function help ()
{
	echo "usage: $0 project-name [composer-package-name1] [composer-package-name2] ... "
}

if [ $#  -lt 1 ]
then
	help
else
	init $*
fi
