package docentes

class Materia {

//    Escuela escuela
    Universidad universidad
    String codigo
    String nombre

    static mapping = {
        table 'mate'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'mate__id'
            universidad column: 'univ__id'
            codigo column: 'matecdgo'
            nombre column: 'matedscr'
        }
    }

    static constraints = {
        codigo(blank: false, nullable: false, size: 1..16)
        nombre(blank: false, nullable: false, size: 1..127)
    }
}
