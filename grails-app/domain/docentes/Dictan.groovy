package docentes

class Dictan {

//    MateriaEscuela materiaEscuela
//    ProfesorEscuela profesorEscuela
    Curso curso
    Periodo periodo
    Escuela escuela
    Materia materia
    Profesor profesor
    int paralelo


    static mapping = {
        table 'dcta'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'dcta__id'
//            materiaEscuela column: 'mtes__id'
//            profesorEscuela column: 'pfes__id'
            curso column: 'crso__id'
            periodo column: 'prdo__id'
            escuela column: 'escl__id'
            materia column: 'mate__id'
            profesor column: 'prof__id'
            paralelo column: 'dctaprll'
        }
    }

    static constraints = {
    }
}
