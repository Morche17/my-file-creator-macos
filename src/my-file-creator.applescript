-- Este es un script para crear archivos vac’os (Mi primer script de applescript).
-- Versi—n 1.0 (A partir de macOS 10.10+)
-- Autor: Emanuel Tavares

property defaultFolder : path to desktop from user domain

try
	-- Aqu’ se pide el nombre del archivo
	display dialog "Nombre del archivo (con extensi—n):" default answer "ejemplo.txt" buttons {"Cancelar", "Siguiente"} default button 2 with title "Crear Archivo Vac’o"
	set fileName to text returned of result
	if fileName is "" then error "Nombre de archivo inv‡lido"
	
	-- Aqu’ se selecciona la ubicaci—n
	set destino to choose folder with prompt "Selecciona la carpeta destino:" default location defaultFolder
	
	-- Normalizar ruta
	set destinoPath to POSIX path of destino
	if destinoPath ends with "/" then
		set destinoPath to text 1 thru -2 of destinoPath
	end if
	set fullPath to destinoPath & "/" & fileName
	
	-- Verificando que el archivo existe
	set fileExists to do shell script "[ -e " & quoted form of fullPath & " ] && echo 1 || echo 0"
	if fileExists is "1" then
		display alert "ÁEl archivo ya existe!" message "Elige otro nombre o ubicaci—n." as critical buttons {"Cancelar", "Sobrescribir"} default button 2
	end if
	
	-- Creando archivo
	do shell script "touch " & quoted form of fullPath
	
	-- Revelaci—n en Finder
	set respuesta to display dialog "Archivo creado:" default answer fullPath buttons {"OK", "Mostrar en Finder"} default button 2
	if button returned of respuesta is "Mostrar en Finder" then
		tell application "Finder"
			-- Usando HFS path (compatible universal)
			set hfsPath to POSIX file fullPath as text
			reveal (hfsPath as alias)
			
			-- MŽtodo alternativo (para sistemas modernos)
			-- reveal (POSIX file fullPath as alias)
			
			activate
		end tell
	end if
	
on error errMsg number errNum
	if errNum is -128 then
		-- Usuario cancela
	else
		display alert "Error" message errMsg as critical buttons {"OK"}
	end if
end try