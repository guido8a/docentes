package docentes

class TipoEncuesta {

    String codigo
    String descripcion
    String estado

    static mapping = {
        table 'tpen'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'tpen__id'
            codigo column: 'tpencdgo'
            descripcion column: 'tpendscr'
            estado column: 'tpenetdo'
        }
    }


    static constraints = {
        codigo(nullable: false, blank: false)
        descripcion(nullable: false, blank: false)
        estado inList: [ 'R','N']
    }
}
