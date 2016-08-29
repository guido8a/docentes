package docentes

class Dictan {

    Materia materia
    Profesor profesor
    Curso curso
    Periodo periodo
    int paralelo


    static mapping = {
        table 'dcta'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'dcta__id'
            materia column: 'mate__id'
            profesor column: 'prof__id'
            curso column: 'crso__id'
            periodo column: 'prdo__id'
            paralelo column: 'dctaprll'
        }
    }

    static constraints = {
    }
}
