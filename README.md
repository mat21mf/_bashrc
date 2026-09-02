# .bashrc

Personal dotfiles: shell config, functions, aliases, and a handful of small
CLI utilities, kept in sync across a WSL Ubuntu 24.04 instance, an Ubuntu
22.04 laptop, and a Rocky Linux machine.

## Dependencias.

```console
sudo apt install --no-install-recommends dos2unix
```

## Setup.

```console
cp -p -u .bashrc ~/.bashrc
cp -p -u .bash_functions ~/.bash_functions
cp -p -u .bash_aliases ~/.bash_aliases
dos2unix ~/.bashrc ~/.bash_functions ~/.bash_aliases
```

## Deploying the utilities.

Everything under `.local/bin/` (except what's listed in
`.deploysyncignore`) is deployed to `~/.local/bin` with `deploy_sync.py`,
aliased as `SincronizarDespliegue`:

```console
SincronizarDespliegue
```

It diffs tracked files against what's already deployed and only touches
what changed; backups of overwritten files are kept alongside (non
executable, so they don't clutter `$PATH`).

## Utils.

Format conversion (R, mostly wrapping common geo/tabular formats):

| Script              | Purpose                        |
|----------------------|--------------------------------|
| `CsvAParquet.R` / `.py` | CSV to Parquet               |
| `CsvARds.R`          | CSV to RDS                     |
| `CsvAXlsx.R`         | CSV to Excel                   |
| `CsvComaAArroba.R`   | Swap CSV comma delimiter to `@`|
| `CsvEspacioAComa.R`  | Swap CSV space delimiter to `,`|
| `MdbARds.R`          | Access MDB to RDS              |
| `ParquetASav.R`      | Parquet to SPSS SAV            |
| `ParquetAXlsx.R`     | Parquet to Excel               |
| `TabARds.R`          | Generic tabular to RDS         |
| `TabAXlsx.R`         | Generic tabular to Excel       |
| `XlsxAParquet.R`     | Excel to Parquet               |
| `XlsxARds.R`         | Excel to RDS                   |

Inspection:

| Script              | Purpose                          |
|----------------------|-----------------------------------|
| `GetColnames.R`      | Print column names                |
| `GetDims.R`          | Print dimensions (rows/cols)      |
| `getFeatherColnames.R` | Column names of a Feather file  |
| `XlsxGetSheets.R`    | List sheet names in an Excel file |

Rendering / docs:

| Script              | Purpose                          |
|----------------------|-----------------------------------|
| `Render.R` / `RenderHtml.R` | Render R Markdown            |
| `Purl.R`             | Extract R code from an Rmd        |
| `rmdtags.py`         | Rmd tag helpers                   |

Misc:

| Script              | Purpose                          |
|----------------------|-----------------------------------|
| `gdal_reclassify.py` | Raster reclassification (GDAL)    |
| `RasterValoresUnicos.py` | Unique raster values          |
| `sortgs.py`          | Sort helper                       |
| `val_repl.py`        | Value replacement                 |
| `fpat.awk`           | Field-pattern awk helper          |
| `table_formatter.py` | Reusable CSV/table pretty-printer |
| `rename_timestamp.py` | Timestamp-based bulk rename (`RenombrarTimestamps`) |
| `deploy_sync.py`     | Deploys `.local/bin` content (`SincronizarDespliegue`) |

Vim macros:

`convertirRscriptARmd.vim`, `reemplazarEspacios.vim`,
`reemplazarRenombrado.vim`, `reenumerarBloques.vim` - copy to `~/.vim` per
the `_vimrc` repo setup.

## Por hacer.

* Identificar sistemas operativos, Linux, WSL, etc.
* Review/prune scripts that are no longer used (deferred).
