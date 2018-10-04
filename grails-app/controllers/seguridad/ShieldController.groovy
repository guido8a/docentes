package seguridad

class ShieldController {
    def loginService
    def ataques = {
        def msn="Acceso no autorizado"
        render(view:"advertencia",model:[msn:msn])
    }

    def error404 = {
        def msn="Esta tratando de ingresar a una accion no registrada en el sistema. " +
                "Por favor use las opciones del menu para navegar por el sistema."
        render(view:"advertencia",model:[msn:msn])
    }

}
