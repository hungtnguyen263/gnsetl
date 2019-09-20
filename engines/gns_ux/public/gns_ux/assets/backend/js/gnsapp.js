function showNotification(status, message) {
    switch(status) {
        case 'success':
            new PNotify({
                icon: 'icon-checkmark3',
                title: 'Success',
                text: message,
                type: 'success'
            });
            break;
        case 'notice':
            new PNotify({
                icon: 'icon-info22',
                title: 'Notice',
                text: message,
                type: 'info'
            });
            break;
        case 'warning':
            new PNotify({
                icon: 'icon-warning',
                title: 'Warning',
                text: message,
                type: 'warning'
            });
            break;
        case 'error':
            new PNotify({
                icon: 'icon-blocked',
                title: 'Error',
                text: message,
                type: 'error'
            });
            break;
        case 'info':
          // code block
          break;
        default:
          // code block
    }
}

function uniqueId() {
    return 'id-xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}

function applyJs(container) {
    // Select initialization
    container.find('.select').each(function () {
        $(this).select2({
            dropdownParent: $(this).parent()
        });
    });
    
    container.find('.selectAllowClear').select2({
        allowClear: true,
        minimumResultsForSearch: Infinity
    });
    
    // Infinity search field of select
    container.find('.selectPrimary').select2({
        minimumResultsForSearch: Infinity
    });
    
    // Initialize
    container.find('.radio-button').uniform();
    
    container.find('.file-input').uniform();
    
    container.find('.form-check-input-styled-primary').uniform({
        wrapperClass: 'border-primary-600 text-primary-800'
    });
    
    // Image lightbox
    container.find('[data-popup="lightbox"]').fancybox({
        padding: 3
    });
    
    // Initialize multiple switches /switchery
    var elems = Array.prototype.slice.call(document.querySelectorAll('.form-check-input-switchery'));
    elems.forEach(function(html) {
      var switchery = new Switchery(html);
    });
    
    // Initialize multiple switches /switch
    $('.form-check-input-switch').bootstrapSwitch();
    
    // Multi select initialization
    container.find('.multiselect').multiselect();
    
    container.find('.daterange-single').daterangepicker({
        "singleDatePicker": true,
        "linkedCalendars": false,
        "showCustomRangeLabel": false,
        "opens": "left",
        "applyClass": "bg-slate-600",
        "cancelClass": "btn-light",
        "locale": {
            "format": "DD/MM/YYYY",
            "separator": " - ",
            "weekLabel": "W",
            "daysOfWeek": [
                "Su",
                "Mo",
                "Tu",
                "We",
                "Th",
                "Fr",
                "Sa"
            ],
            "monthNames": [
                "January",
                "February",
                "March",
                "April",
                "May",
                "June",
                "July",
                "August",
                "September",
                "October",
                "November",
                "December"
            ],
            "firstDay": 1
        },
    });
    
    container.find('.daterange-dual').daterangepicker({
        "linkedCalendars": false,
        //"timePicker": true,
        "showCustomRangeLabel": false,
        "opens": "left",
        "applyClass": "bg-slate-600",
        "cancelClass": "btn-light",
        "locale": {
            "format": "DD/MM/YYYY",
            "separator": " - ",
            "applyLabel": "Apply",
            "cancelLabel": "Cancel",
            "fromLabel": "From",
            "toLabel": "To",
            "customRangeLabel": "Custom",
            "weekLabel": "W",
            "daysOfWeek": [
                "Su",
                "Mo",
                "Tu",
                "We",
                "Th",
                "Fr",
                "Sa"
            ],
            "monthNames": [
                "January",
                "February",
                "March",
                "April",
                "May",
                "June",
                "July",
                "August",
                "September",
                "October",
                "November",
                "December"
            ],
            "firstDay": 1
        },
    });
    
    container.find('#ion-percentage').ionRangeSlider({
        min: 0,
        max: 100,
        postfix: '%'
    });
    
    // Datalist
    container.find('.datalist').datalist();
    
    // Select2 ajax
    container.find('.select-ajax').each(function() {
        var url = $(this).attr('data-url');
        
        var allow_clear = true;
        if (typeof($(this).attr('multiple')) !== 'undefined') {
            allow_clear = false;
        }
        
        $(this).select2({
            allowClear: allow_clear,
            dropdownParent: $(this).parent(),
            ajax: {
              url: url,
              dataType: 'json'
              // Additional AJAX parameters go here; see the end of this chapter for the full code of this example
            }
        });
    });
    
    // check active menu
    container.find('.nav-link').each(function() {
        var menus = [];
        var active = false;
        
        if (typeof($(this).attr('data-menu')) !== 'undefined') {
            menus = $(this).attr('data-menu').split(',');
        }
        
        menus.forEach(function(item) {
            if (current_controller == item.trim() || full_path == item.trim()) {
                active = true;
                return;
            }
        });
        
        if(active) {
            $(this).addClass('active');
            $(this).closest('.nav-item-submenu').addClass('nav-item-open');
            $(this).closest('.nav-group-sub').css('display', 'block');
        }
    });	
    
    // gLink
    new gLink(container.find('.g-link'));
    
    //
    // Card actions
    // -------------------------

    // Reload card (uses BlockUI extension)
    var gCardActionReload = function() {
        container.find('.card [data-action=reload]:not(.disabled)').on('click', function (e) {
            e.preventDefault();
            var $target = $(this),
                block = $target.closest('.card');
            
            // Block card
            $(block).block({ 
                message: '<i class="icon-spinner2 spinner"></i>',
                overlayCSS: {
                    backgroundColor: '#fff',
                    opacity: 0.8,
                    cursor: 'wait',
                    'box-shadow': '0 0 0 1px #ddd'
                },
                css: {
                    border: 0,
                    padding: 0,
                    backgroundColor: 'none'
                }
            });

            // For demo purposes
            window.setTimeout(function () {
               $(block).unblock();
            }, 2000); 
        });
    };

    // Collapse card
    var gCardActionCollapse = function() {
        var $cardCollapsedClass = container.find('.card-collapsed');

        // Hide if collapsed by default
        $cardCollapsedClass.children('.card-header').nextAll().hide();

        // Rotate icon if collapsed by default
        $cardCollapsedClass.find('[data-action=collapse]').addClass('rotate-180');

        // Collapse on click
        container.find('.card [data-action=collapse]:not(.disabled)').on('click', function (e) {
            var $target = $(this),
                slidingSpeed = 150;

            e.preventDefault();
            $target.parents('.card').toggleClass('card-collapsed');
            $target.toggleClass('rotate-180');
            $target.closest('.card').children('.card-header').nextAll().slideToggle(slidingSpeed);
        });
    };

    // Remove card
    var gCardActionRemove = function() {
        container.find('.card [data-action=remove]').on('click', function (e) {
            e.preventDefault();
            var $target = $(this),
                slidingSpeed = 150;

            // If not disabled
            if(!$target.hasClass('disabled')) {
                $target.closest('.card').slideUp({
                    duration: slidingSpeed,
                    start: function() {
                        $target.addClass('d-block');
                    },
                    complete: function() {
                        $target.remove();
                    }
                });
            }
        });
    };

    // Card fullscreen mode
    var gCardActionFullscreen = function() {
        container.find('.card [data-action=fullscreen]').on('click', function (e) {
            e.preventDefault();

            // Define vars
            var $target = $(this),
                cardFullscreen = $target.closest('.card'),
                overflowHiddenClass = 'overflow-hidden',
                collapsedClass = 'collapsed-in-fullscreen',
                fullscreenAttr = 'data-fullscreen';

            // Toggle classes on card
            cardFullscreen.toggleClass('fixed-top h-100 rounded-0');

            // Configure
            if (!cardFullscreen.hasClass('fixed-top')) {
                $target.removeAttr(fullscreenAttr);
                cardFullscreen.children('.' + collapsedClass).removeClass('show');
                $('body').removeClass(overflowHiddenClass);
                $target.siblings('[data-action=move], [data-action=remove], [data-action=collapse]').removeClass('d-none');
            }
            else {
                $target.attr(fullscreenAttr, 'active');
                cardFullscreen.removeAttr('style').children('.collapse:not(.show)').addClass('show ' + collapsedClass);
                $('body').addClass(overflowHiddenClass);
                $target.siblings('[data-action=move], [data-action=remove], [data-action=collapse]').addClass('d-none');
            }
        });
    };
    
    // Tooltip
    var gComponentTooltip = function() {

        // Initialize
        container.find('[data-popup="tooltip"]').tooltip({
            //template: '<div class="tooltip"><div class="arrow border-info-700"></div><div class="tooltip-inner bg-info-700"></div></div>'
        });

        // Demo tooltips, remove in production
        var demoTooltipSelector = '[data-popup="tooltip-demo"]';
        if($(demoTooltipSelector).is(':visible')) {
            $(demoTooltipSelector).tooltip('show');
            setTimeout(function() {
                $(demoTooltipSelector).tooltip('hide');
            }, 2000);
        }
    };
    
    gCardActionReload();
    gCardActionCollapse();
    gCardActionRemove();
    gCardActionFullscreen();
    gComponentTooltip();
}

$(document).ready(function() {    
    // Apply js first load
    applyJs($('body'));
    
    // Warning button
    $(document).on('click', '.warning-button', function(e) {
        e.preventDefault();
        
        var message = $(this).attr('data-warning');
        var html = '<div id="warningButtonModal" class="modal fade" tabindex="-1">' +
            '<div class="modal-dialog modal-sm">' +
                '<div class="modal-content">' +    
                    '<div class="modal-body text-center">' +
                        '<p>' + message + '</p>' +
                        '<button type="button" class="btn btn-primary" data-dismiss="modal">' + LANG_UNDERSTAND + '</button>' +
                    '</div>' +
                '</div>' +
            '</div>' +
        '</div>';
        $('body').append(html);
        warningButtonModal = $('#warningButtonModal');
        
        warningButtonModal.modal('show');
    });
});