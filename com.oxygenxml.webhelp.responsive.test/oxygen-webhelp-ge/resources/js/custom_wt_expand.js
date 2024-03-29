/**
 * Created by alin_balasa on 12-May-16.
 */

var selectors = {
    /* Selectors for the nodes that will contain an expand/collapse button. */
    "expand_buttons" : [
        ".show_hide"
    ]
};


var selectorsX = {
    /* Selectors for the nodes that will contain an expand/collapse button. */
    "expand_buttonsX" : [
        ".show_hide_expanded"
    ]
};

/**
 * Add expand-collapse support.
 */
$(document).ready(function () {
    /* Add the expand/collapse buttons. */
    selectors.expand_buttons.forEach(
        function(selector) {
            var matchedNodes =  $(document).find(selector);
            // Add the expand/collapse support only if the title node has visible siblings.
            var visibleSiblings = matchedNodes.siblings(':not(:hidden)');
            if (visibleSiblings.length > 0) {
                // Add the element with expand/collapse capabilities
                matchedNodes.prepend("<span class=\"wh_expand_btn expanded\"/>");
                markHiddenSiblingsAsNotExpandable(matchedNodes);
            }
        }
    );
    
    
        /* Add the small expand/collapse buttons. */
    selectorsX.expand_buttonsX.forEach(
        function(selector) {
            var matchedNodes =  $(document).find(selector);
            // Add the expand/collapse support only if the title node has visible siblings.
            /*var visibleChilcren = matchedNodes.children(':not(:hidden)');
            if (visibleSiblings.length > 0) {*/
                // Add the element with expand/collapse capabilities
                matchedNodes.prepend("<span class=\"wh_expand_btnX expanded\"/>");
                markHiddenChildrenAsNotExpandable(matchedNodes);
          /*  }*/
        }
    );
    
     /*  
     * Slide down when click on a letter from the indexterms bar
     * */
    $('.wh-letters a').click(function(e){
        var id = $(this).attr('href').replace("#", "");
        e.preventDefault();
        history.replaceState({}, '', e.target.href);
        
        if($("[id='" + id + "']").length > 0){
            $('html, body').animate({scrollTop : $("[id='" + id + "']").offset().top},1000);
        }
    });


    /*  
     * Add permalink  
     * */
    $('.dt[id], .section[id] .sectiontitle, .title.topictitle2[id], table[id] .tablecap').click(function(e){
        var id = $(this).closest('[id]').attr('id');
        var hash = '#'+id;
        e.preventDefault();
        history.replaceState({}, '', hash);

        $('html, body').animate({scrollTop : $("[id='" + id + "']").offset().top},1000);
    });

    /* Expand / collapse support for the marked content */
    $(document).find('.wh_expand_btn').click(function(event){

        // Change the button state
        $(this).toggleClass("expanded");
        // Will expand-collapse the siblings of the parent node, excepting the ones that were marked otherwise
        var siblings = $(this).parent().siblings(':not(.wh_not_expandable)');
        var tagName = $(this).prop("tagName");
        if (tagName == "CAPTION") {
            // The table does not have display:block, so it will not slide.
            // In this case we'll just hide it
            siblings.toggle();
        } else {
            siblings.slideToggle("1000");
        }

        event.stopImmediatePropagation();
        return false;
    });
    
    
        /* Expand / collapse support for the marked content */
    $(document).find('.wh_expand_btnX').click(function(event){

        // Change the button state
        $(this).toggleClass("expanded");
        // Will expand-collapse the siblings of the parent node, excepting the ones that were marked otherwise
        var children = $(this).children(':not(.wh_not_expandable)');
        var tagName = $(this).prop("tagName");
        if (tagName == "CAPTION") {
            // The table does not have display:block, so it will not slide.
            // In this case we'll just hide it
            children.toggle();
        } else {
            children.slideToggle("1000");
        }

        event.stopImmediatePropagation();
        return false;
    });
    
});

/**
 * Marks the hidden siblings of the matched nodes as being not expandable.
 *
 * @param nodes The matched nodes.
 */
function markHiddenSiblingsAsNotExpandable(nodes) {
    var siblings = nodes.siblings(":hidden");
    siblings.addClass("wh_not_expandable");
}

function markHiddenChildrenAsNotExpandable(nodes) {
    var children = nodes.children(":hidden");
    children.addClass("wh_not_expandable");
}
