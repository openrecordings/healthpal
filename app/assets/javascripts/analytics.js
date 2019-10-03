$('#select-visit').on('change', function() {
  var optionSelected = $("option:selected", this);
  window.location = `/analytics/${this.value}`;
});
