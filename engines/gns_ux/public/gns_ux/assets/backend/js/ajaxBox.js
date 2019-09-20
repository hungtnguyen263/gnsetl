function ajaxBox(obj, url, callback, hide_loader) {
    this.box = obj;
    this.url = url;
    var main = this;
    
    this.clear = function() {
        // Add loading icon spinner
        if (hide_loader !== 'hide' && main.box.find('.datalist-loading-overlay').length === 0) {
            main.box.prepend('<div class="datalist-loading-overlay"><i class="icon-spinner4 spinner mr-2"></i></div>');
        }
    };
    
    this.load = function() {
        main.clear();
        $.ajax({
            url: main.url,
            method: 'GET'
        }).done(function(response) {
            main.box.html(response);
            
            // callback function
            if(typeof(callback) !== 'undefined') {
                callback(main.box);
            }
            
            // apply js
            applyJs(main.box);
        });
    };
    
    this.loadHtml = function(html) {
        main.box.html(html);
    };
}