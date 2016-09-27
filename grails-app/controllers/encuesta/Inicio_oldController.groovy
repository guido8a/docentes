package encuesta

class Inicio_oldController {
    def dbConnectionService

    static datos = []
    static lstacmbo = []

//    def db = new db()
//    static Connection cn = null

//    def index = { redirect(action:"inicio")}

    def inicio() {

    }

    def ingreso() {
        println "ingreso: $params"
        session.tipoPersona = params.tipo
        session.cedula = params.cdla
        if(params.tipo == 'E') {
//            session.modulo = "prof" //??
            if((existeEstudiante(session.cedula))) {
                redirect(action:"ponePregunta", params: params)
            }

        } else if (params.tipo == 'D') {
            if(existeProfesor(session.cedula)){
                def tipo = tipoEncuesta(session.cedula,session.tipoPersona)
                session.tipo = tipo
                if(tipo != "X"){
                    redirect(action:"pantallaDeEspera")
                } else {
                    flash.message="Usted ya aplicó la ponePregunta"
                    redirect(action:"inicio")
                }
            }
            else{
                flash.message="Usted no está registrado en el sistema"
                redirect(action:"login", params: params)
            }

        }

        flash.message = "verifique su número de cédula e intente nuevamente"
        redirect(action:"inicio", params: params)
    }

    /* TODO se puede tambien validar estudiantes en esta instancia--
     *  depende de si se aceptan o no registro de nuevos estudiantes para evaluar
     *  */
    def login() {
        println params
        def tx = ""
        if (request.method == "POST") {
            session.setAttribute("cedula",  params.cdla)
            session.setAttribute("modulo",  "prof")
            if(params.tipo.toUpperCase() == "PROF") {
                if(existeProfesor(session.cedula)){
                    session.tipoPersona = "P"
                    def tipo = tipoEncuesta(session.cedula,session.tipoPersona)
                    session.tipo=tipo
                    if(tipo != "X"){
                        redirect(action:"pantallaDeEspera")
                    } else {
                        flash.message="Usted ya aplicó la ponePregunta"
                        redirect(action:"login")
                    }
                }
                else{
                    flash.message="Usted no está registrado en el sistema"
                    redirect(action:"login")
                }

            } else {
                session.tipoPersona = "E"

                if((existeEstudiante(session.cedula))) {
                    redirect(action:"pantallaDeEspera")
                    return
                }
           }
        }
    }



    def loginAdm={
        if (request.method == "POST") {
            session.setAttribute("cedula",  params.cdla)
            session.setAttribute("modulo",  "adm")
            db.setDB("adm")
            if(params.tipo=="ext"){
                session.setAttribute("tpin","ext")
                redirect(action:"pantallaDeEspera")
            }else {
                session.setAttribute("tpin","auto")
                redirect(action:"pantallaDeEspera")
            }
        }
    }

    def loginIns={
        if (request.method == "POST") {
            session.setAttribute("cedula",  params.cdla)
            session.setAttribute("modulo",  "ins")
            db.setDB("ins")
            if(params.tipo=="ext"){
                session.setAttribute("tpin","ext")
                redirect(action:"pantallaDeEspera")
            }else {
                if(params.tipo=="int"){
                    session.setAttribute("tpin","int")
                    redirect(action:"pantallaDeEspera")
                }else{
                    session.setAttribute("tpin","a")
                    redirect(action:"pantallaDeEspera")
                }
            }
        }
    }


    def loginPares={

        if (request.method == "POST") {
            //println "login pares "+params
            session.setAttribute("cedula",  params.cdla)
            session.setAttribute("modulo",  "prof")
            db.setDB("prof")
            def esc =  verificaCedula(params.cdla,"P")
            if(esc){
                def opciones = verificaEncuesta(params.cdla,esc)
                def msg =""
                if(opciones.size()<1){
                    msg="Ya ha Evaluado a todos sus Profesores"
                }
                session.setAttribute("tpin","PR")
                session.opciones=opciones
                session.esPar=true
                session.tipo="PR"
                session.tipoPersona="Par"
                redirect(action: "listaProfesores",params: [msg:msg])
                return
            }else{
                [msg:"Verifique el número de su cédula de identidad"]
            }
        }
    }

    def prepEncuestaPares={
        //println "prepEncuestaPares "+params
        session.evaluado=params.cedula
        session.materia=params.materia
        session.curso=params.curso
        render "ok"
    }



    def listaProfesores={
        [opciones:session.opciones, msg:params.msg]
    }

    def loginDirec ={
        if (request.method == "POST") {
            //println "login direct "+params
            session.setAttribute("cedula",  params.cdla)
            session.setAttribute("modulo",  "prof")
            db.setDB("prof")
            def esc =  verificaCedula(params.cdla,"S")
            if(esc){
                def opciones = verificaEncuestaDir(params.cdla)
                def msg =""
                if(opciones.size()<1){
                    msg="Ya ha Evaluado a todos sus Profesores"
                }
                session.setAttribute("tpin","P")
                session.opciones=opciones
                session.esDirectivo=true
                session.tipo="DI"
                session.tipoPersona="Dir"
                redirect(action: "listaProfesores",params: [msg:msg])
                return
            }else{
                [msg:"Verifique el número de su cédula de identidad"]
            }
        }
    }

    def pantallaDeEspera = {
        //println session
        def cn = dbConnectionService.getConnection()
        def prsn = ""
        def sql = ""
        if(session.tipoPersona == 'E') sql = "select estdnmbr nmbr, estdapll apll from estd where estdcdla = '${session.cedula}'"

        if(session.tipoPersona == 'P') sql = "select profnmbr nmbr, profapll apll from prof where profcedl = '${session.cedula}'"
        if(session.tipoPersona == 'Par') sql = "select profnmbr nmbr, profapll apll from prof where profcedl = '${session.cedula}'"
        if(session.tipoPersona == 'Dir') sql = "select profnmbr nmbr, profapll apll from prof where profcedl = '${session.cedula}'"

        //println "pantallaDeEspera" + sql+ "\n tipoPersona: ${session.tipoPersona}, ${session.esPar}, ${session.esDirectivo}"
        cn.eachRow(sql.toString()) { d ->
            if(d.nmbr) prsn = d.nmbr + " " + d.apll
        }
        cn.close()
        [persona: session.tipoPersona, prsn: prsn]
        //println " session espera " + session.cedula + " " + session.modulo + "  " + session.tpin
    }

