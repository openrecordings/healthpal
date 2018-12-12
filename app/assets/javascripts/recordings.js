// Set up tabs on pages with a #tabs element
$(document).ready(function() {
    $(".tabs").tabs();
    console.log('here');
    // Register editable recording columns
    ['provider', 'patient_identifier'].forEach(function(c){
        var field = $('.edit_' + c);
        if(field.length > 0) {
            field.editable({
                type: 'text',
                name: c,
                mode: 'inline',
                inputclass: 'editable-input',
                value: '',
                placeholder: $(field[0]).text() // All of the same kind of field have same placeholders
            });
        }
    });
});
