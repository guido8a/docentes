package docentes

class TipoInformante {

    String codigo
    String descripcion

    static mapping = {
        table 'tpif'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'tpif__id'
            codigo column: 'tpifcdgo'
            descripcion column: 'tpifdscr'
        }
    }

    static constraints = {

        codigo(nullable: false, blank: false,size: 1..4)
        descripcion(nullable: false, blank: false, size: 1..31)
    }
}