    def abrir={
        //println " session abrir " + session.cedula + " " + session.modulo + "  " + session.tpin + session.tipoPersona
        if(session.modulo == "prof") {
            if(session.tipoPersona == "P") { redirect(controller: "encuestas", action: "ponePregunta") }
            if(session.tipoPersona == "Par") { redirect(controller: "encuestas", action: "ponePregunta") }
            if(session.tipoPersona == "Dir") { redirect(controller: "encuestas", action: "ponePregunta") }
            if(session.tipoPersona == "E") { redirect(action: "registro") }
/*

            if(session.tipoPersona != "P"){
                if(session.tipoPersona != "Par"){
                    if(session.tipoPersona != "Dir") {
                        redirect(action: "registro")
                    } else {
                        redirect(controller: "encuestas", action: "ponePregunta")
                    }
                }else  {
                    redirect(controller: "encuestas", action: "ponePregunta")
                }
            } else {
                redirect(controller: "encuestas", action: "ponePregunta")

            }
*/
        }
        else{
            redirect(action:"registroAdm")
        }
    }

//    def registroAdmFlow={
//        inicioAdm{
//            action{
////                flow.db = new db()
//                flow.db = ""
//                flow.db.setDB(session.modulo)
//                cn = ConnectionFactory.getConnection('Fire')
//                flow.cedula=session.cedula
//                if(session.modulo=="adm")
//                    flow.dependencias=cargarDependencias()
//                flow.persona=[]
//
//                if(session.tpin=="ext"){
//                    if(!existePersona(session.cedula)){
//                        flow.esAdmin=false
//                        session.esAdmin=false
//                        if(existeAdministrativo(session.cedula)){
//                            flow.esAdmin=true
//                            session.esAdmin=true
//                            //println "es admin !·! "+session.esAdmin
//                            return yes()
//                        }
//                        if(session.modulo=="adm")
//                            return no()
//                        else
//                            return noInst()
//                    }else{
//                        if(existeAdministrativo(session.cedula)){
//                            flow.esAdmin=true
//                            session.esAdmin=true
//                        }
//                        return yes()
//                    }
//                }else{
//                    if(existeAdministrativo(session.cedula)){
//                        if(session.modulo=="adm"){
//                            //println "autoevaluacion "+autoEvaluacion(session.cedula)+" "+session.cedula
//                            if(autoEvaluacion(session.cedula)){
//                                flow.esAdmin=true
//                                session.esAdmin=true
//                                return auto()
//                            }else{
//                                flow.mensaje="Usted ya realizo su auto evalucaión."
//                                return error()
//                            }
//                        }else {
//                            flow.esAdmin=true
//                            session.esAdmin=true
//                            return yes()
//                        }
//                    }else{
//                        flow.mensaje="Usted no se encuentra registrado en el sistema."
//                        return error()
//                    }
//                }
//
//            }
//            on("no").to "datosPersonales"
//            on("yes").to "cargarDatos"
//            on("auto").to "datosAuto"
//            on("error").to "error"
//            on("noInst").to "datosPersonalesIns"
//        }
//
//        datosAuto{
//            action{
//                flow.persona=session.persona
//                //println "session persona "+flow.persona+" cedula "+flow.cedula
//                session.adm=[flow.cedula,flow.persona[5]]
//                cn = ConnectionFactory.getConnection('Fire')
//                flow.connected = cn.connect(flow.db.url, flow.db.driver, flow.db.user, flow.db.pass)
//                flow.sql="select tpencdgo from tecg where crgocdgo='${flow.persona[5]}'"
//                session.tipo="X"
//                cn.getDb().eachRow(flow.sql) { d ->
//                    session.tipo=d.tpencdgo
//                }
//                cn.disconnect()
//                if(session.tipo=="X"){
//                    flow.mensaje="No existe una ponePregunta definida para su cargo, por favor comuniquese con el administrador del sistema."
//                    return error()
//                }
//                return success()
//            }
//            on("success").to "ponePregunta"
//            on("error").to "error"
//        }
//
//        datosPersonalesIns{
//            on("siguiente"){
//                flow.persona.add(flow.cedula)
//                flow.persona.add(params.tipo.trim())
//                flow.persona.add(0)
//                flow.persona.add(params.nombre)
//                flow.persona.add(params.apellido)
//                flow.sql="insert into prsn (prsncdla,tpprcdgo,prsnnmbr,prsnapll) values ('${flow.cedula}','${params.tipo.trim()}','${params.nombre}','${params.apellido}')"
//            }. to "insertarPrsnInst"
//            on("abortar").to "salir"
//        }
//
//        datosPersonales{
//            on("siguiente"){
//                flow.persona.add(flow.cedula)
//                flow.persona.add(params.tipo.trim())
//                flow.persona.add(params.dependencias.trim())
//                flow.persona.add(params.nombre)
//                flow.persona.add(params.apellido)
//                flow.sql="insert into prsn (prsncdla,tpprcdgo,dpndcdgo,prsnnmbr,prsnapll) values ('${flow.cedula}','${params.tipo.trim()}','${params.dependencias.trim()}','${params.nombre}','${params.apellido}')"
//            }. to "insertarPrsn"
//            on("abortar").to "salir"
//        }
//        insertarPrsnInst{
//            action{
//                flow.cn=  Connection
//                flow.cn = ConnectionFactory.getConnection('Fire')
//                flow.connected = flow.cn.connect(flow.db.url, flow.db.driver, flow.db.user, flow.db.pass)
//                //println "sql "+flow.sql
//                flow.cn.execSql(flow.sql)
//                flow.sql="select  tpencdgo from tecg where tpprcdgo='${flow.persona[1]}'"
//                flow.cn.getDb().eachRow(flow.sql) { d ->
//                    session.tipo=d.tpencdgo
//                }
//                flow.cn.disconnect();
//                session.persona=flow.persona
//                return success()
//            }
//            on("success"). to "ponePregunta"
//        }
//        insertarPrsn{
//            action{
//                flow.cn=  Connection
//                flow.cn = ConnectionFactory.getConnection('Fire')
//                flow.connected = flow.cn.connect(flow.db.url, flow.db.driver, flow.db.user, flow.db.pass)
//                //println "sql "+flow.sql
//                flow.cn.execSql(flow.sql)
//                flow.cn.disconnect();
//                session.tipo="FE"
//                session.persona=flow.persona
//                return success()
//            }
//            on("success"). to "ponePregunta"
//        }
//        cargarDatos{
//            action{
//                flow.persona=session.persona
//                if(session.modulo!="ins")
//                    return success()
//                else
//                    return inst()
//            }
//            on("success").to "listaAdm"
//            on("inst").to "tipoEncuestaInst"
//        }
//
//        tipoEncuestaInst{
//            action{
//                cn = ConnectionFactory.getConnection('Fire')
//                //println "url "+flow.db.url
//                flow.connected = cn.connect(flow.db.url, flow.db.driver, flow.db.user, flow.db.pass)
//                flow.sql="select max_prsn from auxl"
//                def maxprsn=0
//                def numEncu=0
//                cn.getDb().eachRow(flow.sql) { d ->
//                    maxprsn=d.max_prsn
//                }
//                if(!flow.esAdmin)
//                    flow.sql="select count(*) as co from encu where prsncdla='${flow.cedula}'"
//                else
//                    flow.sql="select count(*) as co from encu where admncdla='${flow.cedula}'"
//                cn.getDb().eachRow(flow.sql) { d ->
//                    numEncu=d.co
//                }
//                //println "num encu "+maxprsn+"   "+numEncu
//                if(maxprsn >= numEncu) {
//                    if(!flow.esAdmin){
//                        flow.sql="select tpencdgo from tecg where tpprcdgo='${flow.persona[1]}'";
//
//                    }else{
//                        flow.sql="select tecg.tpencdgo from tecg,crgo,admn where tecg.tpprcdgo=crgo.tpprcdgo and admn.crgocdgo=crgo.crgocdgo and admncdla='${flow.cedula}' ";
//                    }
//                    //println "sql tipo 2"+flow.sql
//                    cn.getDb().eachRow(flow.sql) { d ->
//                        session.tipo=d.tpencdgo.trim()
//                    }
//                } else {
//                    session.tipo="X"
//                    flow.mensaje="Usted ya ha realizado el numero maximo de encuestas"
//                    return error()
//                }
//                cn.disconnect();
//                //println "TIPO "+session.tipo
//                return success()
//            }
//            on("success").to "ponePregunta"
//            on("error").to "error"
//        }
//
//        listaAdm{
//            action{
//                flow.admn=[]
//                cn = ConnectionFactory.getConnection('Fire')
//                flow.connected = cn.connect(flow.db.url, flow.db.driver, flow.db.user, flow.db.pass)
//                /*---------------------------------------------------------------------------------------*/
//                if(!flow.esAdmin)
//                    flow.condicion=" encu.prsncdla='${flow.cedula}' "
//                else
//                    flow.condicion=" encu.admncdla='${flow.cedula}' "
//
//                flow.sql="""select tpencdgo,count(*)  as maxpreg from prte where tpencdgo in (
//                select tpencdgo
//                from encu
//                where """+flow.condicion+"""
//                and encu.tpencdgo!='FE') GROUP by TPENCDGO order by tpencdgo"""
//                //println "cont tipo"+flow.sql
//                def maxPreguntas=[:]
//                def incompletos=[]
//                def iniciados=[]
//                def resto=[]
//                cn.getDb().eachRow(flow.sql) { d ->
//                    maxPreguntas.put(d.tpencdgo.trim(),d.maxpreg)
//                }
//                flow.sql="""select encu.admnbnfi,ADMNNMBR,ADMNAPLL,crgo.CRGODSCR,crgo.crgocdgo,dtec.TPENCDGO,count(*)  as preg from dtec,encu,admn,crgo
//                            where encu.admnbnfi=admn.admncdla and admn.crgocdgo=crgo.crgocdgo and
//                            dtec.tpencdgo in (
//                            select tpencdgo
//                            from encu
//                            where """+flow.condicion+"""
//                            and encu.tpencdgo != 'FE') and encu.encucdgo=dtec.ENCUCDGO and """+flow.condicion+"""
//                             GROUP by encu.admnbnfi,DTEC.TPENCDGO,ADMNNMBR,ADMNAPLL,crgo.CRGODSCR,crgo.crgocdgo order by dtec.tpencdgo"""
//                //println " maxpreg "+maxPreguntas
//                //println "imcompletos"+flow.sql
//                cn.getDb().eachRow(flow.sql) { d ->
//                    //println "max  "+maxPreguntas[d.tpencdgo.trim()]+" "+d.tpencdgo.trim()+ "   "+d.preg
//                    if(maxPreguntas[d.tpencdgo.trim()]>d.preg)
//                        incompletos.add([d.admnbnfi,d.crgocdgo,d.admnnmbr,d.admnapll,d.crgodscr,1])
//                }
//                flow.sql="""select encu.admnbnfi,ADMNNMBR,ADMNAPLL,crgo.CRGODSCR,crgo.crgocdgo,tpencdgo from encu ,admn,crgo where encu.admnbnfi=admn.admncdla and admn.crgocdgo=crgo.crgocdgo and
//                            """+flow.condicion+""" and tpencdgo !='FE' and encucdgo not in (
//                            select dtec.encucdgo from dtec,encu where encu.encucdgo=dtec.ENCUCDGO and """+flow.condicion+")"
//                // println "iniciados"+flow.sql
//                cn.getDb().eachRow(flow.sql) { d ->
//                    iniciados.add([d.admnbnfi,d.crgocdgo,d.admnnmbr,d.admnapll,d.crgodscr,1])
//                }
//                def num=0
//
//                flow.sql="""select count(*)  as co from encu where """+flow.condicion+""" and tpencdgo !='FE'"""
//                cn.getDb().eachRow(flow.sql) { d ->
//                    num=d.co
//                }
//                // println "num "+flow.sql+ "  "+num
//                incompletos=incompletos+iniciados
//                if(num>0){
//                    if(!flow.esAdmin){
//                        flow.sql="""select admn.admncdla,ADMNNMBR,ADMNAPLL,crgo.CRGODSCR,crgo.crgocdgo
//                            from ADMN,CRGO
//                            where admn.CRGOCDGO=crgo.CRGOCDGO and admncdla not in (
//                            select admnbnfi from encu where prsncdla='${flow.cedula}' and tpencdgo is not null and admnbnfi is not null) and crgo.dpndcdgo='${flow.persona[2]}'"""
//                    }else{
//                        flow.sql="""select admn.admncdla,admn.ADMNNMBR,admn.ADMNAPLL,crgo.CRGODSCR,crgo.crgocdgo
//                                    from admn,bnfi,crgo
//                                    where admn.admncdla=bnfi.admnbnfi and admn.CRGOCDGO=crgo.CRGOCDGO and bnfi.admncdla='${flow.cedula}'
//                                    and admn.admncdla not in (
//                                    select admnbnfi from encu where admncdla='${flow.cedula}' and tpencdgo !='FE' and admnbnfi is not null)"""
//                        //println "resto tipo1 "+flow.sql
//                    }
//                }else{
//                    if(!flow.esAdmin){
//                        flow.sql="""select admn.admncdla,ADMNNMBR,ADMNAPLL,crgo.CRGODSCR,crgo.crgocdgo
//                            from ADMN,CRGO
//                            where admn.CRGOCDGO=crgo.CRGOCDGO  and admn.dpndcdgo='${flow.persona[2]}'"""
//                    }else{
//                        flow.sql="""select admn.admncdla,admn.ADMNNMBR,admn.ADMNAPLL,crgo.CRGODSCR,crgo.crgocdgo
//                                    from admn,bnfi,crgo
//                                    where admn.admncdla=bnfi.admnbnfi and admn.CRGOCDGO=crgo.CRGOCDGO and bnfi.admncdla='${flow.cedula}'"""
//                        //println "resto tipo2 "+flow.sql
//                    }
//                }
//                //println "sql lista "+flow.sql
//                cn.getDb().eachRow(flow.sql) { d ->
//                    resto.add([d.admncdla,d.crgocdgo,d.admnnmbr,d.admnapll,d.crgodscr,((incompletos.size()>0)?0:1)])
//                }
//                //println " incompletos "+incompletos
//                //println " iniciados "+iniciados
//                //println " resto "+resto
//
//                flow.admn=incompletos+resto
//                /*--------------------------------------------------------------------------------------------------*/
//                cn.disconnect();
//
//                return success()
//            }
//            on("success").to "personal"
//        }
//
//        personal{
//            on("siguiente"){
//                flow.adm=params.personal.split(":")
//                session.adm=flow.adm
//                //println " adm escojido"+flow.adm
//            }.to "tipoEncuesta"
//            on("abortar").to "salir"
//        }
//
//
//        tipoEncuesta{
//            action{
//                flow.admn=[]
//                cn = ConnectionFactory.getConnection('Fire')
//                def band=true
//                flow.connected = cn.connect(flow.db.url, flow.db.driver, flow.db.user, flow.db.pass)
//                flow.sql="select count(*) as maxpreg from prte where tpencdgo = 'FE'"
//                cn.getDb().eachRow(flow.sql) { d ->
//                    flow.max=d.maxpreg
//                }
//                flow.sql="select dtec.encucdgo,dtec.tpencdgo,count(*) as num from encu,dtec where encu.encucdgo=dtec.encucdgo and "+flow.condicion+" group by encucdgo,tpencdgo";
//                //println " sql tipo "+flow.sql
//                cn.getDb().eachRow(flow.sql) { d ->
//                    //println " d "+d
//                    if(d.tpencdgo.trim()=="FE" && d.num==flow.max)
//                        band=false
//                    //println " band "+band
//                }
//                if(!band){
//                    flow.sql="select max_prsn from auxl"
//                    def maxprsn=0
//                    def numEncu=0
//                    cn.getDb().eachRow(flow.sql) { d ->
//                        maxprsn=d.max_prsn
//                    }
//                    flow.sql="select count(*) as co from encu where "+flow.condicion+" and tpencdgo is not null"
//                    cn.getDb().eachRow(flow.sql) { d ->
//                        numEncu=d.co
//                    }
//                    //println "sql 1 "+flow.sql+" numencu "+numEncu
//                    if(maxprsn>=numEncu){
//                        flow.sql="select tpencdgo from tecg where crgocdgo='${flow.adm[1]}'";
//                        //println "sql tipo 2"+flow.sq
//                        cn.getDb().eachRow(flow.sql) { d ->
//                            session.tipo=d.tpencdgo
//                        }
//                    }
//                    else
//                        session.tipo="X"
//                }
//                else{
//                    session.tipo="FE"
//                }
//                cn.disconnect();
//                //println "TIPO "+session.tipo
//                return success()
//            }
//            on("success").to "ponePregunta"
//        }
//
//        error{
//            on("siguiente").to "salir"
//            on("abortar").to "salir"
//        }
//
//        salir{
//            redirect(controller:"inicio",action:"loginAdm")
//        }
//
//        ponePregunta{
//            redirect(controller:"encuestas",action:"ponePregunta")
//        }
//
//    }


//    def registroFlow = {
//
//        inicioReg{
//            action{
//                //println "session registro " + session.cedula
//                flow.datosFacultad = armaDatosMatr("select first 100 matr.matecdgo, matedscr, profnmbr||' '||profapll prof," +
//                        "crsodscr, matr.dctaprll, matr.profcedl, matr.crsocdgo from matr, crso, mate, prof " +
//                        "where matr.estdcdgo = '${session.cedula}' and prof.profcedl = matr.profcedl and " +
//                        "mate.matecdgo = matr.matecdgo and crso.crsocdgo = matr.crsocdgo  " +
//                        "order by matedscr, crsocdgo")
//                flow.datos =  flow.datosFacultad
//                //println "datos "+flow.datos+" \n\n"
//                int hay = flow.datos.size()
//                if(!session.esPar)
//                    flow.tipo = tipoEncuesta(session.cedula, session.tipoPersona)
//                else
//                    flow.tipo = session.tipo
////                println "tipo inicio " + flow.tipo
//                //println "datos "+flow.datos
//                if(hay == 0) {
//                    //println "-------------------- No hay materias"
//                    flow.titl = "Registre las materias en las cuales se halla Matriculado"
//                    lstaFacultades()
//                    flow.lstacmbo = lstacmbo
//                } else {
//                    flow.titl = "Materias en las cuales se halla matriculado"
//                    flow.lista = datos
//                    //println " LISTA         -------------- \n"+flow.datos
//                    if(flow.tipo == "DC")
//                        flow.datos = materiasFinal(flow.datos)
//                }
//
//                return success()
//            }
//            on("success"){
//                // println "succes "
//            }.to "matriculado"
//
//        }
//
//        matriculado{
//            on("registrar"){
//                flow.titl = "Registre las materias en las cuales se halla Matriculado"
//                lstaFacultades()
//                flow.lstacmbo = lstacmbo
//            }.to "facultad"
//            on("ponePregunta"){
//                /* --Estudiantes: Ejecuta una vez TPEN = "FE" y hasta una máxmio de
//                *     auxl.max_prof "DC"
//                * --Profesores: ejecuta una sola vez la autoevaluación "AD"
//                */
//                def lstamatr=[]
//                /* todo ocultar los botones con la variable flow.tipo */
//                if(flow.tipo=="FE")
//                    lstamatr = lstaMaterias(session.cedula)
//                else
//                {
//                    //println "entro a tipo Dc "
//                    //println "params ----------------------------- \n"+params
//                    if(params.cdgo){
//                        def p = params.cdgo.split(":")
//                        lstamatr.add(p)
//                        //println " pppp "+p
//                    }
//                }
//                session.tipo=flow.tipo
//                if(flow.tipo != "X"){
//                    session.materias = lstamatr
//                } else redirect(action:"fin")
//            }.to "ponePregunta"
//            on("eliminar"){
//                // borra el registro de matr.
//            }.to "inicioReg"
//
//        }
//
//        facultad{
//            on("siguiente"){
//                flow.facl = params.facl.split(":")[0]
//                lstaEscl(flow.facl)
//                flow.facultad = params.facl.split(":")[1].trim()
//                flow.titl = "Registre las materias en las cuales se halla Matriculado"
//                flow.flujo = "Facultad: ${flow.facultad}"
//                flow.lstacmbo = lstacmbo
//            }.to "escuela"
//        }
//
//        escuela{
//            on("siguiente"){
//                flow.escl = params.facl.split(":")[0].trim()
//                flow.escuela = params.facl.split(":")[1].trim()
//                lstaCrso(flow.facl, flow.escl)
//                flow.titl = "Registre las materias en las cuales se halla Matriculado"
//                flow.flujo = "Facultad: ${flow.facultad}  Escuela: ${flow.escuela}"
//                flow.lstacmbo = lstacmbo
//                //println  "curosos "+flow.lstacmbo
//            }.to "cursos"
//            on("anterior"){
//                lstaFacultades()
//                flow.lstacmbo = lstacmbo
//            }.to "facultad"
//        }
//
//        cursos{
//            on("siguiente"){
//                flow.crso = params.curso
//                flow.cursos = ""
//                def i = 0
//                if(flow.crso?.class == java.lang.String) {
//                    // muy importante cuando solo se selecciona un checkbox
//                    flow.cursos = "'${flow.crso}'"
//                } else {
//                    flow.crso?.each(){
//                        if(i==0){
//                            flow.cursos = "'${it.trim()}'"
//                        } else {
//                            flow.cursos += ",'${it.trim()}'"
//                        }
//                        i++
//                    }
//                }
//                params.flujo = "Facultad: ${flow.facultad}  Escuela: ${flow.escuela} + Cursos: ${flow.crso}}"
//                //println "facultad: ${flow.fc}---${flow.cr}--------Escl:${flow.es} Curso:${flow.cr?.class}  --> ${flow.cursos}"
//                datos = armaDatosMatr("select dcta.matecdgo, matedscr,"+
//                        "profnmbr||' '||profapll prof, crsodscr, dctaprll, dcta.profcedl," +
//                        "dcta.crsocdgo from crso, dcta, mate, prof " +
//                        "where prof.profcedl = dcta.profcedl and mate.matecdgo = dcta.matecdgo and " +
//                        "crso.crsocdgo = dcta.crsocdgo and " +
//                        "mate.faclcdgo = '${flow.facl}' and mate.esclcdgo = '${flow.escl}' and " +
//                        "crso.crsocdgo in (${flow.cursos}) and dcta.matecdgo not in " +
//                        "(select matecdgo from matr where estdcdgo = '${session.cedula}' and " +
//                        "matr.crsocdgo = dcta.crsocdgo ) " +
//                        "order by dcta.crsocdgo, matedscr, dcta.dctaprll")
//
//                flow.lista = datos
//            }.to "materias"
//
//            on("anterior"){
//                //println "facultad en el flujo: ${flow.facl}"
//                lstaEscl(flow.facl)
//                flow.flujo = "Facultad: ${flow.facultad}"
//                flow.lstacmbo = lstacmbo
//            }.to "escuela"
//
//        }
//
//        materias{
//            on("siguiente") {
//                //println "aqui"
//                // inserta las materias en las que se halla matriculado
//                def rg = []
//                def tx = params.cdgo
//                if(tx?.class == java.lang.String) rg.add(tx); else rg = tx;
//                tx = ""
//                def i = 0
//                rg?.each(){ d ->
//                    d.split(':').each(){j ->
//                        if(i == 0){
//                            tx = "'${j}'"
//                        } else {
//                            tx += ",'${j}'"
//                        }
//                        i++
//                    }
//                    i = 0
//                    def sql = "insert into matr(estdcdgo, profcedl, matecdgo, crsocdgo, dctaprll) " +
//                            "values ('${session.cedula}', ${tx})"
//                    //println "++++++++SQL: ${sql}"
//                    ejecutaSQL(sql)
//                }
//            }.to "guardar"
//            on("anterior") {
//                lstaCrso(flow.facl, flow.escl)
//                //flow.titl = "Registre las materias en las cuales se halla Matriculado"
//                //flujo += " Escuela: ${params.facl.split(":")[1].trim()}"
//                flow.flujo = "Facultad: ${flow.facultad}  Escuela: ${flow.escuela}"
//                flow.lstacmbo = lstacmbo
//
//            }.to "cursos"
//            on("cancelar") {
//                //cancela el ingreso de nuevas materias.
//            }.to "inicioReg"
//        }
//
//        guardar{
//            action{
//                //inserts
//                return success()
//            }
//            on("success"). to "inicioReg"
//        }
//        ponePregunta{
//            action{
//
//            }
//            redirect(controller:"encuestas",action:"ponePregunta")
//        }
//
//    }

