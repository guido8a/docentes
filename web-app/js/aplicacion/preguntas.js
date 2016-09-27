$(function() {
    $(".bs").buttonset();
    var item;
    var child;
    $(".item").click(function() {
        if($("#max").val()>$("#num").val()){
            item=$(this)
            $(".dialog").dialog('open')
        }
    });
    $(".selected").livequery(function() {
        $(".selected").click(function() {
            $("#"+$(this).attr("item")).click(function() {
                if($("#max").val()>$("#num").val()){
                          item=$(this)
                          $(".dialog").dialog('open')
                }
              });
            $(this).remove();
            var selected=$(".selected")
            $("#num").val(selected.size())
        });
    });

    function enviar() {
        $.ajax({
            type: "POST",
            url: "listaProcesos",
            data: "adm="+$("#admin").val(),
            success: function(msg){
                $("#admCont").html(msg).show("slide");
            }

        });
    }

    $("#admin").change(function(){
        enviar();
    });


    $("#emp").click(function(){
       child = window.open('abrir','QUANTO','left=0,top=0,width=850,height=600,toolbar=0,resizable=0,menubar=0,scrollbars=1,status=0');
       if (child.opener == null) child.opener = self;
        window.toolbar.visible = false;
        window.menubar.visible = false;
    });

    $("#fin").click(function(){
        window.opener.location.href="../inicio"
        self.close ()
    });

   

    $(".dialog").dialog({
        autoOpen: false,
        resizable:false,
        title: 'Seleccione una opción',
        modal:true,
        position: 'center',
        open: function(event, ui) {
            $(".ui-dialog-titlebar-close").hide();
        },
        buttons: {
            "Ok": function() {
                $("#resp").val(jQuery('.radio:checked').val());
                $("#num").val(($("#num").val())*1+1)
                var resp="<input type='hidden' id='resp_"+item.attr("id")+"' name='respuestasSelec' value='"+$("#resp").val()+"'>"
                var h="<input type='hidden' id='item_"+item.attr("id")+"' name='seleccionados' value='"+item.attr("id")+"'>"
                $("#select").append("<div id='cont_"+item.attr("id")+"' class='selected' item='"+item.attr("id")+"' style='margin-left:15px;'>"+h+resp+"<div class='fila bordeAbajo'>"+item.html()+"</div></div>")
                item.unbind('click');
                ;
                $(this).dialog("close");
            }
        }
    });
    $("#siguienteTipo3").click(function(){
        if($("#num").val()*1>0)
            $(".formEncuestas").submit();
        else{
            $(".mensaje").html("Debe seleccionar al menos un item")
            $(".mensaje").show("explode")
        }
    });
    $("#siguienteTipo2").click(function(){
        if(jQuery('.radio:checked').val()!=undefined)
            $(".formEncuestas").submit();
        else{
            $(".mensaje").html("Debe seleccionar al menos una opcion")
            $(".mensaje").show("slide")
        }
    });
    $("#siguiente").click(function(){
        if(jQuery('.radio:checked').val()!=undefined)
            $(".formEncuestas").submit();
        else{
            $(".mensaje").html("Debe seleccionar al menos una opcion")
            $(".mensaje").show("slide")
            //$(".filaEntera").height($("#cuerpo").height()-15)
        }
    });

    $("#siguienteDP").click(function(){
        if($("#nombre").val().trim().length > 2 && $("#apellido").val().trim().length > 2 )
            $(".formEncuestas").submit();
        else{
            $(".mensaje").html("Por favor ingrese su nombre y apellido")
            $(".mensaje").show("slide")
            $(".filaEntera").height($("#cuerpo").height()-15)
        }
    });
    $("#siguienteTp2").click(function(){
        if($('.radio:checked').val()!=undefined){
            if($('.radio:checked').val()!="NI"){
                if($("#materia").val()==null || $("#materia").val()==""){
                    $(".mensaje").html("Debe seleccionar una opcion")
                    $(".mensaje").show("slide")
                }else{
                    $(".formEncuestas").submit();
                }
            }else{
                $(".formEncuestas").submit();
            }
        }
        else{
            $(".mensaje").html("Debe seleccionar al menos una opcion")
            $(".mensaje").show("slide")
        }
    });

    $(".materias").dialog({
        autoOpen: false,
        resizable:true,
        title: 'Seleccione una materia',
        modal:true,
        position: 'center',
        open: function(event, ui) {
            $(".ui-dialog-titlebar-close").hide();
        },
        buttons: {
            "Ok": function() {
                $("#matVal").val($("#div_"+jQuery('.radioMat:checked').attr("id")).text())
                $("#materia").val(jQuery('.radioMat:checked').val())
//                console.log(jQuery('.radioMat:checked').val(),$("#div_"+jQuery('.radioMat:checked').attr("id")))
                $(this).dialog("close");
            }
        }
    });

    $(".admin").dialog({
        autoOpen: false,
        resizable:true,
        title: 'Lista de procesos',
        width:500,
        modal:true,
        position: 'center',
        open: function(event, ui) {
            $(".ui-dialog-titlebar-close").hide();
        },
        buttons: {
            "Ok": function() {
                $("#matVal").val($("#div_"+jQuery('.radioMat:checked').attr("id")).text())
                $("#materia").val(jQuery('.radioMat:checked').val())
                $("#admn").val($("#admin").val())
                $(this).dialog("close");
            }
        }
    });

    $("#buscar").click(function() {
        $(".radio:first").attr("checked", "checked");
        $(".materias").dialog('open')
    });

    $("#buscarAdm").click(function() {
        //$(".radio:first").next().attr("checked", "checked");
        $("input[value='PRO']").attr("checked", "checked");
        $(".admin").dialog('open')
    });

 

    $(".botones").hover(function(){

        $(".img_"+$(this).attr("id")).height($(this).height()+10)
        $(".img_"+$(this).attr("id")).width($(this).width()+10)
        $(this).height($(this).height()+10)
        $(this).width($(this).width()+10)
        $(this).css("z-index",4);
    },
    function () {
    
        $(".img_"+$(this).attr("id")).height($(this).height()-10)
        $(".img_"+$(this).attr("id")).width($(this).width()-10)
        $(this).height($(this).height()-10)
        $(this).width($(this).width()-10)
        $(this).css("z-index",$(this).attr("id")*1);
    }
    );
    

    $("#empEncu").click(function(){

        if($("#tipo").val().trim()=="DC"){
            if(jQuery('.ndm:checked').size()!=1){
                $(".mensaje").html("Debe seleccionar una sola materia")
                $(".mensaje").show("slide")
            }
            else{
                $(".formEncuestas").submit();
            }
        }
        else{
            if($("#tipo").val().trim()=="FE"){
                if($("#numMate").val()*1<1){
                    $(".mensaje").html("Por favor registre las materias en la que esta matriculado")
                    $(".mensaje").show("slide")
                }
                else
                    $(".formEncuestas").submit();
            }
            else
                $(".formEncuestas").submit();
        }

    
          
    });

    $(".respRadio").click(function(){
        $('.rr', this ).attr("checked", "checked");
    });


    $(".btn").button();


    $("#menu2").dialog({
        autoOpen: false,
        resizable:false,
        title: 'Acerca de nosotros',
        modal:true,
        position: 'center'
    });
    var menu3 = [ {
        'Quanto':{
            onclick:function(menuItem,menu) {
                $("#menu2").dialog('open');
            },
            className:'menu3-custom-item'
        }
    }, {
        "sistema de evaluacion para docentes, estudiantes y administrativos":{
            disabled:true
        }
    } ];
    $(function() {
        $('body').contextMenu(menu3,{
            theme:'vista'
        });
    });
    
});