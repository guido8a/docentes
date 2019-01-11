package docentes

class ProfesorEscuela {
    Profesor profesor
    Escuela escuela

    static mapping = {
        table 'pfes'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'pfes__id'
            profesor column: 'prof__id'
            escuela column: 'escl__id'
        }
    }

    static constraints = {
    }
}
