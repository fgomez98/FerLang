# FerLang
### Utilizar el comando cd para situarse en el directorio y ejecutar:
## Para compilar FerLang:
  ```
  make all
  ```
## Para eliminar el ejecutable:
  ```
  make clean
  ```
## Para compilar su .fer:
  ```
  ./compile.sh micodigo.fer
  ```  
  Se creara en el directorio donde se encuentra el .fer un archivo ejecutable con el mismo nombre que el del archivo codigo fuente
## Para compilar los Ejemplos:
  ```
  make examples
  ```
## Para intertar compilar con error de variable inexistente:
  ```
  make inexistentVarError
  ```
## Para intertar compilar con error de variable redefinida:
  ```
  make redefinitionError
  ```
## Para intertar compilar con error de tipos en asignación a variable:
  ```
  make wrongTypesError
  ```
## Para compilar los benchmarks:
  ```
  make compileBenchmarks
  ```
## Para correr los benchmarks:
  ```
  cd benchmarks
  sh benchmarks.sh
  ```
