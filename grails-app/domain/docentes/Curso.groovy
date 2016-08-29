package docentes

class Curso {

    String nombre

    static mapping = {
        table 'crso'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'crso__id'
            nombre column: 'crsodscr'

        }
    }

    static constraints = {

        nombre(blank: true, nullable: true, size: 1..63)

    }
}
