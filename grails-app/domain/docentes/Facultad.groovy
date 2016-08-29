package docentes

class Facultad {

    String codigo
    String nombre

    static mapping = {
        table 'facl'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'facl__id'
            codigo column: 'faclcdgo'
            nombre column: 'facldscr'
        }
    }

    static constraints = {
        codigo(blank: false, nullable: false, size: 1..8)
        nombre(blank: false, nullable: false, size: 1..127)
    }
}