    List materiasFinal(datos){
        def m=[]
        cn = ConnectionFactory.getConnection('Fire')
        cn.connect(db.url, db.driver, db.user, db.pass)
        def sql
        def temp=[]
        def ex=[]
        def max
        def band=true
        def incompletas=1
        sql="select count(*) as maxpreg from prte where tpencdgo = 'DC'"
        cn.getDb().eachRow(sql) { d ->
            max = d.maxpreg
        }
        def res=[]
        sql="select matr.matecdgo, matedscr, profnmbr||' - '||profapll prof," +
                "crso.crsocdgo, matr.dctaprll, prof.profcedl from matr, crso, mate, prof, encu " +
                "where encu.ESTDCDGO = '${session.cedula}' and prof.profcedl = matr.profcedl and " +
                "mate.matecdgo = matr.matecdgo and crso.crsocdgo = matr.crsocdgo  and matr.matecdgo=encu.matecdgo and encu.encuetdo='C' "+
                "order by matedscr, crsodscr"
       // println "SQL M size  _____________ \n "+sql
        cn.getDb().eachRow(sql) { d ->
            def cdgo = "${d.profcedl.toString().trim()}:" +
                    "${d.matecdgo.toString().trim()}:" +
                    "${d.crsocdgo.toString().trim()}:" +
                    "${d.dctaprll.toString().trim()}"
           for(int i =datos.size()-1;i>-1;i--){
               if(datos[i][0]?.trim()==cdgo.trim()){
                   datos.remove(i)
               }
           }
           // m.add( [cdgo,d.matedscr,d.prof,d.crsodscr,d.dctaprll,incompletas])

        }

        cn.disconnect();
       // println "datos final  "+datos
        return datos

    }


