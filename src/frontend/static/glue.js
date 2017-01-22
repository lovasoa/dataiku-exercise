/*
Glue code that starts the Elm application
*/
window.onload = function () {
  var node = document.getElementById('main');
  var app = Elm.VisualizeCensus.embed(node);
};
