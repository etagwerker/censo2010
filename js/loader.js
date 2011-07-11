window.Censo2010 = {};

$(function(){

  Censo2010.Cabecera = Backbone.Model.extend({
  
  });

  Censo2010.CabecerasCollection = Backbone.Collection.extend({
  
    model: Censo2010.Cabecera, 
    
    url: function() {
      return '/cabeceras';
    }
  
  });

});

