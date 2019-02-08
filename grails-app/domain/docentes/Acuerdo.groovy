package docentes

class Acuerdo {

    Dictan dictan
    Date fecha
    Date fechaModificada
    String texto


    static mapping = {
        table 'acrd'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'acrd__id'
            dictan column: 'dcta__id'
            fecha column: 'acrdfcha'
            fechaModificada column: 'acrdfcmd'
            texto column: 'acrdtxto'
        }
    }

    static constraints = {
        fechaModificada(nullable: true, false: true)
        fecha(nullable: true, false: true)
        texto(nullable: true, false: true)
    }
}
