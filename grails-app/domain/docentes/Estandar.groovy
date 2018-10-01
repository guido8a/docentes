package docentes

class Estandar {

    String codigo
    String descripcion

    static mapping = {
        table 'estn'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'estn__id'
            codigo column: 'estncdgo'
            descripcion column: 'estndscr'
        }
    }

    static constraints = {
        codigo(nullable: false, blank: false, size: 1..8)
        descripcion(nullable: false, blank: false, size: 1..255)
    }
}