    String estudiante(cdla) {
        db.setDB("prof")
        cn = ConnectionFactory.getConnection('Fire')
        cn.connect(db.url, db.driver, db.user, db.pass)
        def txHtml = ""
        def tx = "select * from estd where estdcdgo like '" + cdla + "%'"
        // println "SQL: ${tx}"
        txHtml = """
          <html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
          <title>Encuestas</title>
          </head><body>
        """
        cn.getDb().eachRow(tx) { d ->
            txHtml += "<li>seleccionado: ${d.estdcdgo} </li>"
        }
        cn.disconnect()
        txHtml += """
  </body>
        """
        return txHtml
    }

    String creaEstudiante(cdla) {
        db.setDB("prof")
        cn = ConnectionFactory.getConnection('Fire')
        cn.connect(db.url, db.driver, db.user, db.pass)
        def tx = "insert into estd(estdcdgo) values ('${cdla}')"
        def rg = 0;
        //println "inserta estudiante" + tx
        try {
            cn.getDb().execute(tx)
            rg = 1
        }
        catch(Exception ex){
            println ex.getMessage()
        }
        cn.disconnect()
        return rg
    }

    boolean existeEstudiante(cdla) {
        def cn = dbConnectionService.getConnection()
        def rt = false
        def tx = "select count(*) cnta from estd where estdcdla = '${cdla}'"
        try {
            cn.eachRow(tx) { d ->
                println "retorna cnta: ${d.cnta}"
                if(d.cnta > 0) rt = true
            }
        }
        catch(Exception ex){
            println ex.getMessage()
        }
        cn.close()
        return rt
    }

