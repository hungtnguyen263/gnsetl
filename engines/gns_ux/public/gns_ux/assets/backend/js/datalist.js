var datalists = {};

$.fn.datalist = function() {    
    return this.each(function() {
        var box = {};
        box.id = uniqueId();
        box.datalist = $(this);
        box.content = box.datalist.find('.datalist-content');
        box.url = box.datalist.attr('data-url');
        box.search_button = box.datalist.find('.datalist-search-button');
        box.form = box.datalist.find('.datalist-filters');
        box.keyword_input = box.datalist.find('.keyword-input');
        box.keyword_value = function() {
            return box.keyword_input.val();
        };
        box.per_page_select = box.datalist.find('.per-page-select');
        box.sort_direction_input = box.datalist.find('.sort-direction');
        box.sort_direction_value = function() {
            return box.sort_direction_input.val();
        };
        box.sort_by_select = box.datalist.find('.sort-by-select');
        
        box.show_columns_select = box.datalist.find('.show-columns-select');
        
        // prvent form submit
        box.form.submit(function() {
            return false;
        });
        
        // add id to datalist
        box.datalist.attr('data-id', box.id);
        
        // append security token
        box.form.append('<input type="hidden" name="authenticity_token" value="'+$('meta[name="csrf-token"]').attr('content')+'" />');
        
        // append sort direction button
        box.sort_direction_input.after('<span class="btn btn-light btn-icon ml-2 sort-direction-button"><i class="icon-sort-amount-'+box.sort_direction_value()+'"></i></span>');
        box.sort_direction_button  = box.datalist.find('.sort-direction-button');
        box.sort_direction_icon  = box.sort_direction_button.find('i');
        
        // Load list
        box.load = function(url) {
            // get url
            if(typeof(url) === 'undefined') {
                url = box.url;
            }
            
            // set current url
            box.current_url = url;
            
            // Add loading icon spinner
            if (box.content.find('.datalist-loading-overlay').length === 0) {
                box.content.prepend('<div class="datalist-loading-overlay"><i class="icon-spinner4 spinner mr-2"></i></div>');
            }
            
            // form data
            data = box.form.serialize();
            
            // ajax load list
            if(box.xhr && box.xhr.readyState != 4){
                box.xhr.abort();
            }
            
            box.xhr = $.ajax({
                url: url,
                method: 'POST',
                data: data
            }).done(function(response) {
                box.content.html(response);
                
                // After list loaded
                box.afterLoad();
            });
        };
        
        // Load list
        box.refresh = function() {
            box.load(box.current_url);
        };
        
        // load first time
        box.load();
        
        // search / filter
        box.search_button.click(function() {
            box.load();
        });
        
        // keyword search change
        box.keyword_input.change(function() {
            box.load();
        });
        
        // per page select change
        box.per_page_select.change(function() {
            box.load();
        });
        
        // sort_by select change
        box.sort_by_select.change(function() {
            box.load();
        });
        
        // Click on sort direction
        box.sort_direction_button.click(function() {
            if (box.sort_direction_value() == 'asc') {
                box.sort_direction_input.val('desc');
                box.sort_direction_icon.removeClass('icon-sort-amount-asc');
                box.sort_direction_icon.addClass('icon-sort-amount-desc');
            } else {
                box.sort_direction_input.val('asc');
                box.sort_direction_icon.removeClass('icon-sort-amount-desc');
                box.sort_direction_icon.addClass('icon-sort-amount-asc');
            }
            
            box.load();
        });
        
        // show_columns select change
        box.show_columns_select.change(function() {
            box.load();
        });
        
        // After list loaded
        box.afterLoad = function() {
            // apply js
            applyJs(box.content);
            
            // pagination click
            box.datalist.find('.pagination a').click(function(e) {
                e.preventDefault();
                var url = $(this).attr('href');
                
                box.load(url);                
            });
            
            // apply action
            new gLink(box.content.find('.datalist-g-link'), function() {
                box.refresh();
            });
        };
        
        datalists[box.id] = box;
        
        return box;
    }); 
};