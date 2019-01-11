package docentes

class MateriaEscuela {
    Materia materia
    Escuela escuela

    static mapping = {
        table 'mtes'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'mtes__id'
            materia column: 'mate__id'
            escuela column: 'escl__id'
        }
    }

}
