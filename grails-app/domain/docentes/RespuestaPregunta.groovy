package docentes

class RespuestaPregunta {

    Respuesta respuesta
    Pregunta pregunta
    Double valor

    static mapping = {
        table 'rppg'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'rppg__id'
            respuesta column: 'resp__id'
            pregunta column: 'preg__id'
            valor column: 'rppgvlor'

        }
    }

    static constraints = {
    }
}