    ArrayList leeDatos(String txSQL) {
        def dd = []
        def i = 0
        db.setDB("prof")
        cn = ConnectionFactory.getConnection('Fire')
        cn.connect(db.url, db.driver, db.user, db.pass)
        // println "------------- llega sql: ${txSQL}"
        cn.getDb().eachRow(txSQL) { d ->
            dd[i] = [d.matecdgo] + [d.matedscr] + [d.prof] + [d.crsodscr] + [d.dctaprll]
            i++
        }
        //println dd
        cn.disconnect()
        return dd
    }

    ArrayList armaDatosMatr(String txSQL) {
        def cdgo = ""
        def dd = []
        def i = 0
        //println "armaDatosMatr: .." + txSQL
        db.setDB("prof")
        cn = ConnectionFactory.getConnection('Fire')
        cn.connect(db.url, db.driver, db.user, db.pass)
        // println "------------- llega sql: ${txSQL}"
        try {
            cn.getDb().eachRow(txSQL) { d ->
                cdgo = "${d.profcedl.toString().trim()}:" +
                        "${d.matecdgo.toString().trim()}:" +
                        "${d.crsocdgo.toString().trim()}:" +
                        "${d.dctaprll.toString().trim()}"
                dd[i] = [cdgo] + [d.matedscr] + [d.prof] + [d.crsodscr] + [d.dctaprll]
                i++
            }
        }
        catch(Exception ex){
            println ex.getMessage()
        }
        //println dd
        cn.disconnect()
        return dd
    }

