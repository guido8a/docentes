package docentes

class DetalleEncuesta {

    Encuesta encuesta
    Prte prte
    ItemPregunta itemPregunta
    RespuestaPregunta respuestaPregunta
    Dictan dictan

    static mapping = {
        table 'dtec'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'dtec__id'
            encuesta column: 'encu__id'
            prte column: 'prte__id'
            itemPregunta column: 'prit__id'
            respuestaPregunta column: 'rppg__id'
            dictan column: 'dcta__id'

        }
    }

    static constraints = {
    }
}
