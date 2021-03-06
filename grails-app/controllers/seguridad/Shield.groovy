package seguridad

class Shield {
    def beforeInterceptor = [action: this.&auth, except: 'login']

    /**
     * Verifica si se ha iniciado una sesión
     * Verifica si el usuario actual tiene los permisos para ejecutar una acción
     */
    def auth() {
        println "acción: " + actionName + " controlador: " + controllerName + "  "
        println "shield sesión: " + session?.usuario
        session.an = actionName
        session.cn = controllerName
        session.pr = params

        if(actionName in ['pdfLink', 'profesNoEvaluados', 'profesEvaluados', 'asignaturas', 'recomendaciones',
                          'reporteDesempeno', 'cuellosBotella', 'potenciadores', 'reporteTipoEncuesta',
                          'reporteDesempenoVariables']) {
            return true
        }



        if(session.an == 'saveTramite' && session.cn == 'tramite'){
            println("entro")
            return true

        } else {
//            if ((!session.usuario || !session.perfil) && actionName == 'reportes') {
            if (!session.usuario || !session.perfil) {
                if(controllerName != "inicio" && actionName != "index") {
                    flash.message = "Usted ha superado el tiempo de inactividad máximo de la sesión"
                }
                render "<script type='text/javascript'> window.location.href = '${createLink(controller:'login', action:'login')}' </script>"
//                    redirect(controller: 'login', action: 'login')
                    session.finalize()
                    return false
            } else {
                def now = new Date()
                def band = true  
//            use(groovy.time.TimeCategory) {
//                def duration = now - session.time
//                if(duration.minutes>4){
//                    session.usuario=null
//                    session.finalize();
//                    band = false
//                }else{
//                    session.time=now;
//                }
//            }
//            if(!band) {
////                redirect(controller: 'login', action: 'logout')
////                render "<script type='text/javascript'> window.location.href = " + createLink(controller: "login", action: "login") + "; location.reload(true); </script>"
//                redirect(controller: 'login', action: 'finDeSesion')
//                return false
//            }
                def usu = Persona.get(session.usuario.id)
//                println("usuario activo: " + usu.estaActivo)
                if (usu.estaActivo) {

//                println "AQUI??????"
//                println "controlador: $controllerName acción: $actionName"

//                    session.departamento = Departamento.get(session.departamento.id).refresh()
                    def perms = session.usuario.permisos
                    session.usuario = Persona.get(session.usuario.id).refresh()
                    session.usuario.permisos = perms

                            if (!isAllowed()) {
                                redirect(controller: 'shield', action: 'ataques')
                                return false
                            }

//                return true
                } else {
                println "session.flag shield "+session.flag
                    if (!session.flag || session.flag < 1) {
//                    println "menor que cero "+session.flag
                        session.usuario = null
                        session.perfil = null
                        session.permisos = null
                        session.menu = null
                        session.an = null
                        session.cn = null
                        session.invalidate()
                        session.flag = null
                        session.finalize()
                        redirect(controller: 'login', action: 'login')
                        return false
                    } else {
                        session.flag = session.flag - 1
//                        session.departamento = Departamento.get(session.departamento.id).refresh()
                        return true
                    }
                }
            }
            /*************************************************************************** */
        }
    }


    boolean isAllowed() {
//        println "session: ${session.permisos}"
        try {
            if (request.method == "POST" || actionName == 'pdfLink') {
                return true
            }
            println "is allowed Accion: ${actionName.toLowerCase()} ---  Controlador: ${controllerName.toLowerCase()} " +
                    "--- Permisos de ese controlador: "+session.permisos[controllerName.toLowerCase()]

            if (!session.permisos[controllerName.toLowerCase()]) {
                return false
            } else {
                if (session.permisos[controllerName.toLowerCase()].contains(actionName.toLowerCase())) {
                    return true
                } else {
                    return false
                }
            }

        } catch (e) {
            println "Shield execption e: " + e
            return false
        }
            return false

//        return true     /* comentar para validar */
    }

}
 