    void lstaFacultades() {
        lstacmbo = []
        db.setDB("prof")
        cn = ConnectionFactory.getConnection('Fire')
        cn.connect(db.url, db.driver, db.user, db.pass)
        def tx = "select facldscr, faclcdgo from facl order by facldscr "
        cn.getDb().eachRow(tx) { d ->
            lstacmbo.add("${d.faclcdgo}:${d.facldscr}")
        }
        //println dd
        cn.disconnect()
    }

    void lstaEscl(String facl) {
        lstacmbo = []
        db.setDB("prof")
        cn = ConnectionFactory.getConnection('Fire')
        cn.connect(db.url, db.driver, db.user, db.pass)
        def tx = "select escldscr, esclcdgo from escl where faclcdgo = '${facl}' order by escldscr "
        cn.getDb().eachRow(tx) { d ->
            lstacmbo.add("${d.esclcdgo}:${d.escldscr}")
        }
        //println dd
        cn.disconnect()
    }

    void lstaCrso(String facl,escl) {
        lstacmbo = []
        def i = 0
        db.setDB("prof")
        cn = ConnectionFactory.getConnection('Fire')
        cn.connect(db.url, db.driver, db.user, db.pass)
        //def tx = "select distinct crsodscr, crsocdgo from crso " +
        //  "where faclcdgo = '${facl}' and esclcdgo = '${escl}' order by crsodscr"
        //println "lstaCrso SQL:${tx}"
        def tx = """select distinct c.crsodscr, c.crsocdgo from crso c, dcta d, mate m
          where c.crsocdgo = d.crsocdgo and d.matecdgo = m.matecdgo and m.esclcdgo=${escl}
          order by c.crsocdgo """

        cn.getDb().eachRow(tx) { d ->
            lstacmbo[i] = [d.crsocdgo] + [d.crsodscr]
            i++
        }
        //println dd
        cn.disconnect()
    }


    void lstaEscuelas(String facl) {
        db.setDB("prof")
        cn = ConnectionFactory.getConnection('Fire')
        cn.connect(db.url, db.driver, db.user, db.pass)
        def tx = "select escldscr, esclcdgo from escl where faclcdgo = '${facl}' order by escldscr "
        cn.getDb().eachRow(tx) { d ->
            lstaescl += "<option value=" + d.esclcdgo + ">" + d.escldscr + "</option>"
        }                              integer

        lstaescl += "</select>"
        //println dd
        cn.disconnect()
    }

    void ejecutaSQL(tx) {
        db.setDB("prof")
        cn = ConnectionFactory.getConnection('Fire')
        cn.connect(db.url, db.driver, db.user, db.pass)
        //println tx
        try {
            cn.getDb().execute(tx)
        }
        catch(Exception ex){
            println ex.getMessage()
        }
        cn.disconnect()
    }

    ArrayList lstaMaterias(cdla) {
        db.setDB("prof")
        ArrayList rg = []
        cn = ConnectionFactory.getConnection('Fire')
        cn.connect(db.url, db.driver, db.user, db.pass)
        def tx = "select profcedl, matr.matecdgo, crsocdgo, dctaprll,matedscr from matr,mate " +
                "where estdcdgo = '${cdla}' and mate.matecdgo=matr.matecdgo"
        //println " a ejecutar: lstaMaterias:!!!  ${tx}"
        cn.getDb().eachRow(tx) { d ->
            rg.add([d.profcedl.toString().trim()] + [d.matecdgo.toString().trim()] +
                    [d.crsocdgo.toString().trim()] + [d.dctaprll.toString().trim()]+[d.matedscr])
        }

        //println " lista nat "+rg
        cn.disconnect()
        return rg
    }

