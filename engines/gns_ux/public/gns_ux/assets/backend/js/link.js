function gLink(objs, ajaxCallback) {    
    this.links = objs;
    
    this.links.each(function() {
        var link = $(this);
        var confirm = $(this).attr('data-confirm');
        var method = $(this).attr('data-method');
        
        // check if link has confirm data
        if (typeof(confirm) !== 'undefined' && confirm !== '') {            
            // link has confirm message
            
            link.click(function(e) {
                if (!link.hasClass('confirmed')) {
                    e.preventDefault(); // stop link click event
                    e.stopImmediatePropagation(); // stop below events            
                    
                    var message = $(this).attr('data-confirm');
                    
                    var confirmModal = $('#confirmModal');
                    confirmModal.remove();
                    // show modal confirmation
                    var html = '<div id="confirmModal" class="modal fade" tabindex="-1">' +
                        '<div class="modal-dialog modal-sm">' +
                            '<div class="modal-content">' +
                                '<div class="modal-header">' +
                                    '<h5 class="modal-title">'+ LANG_ARE_YOU_SURE +'</h5>' +
                                    '<button type="button" class="close" data-dismiss="modal">&times;</button>' +
                                '</div>' +
            
                                '<div class="modal-body">' +
                                    '<p>' + message + '</p>' +
                                '</div>' +
            
                                '<div class="modal-footer">' +
                                    '<button type="button" class="btn btn-link" data-dismiss="modal">' + LANG_CLOSE + '</button>' +
                                    '<button type="button" class="btn bg-primary data-confirm-ok">' + LANG_OK + '</button>' +
                                '</div>' +
                            '</div>' +
                        '</div>' +
                    '</div>';
                    $('body').append(html);
                    confirmModal = $('#confirmModal');
                    
                    confirmModal.modal('show');
                    
                    // data confirm ok
                    var okButton = confirmModal.find('.data-confirm-ok');
                    
                    okButton.click(function() {
                        link.addClass('confirmed');
                        link.click();                
                        confirmModal.modal('hide');
                    });
                }
            });
        }
        
        
        // link has confirm message
        if (link.hasClass('ajax')) {
            link.click(function(e) {
                e.preventDefault(); // stop link click event
                e.stopImmediatePropagation(); // stop below events
                
                var link = $(this);
                var method = link.attr("data-method");
                var action = link.attr("href");
                
                $.ajax({
                    url: action,
                    method: method,
                    data: {
                        authenticity_token: $('meta[name="csrf-token"]').attr('content'),
                        format: 'json',
                    }
                }).done(function(response) {
                    // check message
                    if (typeof(response.message) !== 'undefined') {
                        showNotification(response.status, response.message);
                    }
                    
                    // chạy callback
                    if(typeof(ajaxCallback) !== 'undefined') {
                        ajaxCallback(link);
                    }
                });
            });
        }
        
        // link has confirm message
        if (typeof(method) !== 'undefined' && method !== '') {         
            link.click(function(e) {
                e.preventDefault();
        
                var method = $(this).attr("data-method");
                var action = $(this).attr("href");
            
                var newForm = jQuery('<form>', {
                    'action': action,
                    'method': 'POST'
                });
                newForm.append(jQuery('<input>', {
                    'name': 'authenticity_token',
                    'value': $('meta[name="csrf-token"]').attr('content'),
                    'type': 'hidden'
                }));
                newForm.append(jQuery('<input>', {
                    'name': '_method',
                    'value': method,
                    'type': 'hidden'
                }));
                $(document.body).append(newForm);
                newForm.submit();
            });
        }
    });
        
}