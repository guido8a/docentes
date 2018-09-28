package docentes

class Indicador {
    String codigo
    String descipcion

    static mapping = {
        table 'indi'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'indi__id'
            codigo column: 'indicdgo'
            descipcion column: 'indidscr'
        }
    }

    static constraints = {
        codigo(blank: false, nullable: false, size: 1..8)
        descipcion(blank: false, nullable: false, size: 1..255)
    }
}
