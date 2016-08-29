package docentes

class Estudiante {

    String cedula
    String nombre
    String apellido

    static mapping = {
        table 'estd'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'estd__id'
            nombre column: 'estdnmbr'
            apellido column: 'estdapll'
            cedula column: 'estdcdla'
        }
    }

    static constraints = {
        cedula(blank: false, nullable: false)
        nombre(blank: false, nullable: false, size: 1..31)
        apellido(blank: false, nullable: false, size: 1..31)
    }
}