    String tipoEncuesta(cdla,tipo) {
        def cnta = 0
        def tpe
        def tx
        switch (tipo){
            case "E":
                tpe="FE"
                tx = "select count(*) as cnta from encu where estdcdgo = '${cdla}' and tpencdgo = '${tpe}'"
                break;
            case "P":
                tpe="AD"
                tx = "select count(*) as cnta from encu where profcedl = '${cdla}' and tpencdgo = '${tpe}'"
                break;
        }
        def tp = ""
        db.setDB(session.modulo)
        //println "db "+db.url
        cn = ConnectionFactory.getConnection('Fire')
        cn.connect(db.url, db.driver, db.user, db.pass)


        //println "  tx "+tx
        def max
        cn.getDb().eachRow(tx) { d ->
            cnta = d.cnta
        }
        tx="select count(*) as maxpreg from prte where tpencdgo = '${tpe}'"
        cn.getDb().eachRow(tx) { d ->
            max=d.maxpreg
        }
        //println "Aqui=>  "+tpe+" cnta "+cnta+" max "+max  //  0602973109
        if (tipo=="E" && cnta>0){
            tx="select count(*) as co from dtec,encu where encu.encucdgo=dtec.encucdgo and encu.estdcdgo='${cdla}' and encu.tpencdgo='${tpe}'"
            def num

            cn.getDb().eachRow(tx) { d ->
                num=d.co
            }

            if(num==max){
                tx = "select max_prof from auxl"
                cn.getDb().eachRow(tx) { d ->
                    if(cnta < d.max_prof) tp = "DC"; else tp = "X";
                }
            }
            else{
                tp="FE"
            }

        }
        else
        {
            if(tipo=="E")
                tp="FE"
            else
            if(cnta !=max)
                tp="AD"
            else
                tp="X"
        }

        cn.disconnect()
        //println " funcion    "+tp
        return tp
    }

    boolean existeProfesor(cdla) {
        db.setDB(session.modulo)
        //println " url prof "+db.url
        cn = ConnectionFactory.getConnection('Fire')
        cn.connect(db.url, db.driver, db.user, db.pass)
        def rt = false
        def tx = "select count(*) cnta from prof where profcedl = '${cdla}'"
        try {
            cn.getDb().eachRow(tx) { d ->
                // println "retorna cnta: ${d.cnta}"
                if(d.cnta > 0) rt = true
            }
        }
        catch(Exception ex){
            println ex.getMessage()
        }
        cn.disconnect()
        return rt
    }

    List cargarDependencias(){
        //println "modulo "+session.modulo
        db.setDB(session.modulo)
       // println " url cargar "+db.url
        cn = ConnectionFactory.getConnection('Fire')
        cn.connect(db.url, db.driver, db.user, db.pass)
        def sql="select dpndcdgo, dpnddscr from dpnd where dpndextr = 'S'"
        //println "sql "+sql
        def lista=[]
        cn.getDb().eachRow(sql) { d ->
            lista.add([d.dpndcdgo.trim(),d.dpnddscr.trim()])
        }
        //println "lista "+lista
        cn.disconnect()
        return lista
    }

    boolean existePersona(cdla){
        db.setDB(session.modulo)
        //println " url cargar "+db.url
        cn = ConnectionFactory.getConnection('Fire')
        cn.connect(db.url, db.driver, db.user, db.pass)
        def sql="select prsncdla, tpprcdgo, dpndcdgo, prsnnmbr, prsnapll from prsn where prsncdla = '${cdla}'"
        def cdgo=0
        def temp=[]
        cn.getDb().eachRow(sql) { d ->
            cdgo=d.prsncdla
            temp.add(d.prsncdla.trim())
            temp.add(d.tpprcdgo.trim())
            temp.add(d.dpndcdgo?.trim())
            temp.add(d.prsnnmbr?.trim())
            temp.add(d.prsnapll?.trim())
        }
        cn.disconnect()
        if(cdgo!=0){
            session.persona=temp
            return true
        }
        else
            return false
    }

    boolean existeAdministrativo(cdla){
        db.setDB(session.modulo)
        cn = ConnectionFactory.getConnection('Fire')
        cn.connect(db.url, db.driver, db.user, db.pass)
        def sql
        if(session.modulo!="ins")
            sql="select admncdla, tpadcdgo, dpndcdgo, admnnmbr, admnapll, crgocdgo from admn where admncdla = '${cdla}'"
        else
            sql="select admncdla, tpadcdgo, admn.dpndcdgo, admnnmbr, admnapll, admn.crgocdgo, tpprcdgo from admn, crgo where admn.crgocdgo = crgo.crgocdgo and admncdla = '${cdla}'"
        def cdgo=0
        def temp=[]
        cn.getDb().eachRow(sql) { d ->
            cdgo=d.admncdla
            temp.add(d.admncdla.trim())
            temp.add(d.tpadcdgo.trim())
            temp.add(d.dpndcdgo?.trim())
            temp.add(d.admnnmbr?.trim())
            temp.add(d.admnapll?.trim())
            temp.add(d.crgocdgo)
            if(session.modulo=="ins")
                temp.add(d.tpprcdgo?.trim())
        }
        cn.disconnect()
        if(cdgo!=0){
            session.persona=temp
            return true
        }
        else
            return false
    }


    boolean autoEvaluacion(cdla){
        db.setDB(session.modulo)
        cn = ConnectionFactory.getConnection('Fire')
        cn.connect(db.url, db.driver, db.user, db.pass)
        def sql="select count(*) as co from encu where admncdla = '${cdla}' and admnbnfi='${cdla}'"
        //println "sql "+sql
        def contador = 0
        cn.getDb().eachRow(sql) { d ->
            //println "d.co " + d.co*1 + " "
            contador = d.co
        }
        cn.disconnect();
        if(contador.toInteger() > 0)
            return false
        else
            return true
    }

    def IE={
        render("asdasdasd IE")
    }

