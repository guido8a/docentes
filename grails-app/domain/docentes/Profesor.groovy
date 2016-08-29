package docentes

class Profesor {

    String cedula
    String nombre
    String apellido
    String sexo
    Date fechaNacimiento
    String titulo
    Date fechaInicio
    Date fechaFin
    String estado
    String observacion
    String evaluar


    static mapping = {
        table 'prof'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'prof__id'
            cedula column: 'profcdla'
            nombre column: 'profnmbr'
            apellido column: 'profapll'
            sexo column: 'profsexo'
            fechaNacimiento column: 'proffcna'
            titulo column: 'proftitl'
            fechaInicio column: 'proffcin'
            fechaFin column: 'proffcfn'
            estado column: 'profetdo'
            observacion column: 'profobsr'
            evaluar column: 'profeval'
        }
    }


    static constraints = {

        cedula(blank: false, nullable: false)
        nombre(blank: false, nullable: false, size: 1..31)
        apellido(blank: false, nullable: false, size: 1..31)
    }
}
