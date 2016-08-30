package docentes

class Prte {

    Pregunta pregunta
    TipoEncuesta tipoEncuesta
    int numero


    static mapping = {
        table 'prte'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'prte__id'
            pregunta column: 'preg__id'
            tipoEncuesta column: 'tpen__id'
            numero column: 'prtenmro'
        }
    }


    static constraints = {
    }
}
