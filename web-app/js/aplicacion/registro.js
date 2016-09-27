/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

    var j$ = jQuery.noConflict();
    j$(function() {

      j$("#lsta").dialog({
        height: 140,
        modal: true,
        autoOpen: false,
        zIndex: 2,
        height: 400,
        width: 800, buttons: { "Aceptar": function() {
          //alert(j$(':checkbox[checked="true"]').val());
          var codigos = "";
          j$(':checkbox[checked="true"]').each(
            function(){
              codigos += j$(this).val();
            });
          alert(codigos);
          j$(this).dialog("close");
         } }
       });

       j$("#buscar").dialog({autoOpen: false});

       j$("#lista").click(function() {
         j$("#lsta").dialog("open");
       });
       j$("#lista2").click(function() {
         j$("#buscar").dialog("open");
       });

       j$("#escuela").click(function() {
         var data ='facl=' + j$("#facl").val();
         j$.ajax({type:"POST", url:"escuela", data: data,
           success: function(html){
             j$("#ajx_escl").html(html);
             j$("#titl01").css("color", "#000");
           }
         });
         return false;
        });

       j$("#materia").livequery(function(){
         j$("#materia").click(function() {

           var data ='facl=' + j$("#facl").val() + '&escl=' + j$("#escl").val();
           j$.ajax({type:"POST", url:"materias", data: data,
             success: function(html){
               j$("#ajx_lsta").html(html);
               j$("#titl02").css("color", "#000");
               j$("#lsta").dialog("open");
             }
           });
           return false;
          });
        });

});

