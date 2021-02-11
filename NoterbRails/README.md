# README

## Desarrollo


### Instalación de dependencias

Este proyecto utiliza Bundler para manejar sus dependencias.
Bundler se encarga de instalar las dependencias ("gemas")
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

### Decisiones de diseño
- Cada usuario por defecto tendra un book "Global" que no podra borrar ni editar.
- Se utilizo Sqlite3 como bd del proyecto.
- Se utilizo [Bootstrap](https://getbootstrap.com/docs/5.0/getting-started/introduction/) para una leve mejora en el diseño web.
- Para el parseo de una nota de texto rico a HTML se utilizó la libreria [Redcarpet](https://rubygems.org/gems/redcarpet/versions/3.5.0) de Natacha Porté y Vicent Martí.
- Para la exportación de books o de la totalidad de las notas se utilizó la libreria [Rubyzip](https://github.com/rubyzip/rubyzip#readme).
- Se dejó intacto el codigo antiguo con intenciones de no descartar el trabajo previo.
