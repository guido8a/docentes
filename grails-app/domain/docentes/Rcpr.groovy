package docentes

class Rcpr {

    Recomendacion recomendacion
    Pregunta pregunta

    static mapping = {
        table 'rcpr'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'rcpr__id'
            recomendacion column: 'rcmn__id'
            pregunta column: 'preg__id'
        }
    }

    static constraints = {
    }
}
