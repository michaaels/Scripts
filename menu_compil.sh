#!/bin/bash
dir_source=0
menu_opc=0

menu_principal(){
clear
echo Directorio actual: $(pwd)
echo "| Menu Principal |"
echo "-	1)Descargar"
echo "-	2)Extraer"
echo "-	3)Configurar"
echo "-	4)Construir"
echo "-	5)Instalar"
echo "-	0)Salir"
read -p "Ingrese opción: " opc;
case $opc in 
	1)menu_opc=1;download;;
	2)menu_opc=2;extract;;
	3)menu_opc=3;configure;;
	4)menu_opc=4;compile;;
	5)menu_opc=5;install_source;;
	0)exit;;
	*)echo Seleccione una opción correcta;pause;menu_principal;;
esac
}

# Funciones

sel_dir(){
echo Las carpetas que se encuentran en el directorio son:
ls -d */
echo Ingrese el directorio donde se encuentra el source
read dir_source
if [[ -d $dir_source -a -n "$dir_source" ]];then #O se puede usar [ condicion -a condicion ] -a and
	cd $dir_source
else
	clear
	dir_source=0
	echo Seleccione un directorio correcto
	sel_dir
fi
case $menu_opc in
        1)download;;
        2)extract;;
        3)configure;;
        4)compile;;
        5)install_source;;
esac
}

function pause(){ read -p "Para continuar presiones una tecla";}

download(){
echo Ingrese la url del archivo fuente a descargar
read url

if wget --spider -S $url 2>&1 | grep -w "200\|301" ; then
    wget $url
else
    echo No se logra encontrar la url ingresada
fi

echo $name_source
pause
menu_principal
}

extract(){
find . -type f #busca todos los archivos
read -p "Esriba el nombre del archivo que desea extraer: " name_file
if [ -n "$name_file" ]; then #Verifica que no esta vacio
	case $name_file in
	 	*.zip)unzip $name_file;;#break
     *.tar | *.tar.xz)tar -xvf $name_file;;
 	     *.tar.gz)tar -xvzf $name_file;;
	         *.gz)gzip -d $name_file;;
	        *.bz2)bzip2 -d $name_file;;
	            *)echo El archivo $name_file no se pudo descomprimir;pause;menu_principal;;
	esac
	echo El archivo $name_file Se descomprimio con exito
else 	
 echo El archivo $name_file no existe en el directorio
fi 
pause
menu_principal
}

configure(){
clear
echo "Se procedera a configurar el source"
if [ $dir_source -eq 0 ];then sel_dir;fi
echo Se procede a usar el comando ./configure
./configure --enable-optimizations
pause
menu_principal
}

#Construir con algunos procesadores 
compile(){
clear
if [ $dir_source -eq 0 ];then sel_dir;fi
NPROC=$(nproc) #Guardamos variable nproc
echo Usted cuenta con $NPROC unidades de procesamiento
echo ¿Desea usarlas para construir el source? S = SI o N = NO
read opc_comp 
case $opc_comp in
	[Ss])time make -j $NPROC;;
	[Nn])time make;;
	*)echo No ha ingresado una opcion correcta;;
esac	
pause
menu_principal
}

install_source(){
clear
if [ $dir_source = 0 ];then sel_dir;fi
echo Se procede a instalar el programa
sudo make install
pause
menu_principal
}

menu_principal