    /*TODO ver si esto se puede hacer mas rapido*/
    def verificaEncuesta(cedula,esc){
        db.setDB(session.modulo)
        cn = ConnectionFactory.getConnection('Fire')
        cn.connect(db.url, db.driver, db.user, db.pass)
        def cn2 = ConnectionFactory.getConnection('Fire')
        cn2.connect(db.url, db.driver, db.user, db.pass)
        def op = []

        def sql = "select prof.profcedl, prof.profnmbr, prof.profapll, mate.matedscr, crso.crsodscr, prof.esclcdgo, mate.matecdgo, crso.crsocdgo "
        sql += "from prof, dcta, mate, crso "
        sql += "where prof.profcedl = dcta.profcedl and dcta.matecdgo = mate.matecdgo and "
//        sql += "dcta.crsocdgo = crso.crsocdgo and prof.profcedl != '${cedula}' and prof.profcedl not in ("
        sql += "dcta.crsocdgo = crso.crsocdgo and prof.profcedl not in ("
        sql += "select profcedl from encu where prof_par = '${cedula}' and encuetdo = 'C' and "
        sql += "encu.matecdgo = dcta.matecdgo and encu.crsocdgo = dcta.crsocdgo and tpencdgo = 'PR') "
        sql += "group by 1,2,3,4,5,6,7,8 order by 3;"

/*
        def sql = "select p.profcedl, p.profnmbr, p.profapll, m.matedscr, c.crsodscr, p.esclcdgo, m.matecdgo, c.crsocdgo "
        sql += "from prof p, dcta d, mate m, crso c "
        sql += "where p.profcedl = d.profcedl and "
        sql += "d.matecdgo = m.matecdgo and "
        sql += "d.crsocdgo = c.crsocdgo and "
        sql += "p.profcedl != '${cedula}' "
        // sql+=" and p.profcedl not in (select profcedl from encu where prof_par = '${cedula}' and encuetdo ='C')"
        sql += "group by 1,2,3,4,5,6,7,8 order by 3;"
        println "sqlPar: " + sql
*/
        def  cont = 0
        cn.getDb().eachRow(sql.toString()) { d ->
/*
            def sq = "select matecdgo, crsocdgo from encu where profcedl = '${d['profcedl']}' and prof_par='${cedula}' and matecdgo is not null and crsocdgo is not null and encuetdo ='C'"
            //println "interno: " + sq
            def band = false
            cn2.getDb().eachRow(sq.toString()){c->
                //println "entro 2 each "+d['profcedl']+"   "+c+"   -->  "+d["matecdgo"]+"!  "+d["crsocdgo"]+"!"
                band = true
                if(!((d["matecdgo"] == c["matecdgo"]) && (d["crsocdgo"] == c["crsocdgo"]))){
                    println "si add"
                    op.add(d.toRowResult())
                } else {

                }
            }
            if(!band)
*/
            op.add(d.toRowResult())
        }
        // println "op!!!!! ---> "+op.size()
        cn.disconnect()
        cn2.disconnect()
        return op

    }

    def verificaEncuestaDir(cedula){
        db.setDB(session.modulo)
        cn = ConnectionFactory.getConnection('Fire')
        cn.connect(db.url, db.driver, db.user, db.pass)
        def cn2 = ConnectionFactory.getConnection('Fire')
        cn2.connect(db.url, db.driver, db.user, db.pass)
        def op = []

        def sql = "select profnmbr, profapll, prof.profcedl, dcta.matecdgo, matedscr, dcta.crsocdgo, crsodscr " +
                "from prof, dcta, mate, crso " +
                "where dcta.profcedl = prof.profcedl and mate.matecdgo = dcta.matecdgo and " +
                "prof.esclcdgo = (select esclcdgo from prof where profcedl = '${cedula}') and " +
                "prof.profcedl not in (select profcedl from encu where profdrtv = '${cedula}' and encuetdo = 'C') and " +
                "crso.crsocdgo = dcta.crsocdgo " +
                "group by profnmbr, profapll, prof.profcedl, dcta.matecdgo, matedscr, dcta.crsocdgo, crsodscr " +
                "order by profapll"

/*
        def sql = "select prof.profcedl, prof.profnmbr, prof.profapll, mate.matedscr, crso.crsodscr, prof.esclcdgo, mate.matecdgo, crso.crsocdgo "
        sql += "from prof, dcta, mate, crso "
        sql += "where prof.profcedl = dcta.profcedl and dcta.matecdgo = mate.matecdgo and "
        sql += "dcta.crsocdgo = crso.crsocdgo and prof.profcedl != '${cedula}' and prof.profcedl not in ("
        sql += "select profcedl from encu where profdrtv = '${cedula}' and encuetdo = 'C' and "
        sql += "encu.matecdgo = dcta.matecdgo and encu.crsocdgo = dcta.crsocdgo and tpencdgo = 'DI') "
        sql += "group by 1,2,3,4,5,6,7,8 order by 3;"
*/

/*
        def sql="select  p.profcedl, p.profnmbr, p.profapll, m.matedscr , c.crsodscr , p.esclcdgo, m.matecdgo, c.crsocdgo "
        sql += "from prof p, dcta d, mate m, crso c "
        sql += "where p.profcedl = d.profcedl and "
        sql += "d.matecdgo = m.matecdgo and "
        sql += "d.crsocdgo = c.crsocdgo and "
        sql += "p.profcedl != '${cedula}'"
        // sql+=" and p.profcedl not in (select profcedl from encu where prof_par = '${cedula}' and encuetdo ='C')"
        sql+=" group by 1,2,3,4,5,6,7,8 order by 3;"
*/
        //println "sql Dir: "+sql
        def  cont = 0
        cn.getDb().eachRow(sql.toString()) { d ->
/*
            def sq = "select matecdgo, crsocdgo from encu where profcedl = '${d['profcedl']}' and PROFDRTV = '${cedula}' and matecdgo is not null and crsocdgo is not null and encuetdo != 'C'"
            def band = false
            cn2.getDb().eachRow(sq.toString()){c->
                // println "entro 2 each "+d['profcedl']+"   "+c+"   -->  "+d["matecdgo"]+"!  "+d["crsocdgo"]+"!"
                band = true
                if(!(d["matecdgo"] == c["matecdgo"] && d["crsocdgo"]==c["crsocdgo"])){
                    println "si add"
                    op.add(d.toRowResult())
                }else{

                }
            }
            if(!band)
*/
            op.add(d.toRowResult())
        }
        //println "op!!!!! ---> " + op.size()
        cn.disconnect()
        cn2.disconnect()
        return op

    }

    def verificaCedula(cedula,tipo){
        db.setDB(session.modulo)
        cn = ConnectionFactory.getConnection('Fire')
        cn.connect(db.url, db.driver, db.user, db.pass)
        def sql ="select esclcdgo from prof where profcedl = '${cedula}' and profeval = '${tipo}'"
        //println "sql login "+sql
        def res=null
        cn.getDb().eachRow(sql.toString()) { d ->
            res=d["esclcdgo"]
        }
        cn.disconnect()
        return res
    }

}