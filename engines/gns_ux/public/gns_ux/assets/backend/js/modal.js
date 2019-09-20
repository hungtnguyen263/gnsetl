function gModal(options) {
    var thisModal = this;
    
    // size
    this.size = 'lg';
    this.id = uniqueId();
    if (typeof(options) !== 'undefined') {
        if(typeof(options.size) !== 'undefined') {
            this.size = options.size;
        }
    }
    
    // init
    this.modal = $('#'+this.id);
    if (this.modal.length === 0) {
        var html = '<div id="'+this.id+'" class="modal fade" tabindex="-1" data-backdrop="static">' +
            '<div class="modal-dialog modal-'+this.size+'">' +
                '<div class="modal-content">' +
                '</div>' +
            '</div>' +
        '</div>';
        $('body').append(html);    
        this.modal = $('#'+this.id);
    }
    this.content = this.modal.find('.modal-content');
    
    // clear content
    this.clear = function() {
        // loading effect
        thisModal.content.html('<div class="modal-loading-overlay"><i class="icon-spinner4 spinner mr-2"></i></div>');
    };
    
    // hide modal
    this.hide = function() {
        this.modal.modal('hide');
    };
    
    // load url to modal
    this.load = function(url) {
        // loading effect
        thisModal.clear();
        thisModal.url = url;
    
        this.modal.modal('show');
        
        $.ajax({
            url: thisModal.url,
            method: 'GET',
            data: {
                layout: 'modal'
            }
        }).done(function(response) {
            thisModal.renderHtml(response);
        });
    };
    
    // load url to modal
    this.refresh = function() {
        thisModal.load(thisModal.url);
    };
    
    // load url to modal
    this.renderHtml = function(html) {
        // loading effect
        thisModal.content.html(html);
        applyJs(thisModal.content);
    };
}

$(document).ready(function() {
    $(document).on('click', '.modal-control', function(e) {
        e.preventDefault();
        
        var size = $(this).attr('modal-size');
        if (typeof(size) === 'undefined') {
            size = 'lg';
        }
        
        // show modal
        var m = new gModal({size: size});
        m.load($(this).attr('href'));
    });
});