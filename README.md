# Noterb

Plantilla para comenzar con el Trabajo Práctico Integrador de la cursada 2020 de la materia
Taller de Tecnologías de Producción de Software - Opción Ruby, de la Facultad de Informática
de la Universidad Nacional de La Plata.

Noterb, o simplemente `rn`, es un gestor de notas concebido como un clon simplificado
de la excelente herramienta [TomBoy](https://wiki.gnome.org/Apps/Tomboy).

Este proyecto es simplemente una plantilla para comenzar a implementar la herramienta e
intenta proveer un punto de partida para el desarrollo, simplificando el _bootstrap_ del
proyecto que puede ser una tarea que consume mucho tiempo y conlleva la toma de algunas
decisiones que pueden tener efectos tanto positivos como negativos en el proyecto.

## Uso de `rn`

Para ejecutar el comando principal de la herramienta se utiliza el script `bin/rn`, el cual
puede correrse de las siguientes manera:

```bash
$ ruby bin/rn [args]
```

O bien:

```bash
$ bundle exec bin/rn [args]
```

O simplemente:

```bash
$ bin/rn [args]
```

Si se agrega el directorio `bin/` del proyecto a la variable de ambiente `PATH` de la shell,
el comando puede utilizarse sin prefijar `bin/`:

```bash
# Esto debe ejecutarse estando ubicad@ en el directorio raiz del proyecto, una única vez
# por sesión de la shell
$ export PATH="$(pwd)/bin:$PATH"
$ rn [args]
```

> Notá que para la ejecución de la herramienta, es necesario tener una versión reciente de
> Ruby (2.5 o posterior) y tener instaladas sus dependencias, las cuales se manejan con
> Bundler. Para más información sobre la instalación de las dependencias, consultar la
> siguiente sección ("Desarrollo").

Documentar el uso para usuarios finales de la herramienta queda fuera del alcance de esta
plantilla y **se deja como una tarea para que realices en tu entrega**, pisando el contenido
de este archivo `README.md` o bien en uno nuevo. Ese archivo deberá contener cualquier
documentación necesaria para entender el funcionamiento y uso de la herramienta que hayas
implementado, junto con cualquier decisión de diseño del modelo de datos que consideres
necesario documentar.

## Desarrollo

Esta sección provee algunos tips para el desarrollo de tu entrega a partir de esta
plantilla.

### Instalación de dependencias

Este proyecto utiliza Bundler para manejar sus dependencias. Si aún no sabés qué es eso
o cómo usarlo, no te preocupes: ¡lo vamos a ver en breve en la materia! Mientras tanto,
todo lo que necesitás saber es que Bundler se encarga de instalar las dependencias ("gemas")
que tu proyecto tenga declaradas en su archivo `Gemfile` al ejecutar el siguiente comando:

```bash
$ bundle install
```

> Nota: Bundler debería estar disponible en tu instalación de Ruby, pero si por algún
> motivo al intentar ejecutar el comando `bundle` obtenés un error indicando que no se
> encuentra el comando, podés instalarlo mediante el siguiente comando:
>
> ```bash
> $ gem install bundler
> ```

Una vez que la instalación de las dependencias sea exitosa (esto deberías hacerlo solamente
cuando estés comenzando con la utilización del proyecto), podés comenzar a probar la
herramienta y a desarrollar tu entrega.

### Estructura de la plantilla

El proyecto te provee una estructura inicial en la cual podés basarte para implementar tu
entrega. Esta estructura no es necesariamente rígida, pero tené en cuenta que modificarla
puede requerir algún trabajo adicional de tu parte.

* `lib/`: directorio que contiene todas las clases del modelo y de soporte para la ejecución
  del programa `bin/rn`.
  * `lib/rn.rb` es la declaración del namespace `RN`, y las directivas de carga de clases
    o módulos que estén contenidos directamente por éste (`autoload`).
  * `lib/rn/` es el directorio que representa el namespace `RN`. Notá la convención de que
    el uso de un módulo como namespace se refleja en la estructura de archivos del proyecto
    como un directorio con el mismo nombre que el archivo `.rb` que define el módulo, pero
    sin la terminación `.rb`. Dentro de este directorio se ubicarán los elementos del
    proyecto que estén bajo el namespace `RN` - que, también por convención y para facilitar
    la organización, deberían ser todos. Es en este directorio donde deberías ubicar tus
    clases de modelo, módulos, clases de soporte, etc. Tené en cuenta que para que todo
    funcione correctamente, seguramente debas agregar nuevas directivas de carga en la
    definición del namespace `RN` (o dónde corresponda, según tus decisiones de diseño).
  * `lib/rn/commands.rb` y `lib/rn/commands/*.rb` son las definiciones de comandos de
    `dry-cli` que se utilizarán. En estos archivos es donde comenzarás a realizar la
    implementación de las operaciones en sí, que en esta plantilla están provistas como
    simples disparadores.
  * `lib/rn/version.rb` define la versión de la herramienta, utilizando [SemVer](https://semver.org/lang/es/).
* `bin/`: directorio donde reside cualquier archivo ejecutable, siendo el más notorio `rn`
  que se utiliza como punto de entrada para el uso de la herramienta.

## Uso de la herramienta
A grandes rasgos se podria decir que la herramienta se compone por dos grandes secciones:
   * Books: Representa a un contenedor de notas. 
   * Notes: Representa a cada una de las notas que va a persistir.
---
### Books 
Como se ha dicho previamente, los books representan contenedores de notas, podriamos darle un
 nombre mas amigable, como cuaderno. 
 Por default existe un cuaderno global que va a contener todas las notas que no esten asignadas
 a un cuaderno especifico.
Cada vez que en un comando se quiera hacer referencia a un cuaderno se va a utilizar la palabra
clave `books`. 
```bash
$ ruby bin/rn books comando1 [argumento1] [--opcion]
```
>En este caso, se esta ejecutando el `comando1` que pertenece a los cuadernos
>,que podria llevar el argumento opcional `argumento1` y la opcion `--opcion`.
>Con esto podemos ya irnos familiarizando con la sintaxis de Noterb.
#### Comandos
   * `create :name`-> crea un nuevo cuaderno con nombre name
   * `delete :name [--global]`-> elimina un cuaderno con nombre name. Opcional '--global'
    elimina todas las notas del cuaderno global.
   * `list`-> lista los cuadernos
   * `rename :old_name :new_name`-> renombra el cuaderno old_name a new_name
   * `export :name [--global]`-> exporta las notas de un cuaderno con nombre name. Opcional '--global'
   exporta todas las notas del cuaderno global

A continuacion, una breve ejemplificacion de los comandos recien nombrados.
```bash
$ ruby bin/rn books create "My book"
>BOOK CREATED: My book, PATH: C:/Users/agusa/.my_rns/My book

$ ruby bin/rn books delete "My book"
>BOOK DELETED: My book, PATH:C:/Users/agusa/.my_rns/My book

$ ruby bin/rn books delete --global
>NOTE DELETED: globalNote1.rn, PATH:C:/Users/agusa/.my_rns/global/globalNote1.rn
>NOTE DELETED: globalNote2.rn, PATH:C:/Users/agusa/.my_rns/global/globalNote2.rn
>NOTE DELETED: globalNote3.rn, PATH:C:/Users/agusa/.my_rns/global/globalNote3.rn
>All global notes have been deleted.

$ ruby bin/rn books list
>global
>book
>book2
>book3

$ ruby bin/rn books rename book book1
>BOOK RENAMED: book ->> book1

$ ruby bin/rn books export book1
>NOTE EXPORTED: note1, PATH: C:/Users/agusa/.my_rns/book1/.exported/note1.html
>NOTE EXPORTED: note11, PATH: C:/Users/agusa/.my_rns/book1/.exported/note11.html
>NOTE EXPORTED: note111, PATH: C:/Users/agusa/.my_rns/book1/.exported/note111.html
>BOOK: book1 -> finished exporting process.
```
---
### Notes 
Las notes representan al archivo que va a contener el conjunto de caracteres que represente a la
nota en sí.
 Por default las notas que no se asignen a un cuaderno se guardaran en el cuaderno 'global'.
Cada vez que en un comando se quiera hacer referencia a una nota se va a utilizar la palabra
clave `notes`. 
```bash
$ ruby bin/rn notes comando1 [argumento2] [--book cuaderno]
```
>En este caso, se esta ejecutando el `comando2` que pertenece a las notas
>,que podria llevar el argumento opcional `argumento1` y la opcion `--book` con
>valor 'cuaderno'.
#### Comandos
Para todos los comandos de una nota existe la opcion `--book` que va a indicar en que cuaderno 
se tiene que buscar la nota indicada. Por default esta opcion apunta al cuaderno global, es decir,
cuando no se indique, se utilizara al cuaderno global.
   * `create :title [--book]`-> crea una nueva nota con nombre title.
   * `delete :title [--book]`-> elimina la nota con nombre title.
   * `edit :title [--book]`-> inicia el gestor de texto por default del SO, que permite
   editar el contenido de la nota title.
   * `retitle :old_title :new_title [--book]`-> renombra la nota old_title a new_title.
   * `list [--book] [--global]`-> Lista todas las notas del cajon. Si se especifica `--global` o
   `--book`, lista las notas del cuaderno especificado.
   * `show :title [--book]`-> Imprime la nota title.
   * `export [:title] [--book]`-> Exporta todas las notas a formato html. Si se indica :title,
   solo se exporta la nota con tal nombre.

A continuacion, algunos ejemplos.
```bash
$ ruby bin/rn notes create globalNote
>NOTE CREATED: globalNote, BOOK: global, PATH: C:/Users/agusa/.my_rns/global/globalNote.rn

$ ruby bin/rn notes create globalNote --book book2
>NOTE CREATED: globalNote, BOOK: book2, PATH: C:/Users/agusa/.my_rns/book2/globalNote.rn

$ ruby bin/rn notes delete globalNote --book book2
>NOTE DELETED: globalNote, BOOK: book2, PATH: C:/Users/agusa/.my_rns/book2/globalNote.rn

$ ruby bin/rn notes edit globalNote
>NOTE EDITED: globalNote, PATH: C:/Users/agusa/.my_rns/global/globalNote.rn

$ ruby bin/rn notes retitle globalNote retitledNote
>NOTE RENAMED: globalNote ->> retitledNote, PATH: C:/Users/agusa/.my_rns/global/retitledNote.rn

$ ruby bin/rn notes list
>note1.rn, BOOK: book1
>note2.rn, BOOK: book2
>retitledNote.rn, BOOK: global

$ ruby bin/rn notes list --book book1
>note1.rn, BOOK: book1
>note11.rn, BOOK: book1
>note111.rn, BOOK: book1

$ ruby bin/rn notes show note1 --book book1
>OMG! This is my "Hello World" note.

$ ruby bin/rn notes export
>NOTE EXPORTED: note1, PATH: C:/Users/agusa/.my_rns/book1/.exported/note1.html
>File note3 already exported. PATH: C:/Users/agusa/.my_rns/book3/.exported/note3.html

$ ruby bin/rn notes export note1 --book book1
>NOTE EXPORTED: note1, PATH: C:/Users/agusa/.my_rns/book1/.exported/note1.html
```

### Decisiones de diseño
-Para la edicion de la nota se eligio usar la libreria [tty-editor](https://rubygems.org/gems/tty-editor/versions/0.6.0) de Piotr Murach

-Tanto en nombres de notas como de cuadernos no se permiten usar mas que letras, numeros y espacios. Así,
a costas de personalizacion, se asegura que funcione en diferentes SO.

-Para el parseo de una nota de texto rico a HTML se utilizó la libreria [Redcarpet](https://rubygems.org/gems/redcarpet/versions/3.5.0) de Natacha Porté y Vicent Martí.
