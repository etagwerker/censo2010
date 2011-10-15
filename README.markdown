# Censo 2010 (API)

API del Censo 2010. Disponible aquí: [http://censo.heroku.com](http://censo.heroku.com)

Este código sirve para ver los datos del Censo 2010 en formato JSON. Los datos vienen de [https://github.com/etagwerker/c2010-scrapper](https://github.com/etagwerker/c2010-scrapper)

## Instalación

### Requerimientos

* Tener Posgres
* Crear una base de datos 
* Ajustar el string de conexión a la DB (Ver ./lib/data_loader.rb)

### Pasos

* git clone git://github.com/etagwerker/censo2010
* cd censo2010
* git checkout v2
* rvm gemset import default.gems
* rackup

## Objetivo

La idea es hacer más fácil el consumo de datos sin tener que buscar siempre sobre el CSV. Para ver ejemplos: [http://censo.heroku.com](http://censo.heroku.com)

### Documentación

Ver [http://censo.heroku.com](http://censo.heroku.com)

## Roadmap

* Más tests, esta API solo tiene tests manuales :$
* Ordenamiento de resultados según alguno de los atributos devueltos. Por ejemplo: GET /personas_por_vivienda?mujeres_por_vivienda=asc o GET /buenos_aires?superficie=asc
* Otras sugerencias de métodos son bienvenidos

## Contribuciones
 
* Cualquier contribución es bienvenida
* Fork the project
* Make your feature addition or bug fix
* Add tests for it. This is important so I don't break it in a
  future version unintentionally
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches

## License

(The MIT License)

Copyright (c) 2011 Ernesto Tagwerker <ernesto@etagwerker.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.