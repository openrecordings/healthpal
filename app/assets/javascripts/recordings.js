// Call the tag function when tags are selected or unselected
$(document).ready(function() {
    //
    // Register editable recording columns
    ['provider', 'patient_identifier'].forEach(function(c){
        var field = $('.edit_' + c);
        field.editable({
            type: 'text',
            name: c,
            mode: 'inline',
            inputclass: 'editable-input',
            value: '',
            placeholder: field.text()
        });
    });
});

