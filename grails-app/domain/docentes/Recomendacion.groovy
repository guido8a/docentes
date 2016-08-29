package docentes

class Recomendacion {

    String descripcion

    static mapping = {
        table 'rcmn'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'rcmn__id'
            descripcion column: 'rcmndscr'
        }
    }

    static constraints = {

        descripcion(nullable: false, blank: false, size: 1..255)
    }
}
