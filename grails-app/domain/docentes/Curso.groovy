package docentes

class Curso {

    String nombre
    String codigo

    static mapping = {
        table 'crso'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'crso__id'
            nombre column: 'crsodscr'
            codigo column: 'crsocdgo'

        }
    }

    static constraints = {

        nombre(blank: false, nullable: false, size: 1..63)
        codigo(blank: true, nullable: true, size: 1..7)

    }
}
