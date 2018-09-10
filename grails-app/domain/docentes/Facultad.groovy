package docentes

class Facultad {

    String codigo
    String nombre
    Universidad universidad

    static mapping = {
        table 'facl'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'facl__id'
            codigo column: 'faclcdgo'
            nombre column: 'facldscr'
            universidad column: 'univ__id'
        }
    }

    static constraints = {
        codigo(blank: false, nullable: false, size: 1..8)
        nombre(blank: false, nullable: false, size: 1..127)
        universidad(blank: true, nullable: true)
    }
}
