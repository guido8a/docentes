$(function() {
    $("#buscar").click(function() {
        $(".buscador").dialog('open')
    });
    $(".buscador").dialog({
        autoOpen: false,
        resizable:true,
        width:750,
        title: 'Buscador',
        modal:true,
        position: 'center'
    });

    $("#campo").change(function(){
        cambiaOperador()
    });

    function cambiaOperador(){
        if($('#campo :selected').attr("tipo")=="string"){
            $("#operador").html('<select name="operador" style="width: 130px;"><option value="%like%">Contiene</option><option value="like%">Empieza</option><option value="=">Igual</option>  </select>')
            $("#tipoCampo").val("string");
        }
        if($('#campo :selected').attr("tipo")=="number"){
            $("#operador").html('<select name="operador" style="width: 130px;"><option value="=">Igual</option><option value="<">Mayor</option><option value=">">Menor</option>  </select>')
            $("#tipoCampo").val("number");
        }
        if($('#campo :selected').attr("tipo")=="-1")
            $("#operador").html('<select name="operador" style="width: 130px;"></select>');
    }

});