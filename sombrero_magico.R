## En R la almohadilla ("#") sirve para comentar los scripts. Todo lo que vaya seguido de una # no será leido por la consola de R.


###  Aquí cargo las librerías que voy a usar en adelante
library(readr)  
library(dplyr)
library(stringr)


## Importo el csv con los nombres de la clase y le asignamos el nombre 'estudiantes'
estudiantes <- read_delim("estudiantes.csv", 
                          ";", escape_double = FALSE, trim_ws = TRUE)

## Imprimimos el data frame que hemos creado para ver qué columnas tiene
print(estudiantes)

## Como están los apellidos y los nombres separados los 'pego' con la funcion paste y les asigno un nombre
alumnos <- paste(estudiantes$Nombre, estudiantes$Apellidos)

# Como somos 29, añado un valor 'sin valor' para que salgan grupos de 3. Si no hiciesemos esto tendríamos problemas con la longitud de los variables
alumnos <- c(alumnos, NA)  

# Como hay un problema con la codificación de las 'ñ' lo corrijo sustituyendo los caracteres ASCII que corresponden a una 'ñ' por la letra en sí
alumnos <- str_replace_all(alumnos, "\xa5", "Ñ")


## Creo un data frame nuevo con los nombres de los alumnos asignandoles un numero identificador único
df <- data.frame(nombre = alumnos, id = 1:length(alumnos))

print(df)  # visualizo el data frame creado


## Ahora toca componer los grupos. 
## Como somos casi 30 debemos crear 10 grupos (nueve de 3 y uno de 2). 
## Para ello creo un vector dedel 1 al 10 repetido tres veces. La funcion c() sirve para concatenar vectores o strings (los strings son vectores de texto).

grupo <- c(1:10, 1:10, 1:10)
grupo <- sample(grupo, 30) # Con esta funcion aleatorizo el orden del vector 'grupo'

## A continuación, con la función cbind() uno el data frame creado anteriormente (el que contiene los nombres con sus identificadores) con el vector de los identificadores de grupo aleatorizados. 
## Es importante señalar que para usar la función cbind() es necesario que las columnas que se unen tengan la misma longitud (es decir: las mismas filas).
## Además ordeno, con la función arrange(), el data frame resultante en función del identificador de grupo.
## El operador '%>%' sirve para encadenar secuencias. De tal forma que coge el resultado de la funcion cbind() y le aplica la funcion arrange().
df_grupos <- cbind(df, grupo) %>% arrange(grupo)

print(df_grupos)  # Imprimo el data frame recién creado


## Ahora que ya tenemos los grupos asignados toca asignar a cada grupo las lecturas. Asigno las lecturas y por lo tanto la sesión. 
## Recordad que los grupos deben hacer un ensayo de las tres lecturas de la sesión que les toque pero la exposición la hacen solo de una de ellas.
## Hay 18 lecturas osea que a uno o dos grupos se les asignará solo una lectura. Estoy hay que ver con Pablo como se soluciona.

## Divido las 18 lecturas en dos bloques iguales de nueve lecturas cada una. 
## Hay 10 grupos pero solo 18 lecturas por lo que asigno un valor 'sin valor' a cada bloque de lecturas (por la misma razón que antes lo he hecho con los estudiantes).
lecturas1 <- 1:9
lecturas1 <- c(lecturas1, NA)
lecturas1 <- sample(lecturas1, 10) # aleatorizo el orden de las lecturas

lecturas2 <- 10:18
lecturas2 <- c(lecturas2, NA)
lecturas2 <- sample(lecturas2, 10)


df_lecturas <- data.frame(grupo = 1:10, lectura1 = lecturas1, lectura2 = lecturas2)
print(df_lecturas)

# Ahora tenemos las dos lecturas de cada grupo pero no sabemos quién compone esos grupos.
# Para saberlo vamos a unir dos data frames en función de una columna que es igual en ambos data frames: en este caso el id de los grupos. Esto se hace con la función merge()
# Primero imprimos los dos data frames para verlos mejor
print(df_grupos)
print(df_lecturas)

# Como veis, los dos data frames tienen una longitud distinta. Uno tiene 30 filas (los 29 alumnos más el valor sin valor para que cuadre) y el otro tiene 10 filas (las 18 lecturas más los dos valores sin valor para que cuadre).
# Si esto ocurre (que la longitud de los data frame a unir es distinta) la función merge() repetirá los valores que se repitan. Esto no lo he explicado muy bien, en persona os lo explico mejor.
# La función merge() necesita que le digas los nombres de los dos data frames que quieres unir y, MUY IMPORTANTE, la columna que tienen en común: en este caso la del identificador del grupo.

df_final <- merge(df_grupos, df_lecturas, by = "grupo") %>% arrange(lectura1)  # hago merge y ordeno en función de las primeras lecturas
print(df_final)  # imprimo el resultado final
