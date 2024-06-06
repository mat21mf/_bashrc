sudo apt install --no-install-recommends dos2unix

cp -p -u .bashrc ~/.bashrc
cp -p -u .bash_functions ~/.bash_functions
cp -p -u .bash_aliases ~/.bash_aliases
dos2unix ~/.bashrc
dos2unix ~/.bash_functions
dos2unix ~/.bash_aliases

if [[ ! -d ~/.bin ]] ; then mkdir ~/.bin ; fi

cp -p -u .bin/CsvAParquet.R                 ~/.bin/CsvAParquet.R
cp -p -u .bin/CsvARds.R                     ~/.bin/CsvARds.R
cp -p -u .bin/CsvAXlsx.R                    ~/.bin/CsvAXlsx.R
cp -p -u .bin/CsvComaAArroba.R              ~/.bin/CsvComaAArroba.R
cp -p -u .bin/CsvEspacioAComa.R             ~/.bin/CsvEspacioAComa.R
cp -p -u .bin/GetColnames.R                 ~/.bin/GetColnames.R
cp -p -u .bin/GetDims.R                     ~/.bin/GetDims.R
cp -p -u .bin/MdbARds.R                     ~/.bin/MdbARds.R
cp -p -u .bin/ParquetASav.R                 ~/.bin/ParquetASav.R
cp -p -u .bin/ParquetAXlsx.R                ~/.bin/ParquetAXlsx.R
cp -p -u .bin/Purl.R                        ~/.bin/Purl.R
cp -p -u .bin/RasterValoresUnicos.py        ~/.bin/RasterValoresUnicos.py
cp -p -u .bin/Render.R                      ~/.bin/Render.R
cp -p -u .bin/RenderHtml.R                  ~/.bin/RenderHtml.R
cp -p -u .bin/SavARds.R                     ~/.bin/SavARds.R
cp -p -u .bin/TabARds.R                     ~/.bin/TabARds.R
cp -p -u .bin/TabAXlsx.R                    ~/.bin/TabAXlsx.R
cp -p -u .bin/XlsxAParquet.R                ~/.bin/XlsxAParquet.R
cp -p -u .bin/XlsxARds.R                    ~/.bin/XlsxARds.R
cp -p -u .bin/XlsxGetSheets.R               ~/.bin/XlsxGetSheets.R
cp -p -u .bin/convertirRscriptARmd.vim      ~/.bin/convertirRscriptARmd.vim
cp -p -u .bin/fpat.awk                      ~/.bin/fpat.awk
cp -p -u .bin/gdal_reclassify.py            ~/.bin/gdal_reclassify.py
cp -p -u .bin/getFeatherColnames.R          ~/.bin/getFeatherColnames.R
cp -p -u .bin/reemplazarEspacios.vim        ~/.bin/reemplazarEspacios.vim
cp -p -u .bin/reemplazarRenombrado.vim      ~/.bin/reemplazarRenombrado.vim
cp -p -u .bin/reenumerarBloques.vim         ~/.bin/reenumerarBloques.vim
cp -p -u .bin/rmdtags.py                    ~/.bin/rmdtags.py
cp -p -u .bin/sortgs.py                     ~/.bin/sortgs.py
cp -p -u .bin/val_repl.py                   ~/.bin/val_repl.py

dos2unix ~/.bin/CsvAParquet.R
dos2unix ~/.bin/CsvARds.R
dos2unix ~/.bin/CsvAXlsx.R
dos2unix ~/.bin/CsvComaAArroba.R
dos2unix ~/.bin/CsvEspacioAComa.R
dos2unix ~/.bin/GetColnames.R
dos2unix ~/.bin/GetDims.R
dos2unix ~/.bin/MdbARds.R
dos2unix ~/.bin/ParquetASav.R
dos2unix ~/.bin/ParquetAXlsx.R
dos2unix ~/.bin/Purl.R
dos2unix ~/.bin/RasterValoresUnicos.py
dos2unix ~/.bin/Render.R
dos2unix ~/.bin/RenderHtml.R
dos2unix ~/.bin/SavARds.R
dos2unix ~/.bin/TabARds.R
dos2unix ~/.bin/TabAXlsx.R
dos2unix ~/.bin/XlsxAParquet.R
dos2unix ~/.bin/XlsxARds.R
dos2unix ~/.bin/XlsxGetSheets.R
dos2unix ~/.bin/convertirRscriptARmd.vim
dos2unix ~/.bin/fpat.awk
dos2unix ~/.bin/gdal_reclassify.py
dos2unix ~/.bin/getFeatherColnames.R
dos2unix ~/.bin/reemplazarEspacios.vim
dos2unix ~/.bin/reemplazarRenombrado.vim
dos2unix ~/.bin/reenumerarBloques.vim
dos2unix ~/.bin/rmdtags.py
dos2unix ~/.bin/sortgs.py
dos2unix ~/.bin/val_repl.py
