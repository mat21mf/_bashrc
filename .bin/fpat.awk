### Respaldo de opcion fpat para que
### reconozca RFC 4180 formato CSV
BEGIN {
   FPAT = "([^,]+)|(\"[^\"]+\")"
}
