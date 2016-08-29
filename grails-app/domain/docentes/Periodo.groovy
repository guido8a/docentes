package docentes

class Periodo {

    String nombre
    Date fechaInicio
    Date fechaFin

    static mapping = {
        table 'prdo'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'prdo__id'
            nombre column: 'prdonmbr'
            fechaInicio column: 'prdofcin'
            fechaFin column: 'prdofcfn'
        }
    }


    static constraints = {
    }
}
