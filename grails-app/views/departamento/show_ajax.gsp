
<%@ page import="seguridad.Departamento" %>

<g:if test="${!departamentoInstance}">
    <elm:notFound elem="Departamento" genero="o" />
</g:if>
<g:else>

    <g:if test="${departamentoInstance?.padre}">
        <div class="row">
            <div class="col-md-2 text-info">
                Padre
            </div>
            
            <div class="col-md-3">
                ${departamentoInstance?.padre?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${departamentoInstance?.codigo}">
        <div class="row">
            <div class="col-md-2 text-info">
                Código
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${departamentoInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${departamentoInstance?.nombre}">
        <div class="row">
            <div class="col-md-2 text-info">
                Nombre
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${departamentoInstance}" field="nombre"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${departamentoInstance?.telefono}">
        <div class="row">
            <div class="col-md-2 text-info">
                Teléfono
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${departamentoInstance}" field="telefono"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${departamentoInstance?.extension}">
        <div class="row">
            <div class="col-md-2 text-info">
                Extensión
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${departamentoInstance}" field="extension"/>
            </div>
            
        </div>
    </g:if>
    %{----}%
    %{--<g:if test="${departamentoInstance?.direccion}">--}%
        %{--<div class="row">--}%
            %{--<div class="col-md-2 text-info">--}%
                %{--Direccion--}%
            %{--</div>--}%
            %{----}%
            %{--<div class="col-md-3">--}%
                %{--<g:fieldValue bean="${departamentoInstance}" field="direccion"/>--}%
            %{--</div>--}%
            %{----}%
        %{--</div>--}%
    %{--</g:if>--}%
    
    %{--<g:if test="${departamentoInstance?.estado}">--}%
        %{--<div class="row">--}%
            %{--<div class="col-md-2 text-info">--}%
                %{--Estado--}%
            %{--</div>--}%
            %{----}%
            %{--<div class="col-md-3">--}%
                %{--<g:fieldValue bean="${departamentoInstance}" field="estado"/>--}%
            %{--</div>--}%
            %{----}%
        %{--</div>--}%
    %{--</g:if>--}%
    
    <g:if test="${departamentoInstance?.activo}">
        <div class="row">
            <div class="col-md-2 text-info">
                Activo
            </div>
            
            <div class="col-md-3">
                %{--<g:fieldValue bean="${departamentoInstance}" field="activo"/>--}%
                ${departamentoInstance?.activo == 1 ? 'ACTIVO' : 'INACTIVO'}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${departamentoInstance?.orden}">
        <div class="row">
            <div class="col-md-2 text-info">
                Orden
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${departamentoInstance}" field="orden"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>