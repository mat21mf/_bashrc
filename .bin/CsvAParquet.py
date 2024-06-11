#!/usr/bin/python -tt
#-*- coding: UTF-8 -*-

import pandas as pd
import pyarrow
import sys

args = sys.argv
if len(args)==0:
    print("Al menos un argumento debe ser suministrado.")


def TextoPlanoAParquet(strinp, strout, strdel):
    """
    Funcion:
        TextoPlanoAParquet
    Argumentos:
        strinp: archivo texto plano
        strout: archivo parquet
        strdel: carater delimitador
    Valores por defecto:
        engine: pyarrow
        compression: brotli
        compression_level: 11
    """
    objdfm = pd.read_csv(strfle, sep="@", header=None, names=txtnames, engine="pyarrow")
    objdfm.to_parquet(strout, engine="pyarrow", compression="brotli", compression_level=11)

if __name__ == "__main__":
    TextoPlanoAParquet(
    strinp   = args[1],
    strout   = args[2],
    strdel   = args[3]
    )
