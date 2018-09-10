package docentes

class Universidad {

    String nombre
    Date fechaInicio
    Date fechaFin
    String nombreContacto
    String apellidoContacto
    String logo

    static mapping = {
        table 'univ'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'univ__id'
            nombre column: 'univnmbr'
            nombreContacto column: 'univctnb'
            apellidoContacto column: 'univctap'
            fechaInicio column: 'univfcin'
            fechaFin column: 'univfcfn'
            logo column: 'univlogo'

        }
    }

    static constraints = {
        nombre(nullable: false, blank: false)
        nombreContacto(nullable: true, blank: true)
        apellidoContacto(nullable: true, blank: true)
        fechaInicio(nullable: true, blank: true)
        fechaFin(nullable: true, blank: true)
        logo(nullable: true, blank: true)
    }

}
