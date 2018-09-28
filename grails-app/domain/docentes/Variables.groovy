package docentes

class Variables {

    String codigo
    String descripcion
    int orden
    String sigla

    static mapping = {
        table 'vrbl'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'vrbl__id'
            codigo column: 'vrblcdgo'
            descripcion column: 'vrbldscr'
            orden column: 'vrblordn'
            sigla column: 'vrblsgla'
        }
    }

    static constraints = {
        codigo(nullable: false, blank: false, size: 1..8)
        descripcion(nullable: false, blank: false, size: 1..63)
        orden(nullable: false, blank: false)
        sigla(nullable: true, blank: true)
    }
}
