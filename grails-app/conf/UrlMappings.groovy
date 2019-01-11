class UrlMappings {

	static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }


//        "/"(controller: "inicio", action: "index")
        "/"(controller: "encuesta", action: "inicio")
        "500"(view:'/error')
	}
}
