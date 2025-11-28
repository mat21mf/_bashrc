# .bashrc

## Dependencias.

```console
sudo apt install --no-install-recommends dos2unix
```

## Setup.

```console
cp -p -u .bashrc ~/.bashrc
cp -p -u .bash_functions ~/.bash_functions
cp -p -u .bash_aliases ~/.bash_aliases
```

```console
dos2unix ~/.bashrc
dos2unix ~/.bash_functions
dos2unix ~/.bash_aliases
```

## Utils.

```console
if [[ ! -d .local/bin ]] ; then mkdir .local/bin ; fi
if [[ ! -d ~/.local/bin ]] ; then mkdir ~/.local/bin ; fi
```

```console
cp -p -u .local/bin/CsvAParquet.R                 ~/.local/bin/CsvAParquet.R
cp -p -u .local/bin/CsvARds.R                     ~/.local/bin/CsvARds.R
cp -p -u .local/bin/CsvAXlsx.R                    ~/.local/bin/CsvAXlsx.R
cp -p -u .local/bin/CsvComaAArroba.R              ~/.local/bin/CsvComaAArroba.R
cp -p -u .local/bin/CsvEspacioAComa.R             ~/.local/bin/CsvEspacioAComa.R
cp -p -u .local/bin/GetColnames.R                 ~/.local/bin/GetColnames.R
cp -p -u .local/bin/GetDims.R                     ~/.local/bin/GetDims.R
cp -p -u .local/bin/MdbARds.R                     ~/.local/bin/MdbARds.R
cp -p -u .local/bin/ParquetASav.R                 ~/.local/bin/ParquetASav.R
cp -p -u .local/bin/ParquetAXlsx.R                ~/.local/bin/ParquetAXlsx.R
cp -p -u .local/bin/Purl.R                        ~/.local/bin/Purl.R
cp -p -u .local/bin/RasterValoresUnicos.py        ~/.local/bin/RasterValoresUnicos.py
cp -p -u .local/bin/Render.R                      ~/.local/bin/Render.R
cp -p -u .local/bin/RenderHtml.R                  ~/.local/bin/RenderHtml.R
cp -p -u .local/bin/SavARds.R                     ~/.local/bin/SavARds.R
cp -p -u .local/bin/TabARds.R                     ~/.local/bin/TabARds.R
cp -p -u .local/bin/TabAXlsx.R                    ~/.local/bin/TabAXlsx.R
cp -p -u .local/bin/XlsxAParquet.R                ~/.local/bin/XlsxAParquet.R
cp -p -u .local/bin/XlsxARds.R                    ~/.local/bin/XlsxARds.R
cp -p -u .local/bin/XlsxGetSheets.R               ~/.local/bin/XlsxGetSheets.R
cp -p -u .local/bin/convertirRscriptARmd.vim      ~/.local/bin/convertirRscriptARmd.vim
cp -p -u .local/bin/fpat.awk                      ~/.local/bin/fpat.awk
cp -p -u .local/bin/gdal_reclassify.py            ~/.local/bin/gdal_reclassify.py
cp -p -u .local/bin/getFeatherColnames.R          ~/.local/bin/getFeatherColnames.R
cp -p -u .local/bin/reemplazarEspacios.vim        ~/.local/bin/reemplazarEspacios.vim
cp -p -u .local/bin/reemplazarRenombrado.vim      ~/.local/bin/reemplazarRenombrado.vim
cp -p -u .local/bin/reenumerarBloques.vim         ~/.local/bin/reenumerarBloques.vim
cp -p -u .local/bin/rmdtags.py                    ~/.local/bin/rmdtags.py
cp -p -u .local/bin/sortgs.py                     ~/.local/bin/sortgs.py
cp -p -u .local/bin/val_repl.py                   ~/.local/bin/val_repl.py
```
```console
dos2unix ~/.local/bin/CsvAParquet.R
dos2unix ~/.local/bin/CsvARds.R
dos2unix ~/.local/bin/CsvAXlsx.R
dos2unix ~/.local/bin/CsvComaAArroba.R
dos2unix ~/.local/bin/CsvEspacioAComa.R
dos2unix ~/.local/bin/GetColnames.R
dos2unix ~/.local/bin/GetDims.R
dos2unix ~/.local/bin/MdbARds.R
dos2unix ~/.local/bin/ParquetASav.R
dos2unix ~/.local/bin/ParquetAXlsx.R
dos2unix ~/.local/bin/Purl.R
dos2unix ~/.local/bin/RasterValoresUnicos.py
dos2unix ~/.local/bin/Render.R
dos2unix ~/.local/bin/RenderHtml.R
dos2unix ~/.local/bin/SavARds.R
dos2unix ~/.local/bin/TabARds.R
dos2unix ~/.local/bin/TabAXlsx.R
dos2unix ~/.local/bin/XlsxAParquet.R
dos2unix ~/.local/bin/XlsxARds.R
dos2unix ~/.local/bin/XlsxGetSheets.R
dos2unix ~/.local/bin/convertirRscriptARmd.vim
dos2unix ~/.local/bin/fpat.awk
dos2unix ~/.local/bin/gdal_reclassify.py
dos2unix ~/.local/bin/getFeatherColnames.R
dos2unix ~/.local/bin/reemplazarEspacios.vim
dos2unix ~/.local/bin/reemplazarRenombrado.vim
dos2unix ~/.local/bin/reenumerarBloques.vim
dos2unix ~/.local/bin/rmdtags.py
dos2unix ~/.local/bin/sortgs.py
dos2unix ~/.local/bin/val_repl.py
```

## Por hacer.

* Identificar sistemas operativos, Linux, WSL, etc.
