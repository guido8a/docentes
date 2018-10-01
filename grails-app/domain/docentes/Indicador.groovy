package docentes

class Indicador {
    String codigo
    String descripcion
    Variables variables
    Estandar estandar


    static mapping = {
        table 'indi'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'indi__id'
            codigo column: 'indicdgo'
            descripcion column: 'indidscr'
            variables column: 'vrbl__id'
            estandar column: 'estn__id'
        }
    }

    static constraints = {
        codigo(blank: false, nullable: false, size: 1..15)
        descripcion(blank: false, nullable: false, size: 1..255)
        estandar(nullable: false, blank:false)
        variables(nullable: false, blank: false)
    }
}
