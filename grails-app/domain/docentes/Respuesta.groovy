package docentes

class Respuesta {

    String codigo
    String descripcion
    Double valor

    static mapping = {
        table 'resp'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'resp__id'
            codigo column: 'respcdgo'
            descripcion column: 'respdscr'
            valor column: 'respvlor'

        }
    }

    static constraints = {
        codigo(nullable: false, blank: false,size: 1..3)
        descripcion(nullable: false, blank: false,size: 1..20)
    }
}
