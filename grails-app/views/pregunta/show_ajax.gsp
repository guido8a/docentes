
<%@ page import="docentes.Pregunta" %>

<g:if test="${!preguntaInstance}">
    <elm:notFound elem="Pregunta" genero="o" />
</g:if>
<g:else>

    <g:if test="${preguntaInstance?.codigo}">
        <div class="row">
            <div class="col-md-2 text-info">
                Codigo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${preguntaInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${preguntaInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 text-info">
                Descripcion
            </div>
            
            <div class="col-md-10">
                <g:fieldValue bean="${preguntaInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${preguntaInstance?.estado}">
        <div class="row">
            <div class="col-md-2 text-info">
                Estado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${preguntaInstance}" field="estado"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${preguntaInstance?.estrategia}">
        <div class="row">
            <div class="col-md-2 text-info">
                Estrategia
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${preguntaInstance}" field="estrategia"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${preguntaInstance?.numeroRespuestas}">
        <div class="row">
            <div class="col-md-2 text-info">
                Numero Respuestas
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${preguntaInstance}" field="numeroRespuestas"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${preguntaInstance?.tipoRespuesta}">
        <div class="row">
            <div class="col-md-2 text-info">
                Tipo Respuesta
            </div>
            
            <div class="col-md-10">
                ${preguntaInstance?.tipoRespuesta?.descripcion}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${preguntaInstance?.variables}">
        <div class="row">
            <div class="col-md-2 text-info">
                Variables
            </div>
            
            <div class="col-md-10">
                ${preguntaInstance?.variables?.descripcion}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${preguntaInstance?.estrategia}">
        <div class="row">
            <div class="col-md-2 text-info">
                Estrategia
            </div>

            <div class="col-md-10">
                ${preguntaInstance?.estrategia}
            </div>

        </div>
    </g:if>

</g:else>