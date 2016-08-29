package utilitarios

class Parametros {
    static auditable = true
    String imagenes
    String institucion

    static mapping = {
        table 'prmt'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'prmt__id'
        id generator: 'identity'
        version false
        columns {
            imagenes column: 'prmtimgn'
            institucion column: 'prmtinst'
        }
    }
    static constraints = {
        imagenes(blank: false, nullable: false, attributes: [title: 'path de las imagenes para los pdfs'])
        institucion(blank: false, nullable: false, attributes: [title: 'Nombre de la Institución'])
    }

}
