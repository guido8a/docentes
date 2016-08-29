package docentes

class Matriculado {

    Dictan materiaDictada
    Estudiante estudiante

    static mapping = {
        table 'matr'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'matr__id'
            materiaDictada column: 'dcta__id'
            estudiante column: 'estd__id'
        }
    }

    static constraints = {
    }
}
