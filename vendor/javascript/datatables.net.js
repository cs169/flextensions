// datatables.net@2.3.1 downloaded from https://ga.jspm.io/npm:datatables.net@2.3.1/js/dataTables.mjs

import e from"jquery";var t=e;var r=function(e,a){if(r.factory(e,a))return r;if(this instanceof r)return t(e).DataTable(a);a=e;var i=this;var o=a===void 0;var l=this.length;o&&(a={});this.api=function(){return new n(this)};this.each((function(){var e={};var s=l>1?mt(e,a,true):a;var u,c=0;var f=this.getAttribute("id");var d=r.defaults;var v=t(this);if(this.nodeName.toLowerCase()=="table"){s.on&&s.on.options&&Ct(v,"options",s.on.options);v.trigger("options.dt",s);j(d);P(d.column);O(d,d,true);O(d.column,d.column,true);O(d,t.extend(s,v.data()),true);var h=r.settings;for(c=0,u=h.length;c<u;c++){var p=h[c];if(p.nTable==this||p.nTHead&&p.nTHead.parentNode==this||p.nTFoot&&p.nTFoot.parentNode==this){var g=s.bRetrieve!==void 0?s.bRetrieve:d.bRetrieve;var m=s.bDestroy!==void 0?s.bDestroy:d.bDestroy;if(o||g)return p.oInstance;if(m){new r.Api(p).destroy();break}pt(p,0,"Cannot reinitialise DataTable",3);return}if(p.sTableId==this.id){h.splice(c,1);break}}if(f===null||f===""){f="DataTables_Table_"+r.ext._unique++;this.id=f}var b=t.extend(true,{},r.models.oSettings,{sDestroyWidth:v[0].style.width,sInstance:f,sTableId:f,colgroup:t("<colgroup>").prependTo(this),fastData:function(e,t,r){return ee(b,e,t,r)}});b.nTable=this;b.oInit=s;h.push(b);b.api=new n(b);b.oInstance=i.length===1?i:v.dataTable();j(s);s.aLengthMenu&&!s.iDisplayLength&&(s.iDisplayLength=Array.isArray(s.aLengthMenu[0])?s.aLengthMenu[0][0]:t.isPlainObject(s.aLengthMenu[0])?s.aLengthMenu[0].value:s.aLengthMenu[0]);s=mt(t.extend(true,{},d),s);gt(b.oFeatures,s,["bPaginate","bLengthChange","bFilter","bSort","bSortMulti","bInfo","bProcessing","bAutoWidth","bSortClasses","bServerSide","bDeferRender"]);gt(b,s,["ajax","fnFormatNumber","sServerMethod","aaSorting","aaSortingFixed","aLengthMenu","sPaginationType","iStateDuration","bSortCellsTop","iTabIndex","sDom","fnStateLoadCallback","fnStateSaveCallback","renderer","searchDelay","rowId","caption","layout","orderDescReverse","orderIndicators","orderHandler","titleRow","typeDetect",["iCookieDuration","iStateDuration"],["oSearch","oPreviousSearch"],["aoSearchCols","aoPreSearchCols"],["iDisplayLength","_iDisplayLength"]]);gt(b.oScroll,s,[["sScrollX","sX"],["sScrollXInner","sXInner"],["sScrollY","sY"],["bScrollCollapse","bCollapse"]]);gt(b.oLanguage,s,"fnInfoCallback");yt(b,"aoDrawCallback",s.fnDrawCallback);yt(b,"aoStateSaveParams",s.fnStateSaveParams);yt(b,"aoStateLoadParams",s.fnStateLoadParams);yt(b,"aoStateLoaded",s.fnStateLoaded);yt(b,"aoRowCallback",s.fnRowCallback);yt(b,"aoRowCreatedCallback",s.fnCreatedRow);yt(b,"aoHeaderCallback",s.fnHeaderCallback);yt(b,"aoFooterCallback",s.fnFooterCallback);yt(b,"aoInitComplete",s.fnInitComplete);yt(b,"aoPreDrawCallback",s.fnPreDrawCallback);b.rowIdFn=oe(s.rowId);s.on&&Object.keys(s.on).forEach((function(e){Ct(v,e,s.on[e])}));E(b);var y=b.oClasses;t.extend(y,r.ext.classes,s.oClasses);v.addClass(y.table);b.oFeatures.bPaginate||(s.iDisplayStart=0);if(b.iInitDisplayStart===void 0){b.iInitDisplayStart=s.iDisplayStart;b._iDisplayStart=s.iDisplayStart}var D=s.iDeferLoading;if(D!==null){b.deferLoading=true;var w=Array.isArray(D);b._iRecordsDisplay=w?D[0]:D;b._iRecordsTotal=w?D[1]:D}var x=[];var S=this.getElementsByTagName("thead");var T=Ie(b,S[0]);if(s.aoColumns)x=s.aoColumns;else if(T.length)for(c=0,u=T[0].length;c<u;c++)x.push(null);for(c=0,u=x.length;c<u;c++)k(b);G(b,s.aoColumnDefs,x,T,(function(e,t){M(b,e,t)}));var _=v.children("tbody").find("tr:first-child").eq(0);if(_.length){var C=function(e,t){return e.getAttribute("data-"+t)!==null?t:null};t(_[0]).children("th, td").each((function(e,t){var r=b.aoColumns[e];r||pt(b,0,"Incorrect column count",18);if(r.mData===e){var a=C(t,"sort")||C(t,"order");var n=C(t,"filter")||C(t,"search");if(a!==null||n!==null){r.mData={_:e+".display",sort:a!==null?e+".@data-"+a:void 0,type:a!==null?e+".@data-"+a:void 0,filter:n!==null?e+".@data-"+n:void 0};r._isArrayHost=true;M(b,e)}}}))}yt(b,"aoDrawCallback",dt);var I=b.oFeatures;s.bStateSave&&(I.bStateSave=true);if(s.aaSorting===void 0){var L=b.aaSorting;for(c=0,u=L.length;c<u;c++)L[c][1]=b.aoColumns[c].asSorting[0]}ct(b);yt(b,"aoDrawCallback",(function(){(b.bSorted||St(b)==="ssp"||I.bDeferRender)&&ct(b)}));var A=v.children("caption");if(b.caption){A.length===0&&(A=t("<caption/>").appendTo(v));A.html(b.caption)}if(A.length){A[0]._captionSide=A.css("caption-side");b.captionNode=A[0]}S.length===0&&(S=t("<thead/>").appendTo(v));b.nTHead=S[0];var N=v.children("tbody");N.length===0&&(N=t("<tbody/>").insertAfter(S));b.nTBody=N[0];var F=v.children("tfoot");F.length===0&&(F=t("<tfoot/>").appendTo(v));b.nTFoot=F[0];b.aiDisplay=b.aiDisplayMaster.slice();b.bInitialised=true;var R=b.oLanguage;t.extend(true,R,s.oLanguage);if(R.sUrl)t.ajax({dataType:"json",url:R.sUrl,success:function(e){O(d.oLanguage,e);t.extend(true,R,e,b.oInit.oLanguage);Dt(b,null,"i18n",[b],true);Be(b)},error:function(){pt(b,0,"i18n file loading error",21);Be(b)}});else{Dt(b,null,"i18n",[b],true);Be(b)}}else pt(null,0,"Non-table node initialisation ("+this.nodeName+")",2)}));i=null;return this};r.ext=a={
/**
	 * DataTables build type (expanded by the download builder)
	 *
	 *  @type string
	 */
builder:"-source-",
/**
	 * Buttons. For use with the Buttons extension for DataTables. This is
	 * defined here so other extensions can define buttons regardless of load
	 * order. It is _not_ used by DataTables core.
	 *
	 *  @type object
	 *  @default {}
	 */
buttons:{},
/**
	 * ColumnControl buttons and content
	 *
	 *  @type object
	 */
ccContent:{},
/**
	 * Element class names
	 *
	 *  @type object
	 *  @default {}
	 */
classes:{},
/**
	 * Error reporting.
	 * 
	 * How should DataTables report an error. Can take the value 'alert',
	 * 'throw', 'none' or a function.
	 *
	 *  @type string|function
	 *  @default alert
	 */
errMode:"alert",feature:[],features:{},
/**
	 * Row searching.
	 * 
	 * This method of searching is complimentary to the default type based
	 * searching, and a lot more comprehensive as it allows you complete control
	 * over the searching logic. Each element in this array is a function
	 * (parameters described below) that is called for every row in the table,
	 * and your logic decides if it should be included in the searching data set
	 * or not.
	 *
	 * Searching functions have the following input parameters:
	 *
	 * 1. `{object}` DataTables settings object: see
	 *    {@link DataTable.models.oSettings}
	 * 2. `{array|object}` Data for the row to be processed (same as the
	 *    original format that was passed in as the data source, or an array
	 *    from a DOM data source
	 * 3. `{int}` Row index ({@link DataTable.models.oSettings.aoData}), which
	 *    can be useful to retrieve the `TR` element if you need DOM interaction.
	 *
	 * And the following return is expected:
	 *
	 * * {boolean} Include the row in the searched result set (true) or not
	 *   (false)
	 *
	 * Note that as with the main search ability in DataTables, technically this
	 * is "filtering", since it is subtractive. However, for consistency in
	 * naming we call it searching here.
	 *
	 *  @type array
	 *  @default []
	 *
	 *  @example
	 *    // The following example shows custom search being applied to the
	 *    // fourth column (i.e. the data[3] index) based on two input values
	 *    // from the end-user, matching the data in a certain range.
	 *    $.fn.dataTable.ext.search.push(
	 *      function( settings, data, dataIndex ) {
	 *        var min = document.getElementById('min').value * 1;
	 *        var max = document.getElementById('max').value * 1;
	 *        var version = data[3] == "-" ? 0 : data[3]*1;
	 *
	 *        if ( min == "" && max == "" ) {
	 *          return true;
	 *        }
	 *        else if ( min == "" && version < max ) {
	 *          return true;
	 *        }
	 *        else if ( min < version && "" == max ) {
	 *          return true;
	 *        }
	 *        else if ( min < version && version < max ) {
	 *          return true;
	 *        }
	 *        return false;
	 *      }
	 *    );
	 */
search:[],
/**
	 * Selector extensions
	 *
	 * The `selector` option can be used to extend the options available for the
	 * selector modifier options (`selector-modifier` object data type) that
	 * each of the three built in selector types offer (row, column and cell +
	 * their plural counterparts). For example the Select extension uses this
	 * mechanism to provide an option to select only rows, columns and cells
	 * that have been marked as selected by the end user (`{selected: true}`),
	 * which can be used in conjunction with the existing built in selector
	 * options.
	 *
	 * Each property is an array to which functions can be pushed. The functions
	 * take three attributes:
	 *
	 * * Settings object for the host table
	 * * Options object (`selector-modifier` object type)
	 * * Array of selected item indexes
	 *
	 * The return is an array of the resulting item indexes after the custom
	 * selector has been applied.
	 *
	 *  @type object
	 */
selector:{cell:[],column:[],row:[]},
/**
	 * Legacy configuration options. Enable and disable legacy options that
	 * are available in DataTables.
	 *
	 *  @type object
	 */
legacy:{
/**
		 * Enable / disable DataTables 1.9 compatible server-side processing
		 * requests
		 *
		 *  @type boolean
		 *  @default null
		 */
ajax:null},
/**
	 * Pagination plug-in methods.
	 * 
	 * Each entry in this object is a function and defines which buttons should
	 * be shown by the pagination rendering method that is used for the table:
	 * {@link DataTable.ext.renderer.pageButton}. The renderer addresses how the
	 * buttons are displayed in the document, while the functions here tell it
	 * what buttons to display. This is done by returning an array of button
	 * descriptions (what each button will do).
	 *
	 * Pagination types (the four built in options and any additional plug-in
	 * options defined here) can be used through the `paginationType`
	 * initialisation parameter.
	 *
	 * The functions defined take two parameters:
	 *
	 * 1. `{int} page` The current page index
	 * 2. `{int} pages` The number of pages in the table
	 *
	 * Each function is expected to return an array where each element of the
	 * array can be one of:
	 *
	 * * `first` - Jump to first page when activated
	 * * `last` - Jump to last page when activated
	 * * `previous` - Show previous page when activated
	 * * `next` - Show next page when activated
	 * * `{int}` - Show page of the index given
	 * * `{array}` - A nested array containing the above elements to add a
	 *   containing 'DIV' element (might be useful for styling).
	 *
	 * Note that DataTables v1.9- used this object slightly differently whereby
	 * an object with two functions would be defined for each plug-in. That
	 * ability is still supported by DataTables 1.10+ to provide backwards
	 * compatibility, but this option of use is now decremented and no longer
	 * documented in DataTables 1.10+.
	 *
	 *  @type object
	 *  @default {}
	 *
	 *  @example
	 *    // Show previous, next and current page buttons only
	 *    $.fn.dataTableExt.oPagination.current = function ( page, pages ) {
	 *      return [ 'previous', page, 'next' ];
	 *    };
	 */
pager:{},renderer:{pageButton:{},header:{}},
/**
	 * Ordering plug-ins - custom data source
	 * 
	 * The extension options for ordering of data available here is complimentary
	 * to the default type based ordering that DataTables typically uses. It
	 * allows much greater control over the the data that is being used to
	 * order a column, but is necessarily therefore more complex.
	 * 
	 * This type of ordering is useful if you want to do ordering based on data
	 * live from the DOM (for example the contents of an 'input' element) rather
	 * than just the static string that DataTables knows of.
	 * 
	 * The way these plug-ins work is that you create an array of the values you
	 * wish to be ordering for the column in question and then return that
	 * array. The data in the array much be in the index order of the rows in
	 * the table (not the currently ordering order!). Which order data gathering
	 * function is run here depends on the `dt-init columns.orderDataType`
	 * parameter that is used for the column (if any).
	 *
	 * The functions defined take two parameters:
	 *
	 * 1. `{object}` DataTables settings object: see
	 *    {@link DataTable.models.oSettings}
	 * 2. `{int}` Target column index
	 *
	 * Each function is expected to return an array:
	 *
	 * * `{array}` Data for the column to be ordering upon
	 *
	 *  @type array
	 *
	 *  @example
	 *    // Ordering using `input` node values
	 *    $.fn.dataTable.ext.order['dom-text'] = function  ( settings, col )
	 *    {
	 *      return this.api().column( col, {order:'index'} ).nodes().map( function ( td, i ) {
	 *        return $('input', td).val();
	 *      } );
	 *    }
	 */
order:{},type:{className:{},
/**
		 * Type detection functions.
		 *
		 * The functions defined in this object are used to automatically detect
		 * a column's type, making initialisation of DataTables super easy, even
		 * when complex data is in the table.
		 *
		 * The functions defined take two parameters:
		 *
	     *  1. `{*}` Data from the column cell to be analysed
	     *  2. `{settings}` DataTables settings object. This can be used to
	     *     perform context specific type detection - for example detection
	     *     based on language settings such as using a comma for a decimal
	     *     place. Generally speaking the options from the settings will not
	     *     be required
		 *
		 * Each function is expected to return:
		 *
		 * * `{string|null}` Data type detected, or null if unknown (and thus
		 *   pass it on to the other type detection functions.
		 *
		 *  @type array
		 *
		 *  @example
		 *    // Currency type detection plug-in:
		 *    $.fn.dataTable.ext.type.detect.push(
		 *      function ( data, settings ) {
		 *        // Check the numeric part
		 *        if ( ! data.substring(1).match(/[0-9]/) ) {
		 *          return null;
		 *        }
		 *
		 *        // Check prefixed by currency
		 *        if ( data.charAt(0) == '$' || data.charAt(0) == '&pound;' ) {
		 *          return 'currency';
		 *        }
		 *        return null;
		 *      }
		 *    );
		 */
detect:[],render:{},
/**
		 * Type based search formatting.
		 *
		 * The type based searching functions can be used to pre-format the
		 * data to be search on. For example, it can be used to strip HTML
		 * tags or to de-format telephone numbers for numeric only searching.
		 *
		 * Note that is a search is not defined for a column of a given type,
		 * no search formatting will be performed.
		 * 
		 * Pre-processing of searching data plug-ins - When you assign the sType
		 * for a column (or have it automatically detected for you by DataTables
		 * or a type detection plug-in), you will typically be using this for
		 * custom sorting, but it can also be used to provide custom searching
		 * by allowing you to pre-processing the data and returning the data in
		 * the format that should be searched upon. This is done by adding
		 * functions this object with a parameter name which matches the sType
		 * for that target column. This is the corollary of <i>afnSortData</i>
		 * for searching data.
		 *
		 * The functions defined take a single parameter:
		 *
	     *  1. `{*}` Data from the column cell to be prepared for searching
		 *
		 * Each function is expected to return:
		 *
		 * * `{string|null}` Formatted string that will be used for the searching.
		 *
		 *  @type object
		 *  @default {}
		 *
		 *  @example
		 *    $.fn.dataTable.ext.type.search['title-numeric'] = function ( d ) {
		 *      return d.replace(/\n/g," ").replace( /<.*?>/g, "" );
		 *    }
		 */
search:{},
/**
		 * Type based ordering.
		 *
		 * The column type tells DataTables what ordering to apply to the table
		 * when a column is sorted upon. The order for each type that is defined,
		 * is defined by the functions available in this object.
		 *
		 * Each ordering option can be described by three properties added to
		 * this object:
		 *
		 * * `{type}-pre` - Pre-formatting function
		 * * `{type}-asc` - Ascending order function
		 * * `{type}-desc` - Descending order function
		 *
		 * All three can be used together, only `{type}-pre` or only
		 * `{type}-asc` and `{type}-desc` together. It is generally recommended
		 * that only `{type}-pre` is used, as this provides the optimal
		 * implementation in terms of speed, although the others are provided
		 * for compatibility with existing Javascript sort functions.
		 *
		 * `{type}-pre`: Functions defined take a single parameter:
		 *
	     *  1. `{*}` Data from the column cell to be prepared for ordering
		 *
		 * And return:
		 *
		 * * `{*}` Data to be sorted upon
		 *
		 * `{type}-asc` and `{type}-desc`: Functions are typical Javascript sort
		 * functions, taking two parameters:
		 *
	     *  1. `{*}` Data to compare to the second parameter
	     *  2. `{*}` Data to compare to the first parameter
		 *
		 * And returning:
		 *
		 * * `{*}` Ordering match: <0 if first parameter should be sorted lower
		 *   than the second parameter, ===0 if the two parameters are equal and
		 *   >0 if the first parameter should be sorted height than the second
		 *   parameter.
		 * 
		 *  @type object
		 *  @default {}
		 *
		 *  @example
		 *    // Numeric ordering of formatted numbers with a pre-formatter
		 *    $.extend( $.fn.dataTable.ext.type.order, {
		 *      "string-pre": function(x) {
		 *        a = (a === "-" || a === "") ? 0 : a.replace( /[^\d\-\.]/g, "" );
		 *        return parseFloat( a );
		 *      }
		 *    } );
		 *
		 *  @example
		 *    // Case-sensitive string ordering, with no pre-formatting method
		 *    $.extend( $.fn.dataTable.ext.order, {
		 *      "string-case-asc": function(x,y) {
		 *        return ((x < y) ? -1 : ((x > y) ? 1 : 0));
		 *      },
		 *      "string-case-desc": function(x,y) {
		 *        return ((x < y) ? 1 : ((x > y) ? -1 : 0));
		 *      }
		 *    } );
		 */
order:{}},
/**
	 * Unique DataTables instance counter
	 *
	 * @type int
	 * @private
	 */
_unique:0,
/**
	 * Version check function.
	 *  @type function
	 *  @depreciated Since 1.10
	 */
fnVersionCheck:r.fnVersionCheck,
/**
	 * Index for what 'this' index API functions should use
	 *  @type int
	 *  @deprecated Since v1.10
	 */
iApiIndex:0,
/**
	 * Software version
	 *  @type string
	 *  @deprecated Since v1.10
	 */
sVersion:r.version};t.extend(a,{afnFiltering:a.search,aTypes:a.type.detect,ofnSearch:a.type.search,oSort:a.type.order,afnSortData:a.order,aoFeatures:a.feature,oStdClasses:a.classes,oPagination:a.pager});t.extend(r.ext.classes,{container:"dt-container",empty:{row:"dt-empty"},info:{container:"dt-info"},layout:{row:"dt-layout-row",cell:"dt-layout-cell",tableRow:"dt-layout-table",tableCell:"",start:"dt-layout-start",end:"dt-layout-end",full:"dt-layout-full"},length:{container:"dt-length",select:"dt-input"},order:{canAsc:"dt-orderable-asc",canDesc:"dt-orderable-desc",isAsc:"dt-ordering-asc",isDesc:"dt-ordering-desc",none:"dt-orderable-none",position:"sorting_"},processing:{container:"dt-processing"},scrolling:{body:"dt-scroll-body",container:"dt-scroll",footer:{self:"dt-scroll-foot",inner:"dt-scroll-footInner"},header:{self:"dt-scroll-head",inner:"dt-scroll-headInner"}},search:{container:"dt-search",input:"dt-input"},table:"dataTable",tbody:{cell:"",row:""},thead:{cell:"",row:""},tfoot:{cell:"",row:""},paging:{active:"current",button:"dt-paging-button",container:"dt-paging",disabled:"disabled",nav:""}});var a;var n;var i;var o;var l={};var s=/[\r\n\u2028]/g;var u=/<([^>]*>)/g;var c=Math.pow(2,28);var f=/^\d{2,4}[./-]\d{1,2}[./-]\d{1,2}([T ]{1}\d{1,2}[:.]\d{2}([.:]\d{2})?)?$/;var d=new RegExp("(\\"+["/",".","*","+","?","|","(",")","[","]","{","}","\\","$","^","-"].join("|\\")+")","g");var v=/['\u00A0,$£€¥%\u2009\u202F\u20BD\u20a9\u20BArfkɃΞ]/gi;var h=function(e){return!e||e===true||e==="-"};var p=function(e){var t=parseInt(e,10);return!isNaN(t)&&isFinite(e)?t:null};var g=function(e,t){l[t]||(l[t]=new RegExp(He(t),"g"));return typeof e==="string"&&t!=="."?e.replace(/\./g,"").replace(l[t],"."):e};var m=function(e,t,r,a){var n=typeof e;var i=n==="string";if(n==="number"||n==="bigint")return true;if(a&&h(e))return true;t&&i&&(e=g(e,t));r&&i&&(e=e.replace(v,""));return!isNaN(parseFloat(e))&&isFinite(e)};var b=function(e){return h(e)||typeof e==="string"};var y=function(e,t,r,a){if(a&&h(e))return true;if(typeof e==="string"&&e.match(/<(input|select)/i))return null;var n=b(e);return n&&!!m(T(e),t,r,a)||null};var D=function(e,t,r){var a=[];var n=0,i=e.length;if(r!==void 0)for(;n<i;n++)e[n]&&e[n][t]&&a.push(e[n][t][r]);else for(;n<i;n++)e[n]&&a.push(e[n][t]);return a};var w=function(e,t,r,a){var n=[];var i=0,o=t.length;if(a!==void 0)for(;i<o;i++)e[t[i]]&&e[t[i]][r]&&n.push(e[t[i]][r][a]);else for(;i<o;i++)e[t[i]]&&n.push(e[t[i]][r]);return n};var x=function(e,t){var r=[];var a;if(t===void 0){t=0;a=e}else{a=t;t=e}for(var n=t;n<a;n++)r.push(n);return r};var S=function(e){var t=[];for(var r=0,a=e.length;r<a;r++)e[r]&&t.push(e[r]);return t};var T=function(e){if(!e||typeof e!=="string")return e;if(e.length>c)throw new Error("Exceeded max str len");var t;e=e.replace(u,"");do{t=e;e=e.replace(/<script/i,"")}while(e!==t);return t};var _=function(e){Array.isArray(e)&&(e=e.join(","));return typeof e==="string"?e.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;"):e};var C=function(e,t){if(typeof e!=="string")return e;var r=e.normalize?e.normalize("NFD"):e;return r.length!==e.length?(t===true?e+" ":"")+r.replace(/[\u0300-\u036f]/g,""):r};
/**
 * Determine if all values in the array are unique. This means we can short
 * cut the _unique method at the cost of a single loop. A sorted array is used
 * to easily check the values.
 *
 * @param  {array} src Source array
 * @return {boolean} true if all unique, false otherwise
 * @ignore
 */var I=function(e){if(e.length<2)return true;var t=e.slice().sort();var r=t[0];for(var a=1,n=t.length;a<n;a++){if(t[a]===r)return false;r=t[a]}return true};
/**
 * Find the unique elements in a source array.
 *
 * @param  {array} src Source array
 * @return {array} Array of unique items
 * @ignore
 */var L=function(e){if(Array.from&&Set)return Array.from(new Set(e));if(I(e))return e.slice();var t,r,a,n=[],i=e.length,o=0;e:for(r=0;r<i;r++){t=e[r];for(a=0;a<o;a++)if(n[a]===t)continue e;n.push(t);o++}return n};var A=function(e,t){if(Array.isArray(t))for(var r=0;r<t.length;r++)A(e,t[r]);else e.push(t);return e};function N(e,t){t&&t.split(" ").forEach((function(t){t&&e.classList.add(t)}))}r.util={
/**
	 * Return a string with diacritic characters decomposed
	 * @param {*} mixed Function or string to normalize
	 * @param {*} both Return original string and the normalized string
	 * @returns String or undefined
	 */
diacritics:function(e,t){var r=typeof e;if(r!=="function")return C(e,t);C=e},
/**
	 * Debounce a function
	 *
	 * @param {function} fn Function to be called
	 * @param {integer} freq Call frequency in mS
	 * @return {function} Wrapped function
	 */
debounce:function(e,t){var r;return function(){var a=this;var n=arguments;clearTimeout(r);r=setTimeout((function(){e.apply(a,n)}),t||250)}},
/**
	 * Throttle the calls to a function. Arguments and context are maintained
	 * for the throttled function.
	 *
	 * @param {function} fn Function to be called
	 * @param {integer} freq Call frequency in mS
	 * @return {function} Wrapped function
	 */
throttle:function(e,t){var r,a,n=t!==void 0?t:200;return function(){var t=this,i=+new Date,o=arguments;if(r&&i<r+n){clearTimeout(a);a=setTimeout((function(){r=void 0;e.apply(t,o)}),n)}else{r=i;e.apply(t,o)}}},
/**
	 * Escape a string such that it can be used in a regular expression
	 *
	 *  @param {string} val string to escape
	 *  @returns {string} escaped string
	 */
escapeRegex:function(e){return e.replace(d,"\\$1")},
/**
	 * Create a function that will write to a nested object or array
	 * @param {*} source JSON notation string
	 * @returns Write function
	 */
set:function(e){if(t.isPlainObject(e))return r.util.set(e._);if(e===null)return function(){};if(typeof e==="function")return function(t,r,a){e(t,"set",r,a)};if(typeof e!=="string"||e.indexOf(".")===-1&&e.indexOf("[")===-1&&e.indexOf("(")===-1)return function(t,r){t[e]=r};var a=function(e,t,r){var n,i=ie(r);var o=i[i.length-1];var l,s,u,c;for(var f=0,d=i.length-1;f<d;f++){if(i[f]==="__proto__"||i[f]==="constructor")throw new Error("Cannot set prototype values");l=i[f].match(ae);s=i[f].match(ne);if(l){i[f]=i[f].replace(ae,"");e[i[f]]=[];n=i.slice();n.splice(0,f+1);c=n.join(".");if(Array.isArray(t))for(var v=0,h=t.length;v<h;v++){u={};a(u,t[v],c);e[i[f]].push(u)}else e[i[f]]=t;return}if(s){i[f]=i[f].replace(ne,"");e=e[i[f]](t)}e[i[f]]!==null&&e[i[f]]!==void 0||(e[i[f]]={});e=e[i[f]]}o.match(ne)?e=e[o.replace(ne,"")](t):e[o.replace(ae,"")]=t};return function(t,r){return a(t,r,e)}},
/**
	 * Create a function that will read nested objects from arrays, based on JSON notation
	 * @param {*} source JSON notation string
	 * @returns Value read
	 */
get:function(e){if(t.isPlainObject(e)){var a={};t.each(e,(function(e,t){t&&(a[e]=r.util.get(t))}));return function(e,t,r,n){var i=a[t]||a._;return i!==void 0?i(e,t,r,n):e}}if(e===null)return function(e){return e};if(typeof e==="function")return function(t,r,a,n){return e(t,r,a,n)};if(typeof e!=="string"||e.indexOf(".")===-1&&e.indexOf("[")===-1&&e.indexOf("(")===-1)return function(t){return t[e]};var n=function(e,t,r){var a,i,o,l;if(r!==""){var s=ie(r);for(var u=0,c=s.length;u<c;u++){a=s[u].match(ae);i=s[u].match(ne);if(a){s[u]=s[u].replace(ae,"");s[u]!==""&&(e=e[s[u]]);o=[];s.splice(0,u+1);l=s.join(".");if(Array.isArray(e))for(var f=0,d=e.length;f<d;f++)o.push(n(e[f],t,l));var v=a[0].substring(1,a[0].length-1);e=v===""?o:o.join(v);break}if(i){s[u]=s[u].replace(ne,"");e=e[s[u]]()}else{if(e===null||e[s[u]]===null)return null;if(e===void 0||e[s[u]]===void 0)return;e=e[s[u]]}}}return e};return function(t,r){return n(t,r,e)}},stripHtml:function(e){var t=typeof e;if(t!=="function")return t==="string"?T(e):e;T=e},escapeHtml:function(e){var t=typeof e;if(t!=="function")return t==="string"||Array.isArray(e)?_(e):e;_=e},unique:L};
/**
 * Create a mapping object that allows camel case parameters to be looked up
 * for their Hungarian counterparts. The mapping is stored in a private
 * parameter called `_hungarianMap` which can be accessed on the source object.
 *  @param {object} o
 *  @memberof DataTable#oApi
 */function F(e){var r,a,n="a aa ai ao as b fn i m o s ",i={};t.each(e,(function(t){r=t.match(/^([^A-Z]+?)([A-Z])/);if(r&&n.indexOf(r[1]+" ")!==-1){a=t.replace(r[0],r[2].toLowerCase());i[a]=t;r[1]==="o"&&F(e[t])}}));e._hungarianMap=i}
/**
 * Convert from camel case parameters to Hungarian, based on a Hungarian map
 * created by _fnHungarianMap.
 *  @param {object} src The model object which holds all parameters that can be
 *    mapped.
 *  @param {object} user The object to convert from camel case to Hungarian.
 *  @param {boolean} force When set to `true`, properties which already have a
 *    Hungarian value in the `user` object will be overwritten. Otherwise they
 *    won't be.
 *  @memberof DataTable#oApi
 */function O(e,r,a){e._hungarianMap||F(e);var n;t.each(r,(function(i){n=e._hungarianMap[i];if(n!==void 0&&(a||r[n]===void 0))if(n.charAt(0)==="o"){r[n]||(r[n]={});t.extend(true,r[n],r[i]);O(e[n],r[n],a)}else r[n]=r[i]}))}
/**
 * Map one parameter onto another
 *  @param {object} o Object to map
 *  @param {*} knew The new parameter name
 *  @param {*} old The old parameter name
 */var R=function(e,t,r){e[t]!==void 0&&(e[r]=e[t])};
/**
 * Provide backwards compatibility for the main DT options. Note that the new
 * options are mapped onto the old parameters, so this is an external interface
 * change only.
 *  @param {object} init Object to map
 */function j(e){R(e,"ordering","bSort");R(e,"orderMulti","bSortMulti");R(e,"orderClasses","bSortClasses");R(e,"orderCellsTop","bSortCellsTop");R(e,"order","aaSorting");R(e,"orderFixed","aaSortingFixed");R(e,"paging","bPaginate");R(e,"pagingType","sPaginationType");R(e,"pageLength","iDisplayLength");R(e,"searching","bFilter");typeof e.sScrollX==="boolean"&&(e.sScrollX=e.sScrollX?"100%":"");typeof e.scrollX==="boolean"&&(e.scrollX=e.scrollX?"100%":"");if(typeof e.bSort==="object"){e.orderIndicators=e.bSort.indicators===void 0||e.bSort.indicators;e.orderHandler=e.bSort.handler===void 0||e.bSort.handler;e.bSort=true}else if(e.bSort===false){e.orderIndicators=false;e.orderHandler=false}else if(e.bSort===true){e.orderIndicators=true;e.orderHandler=true}typeof e.bSortCellsTop==="boolean"&&(e.titleRow=e.bSortCellsTop);var t=e.aoSearchCols;if(t)for(var a=0,n=t.length;a<n;a++)t[a]&&O(r.models.oSearch,t[a]);e.serverSide&&!e.searchDelay&&(e.searchDelay=400)}
/**
 * Provide backwards compatibility for column options. Note that the new options
 * are mapped onto the old parameters, so this is an external interface change
 * only.
 *  @param {object} init Object to map
 */function P(e){R(e,"orderable","bSortable");R(e,"orderData","aDataSort");R(e,"orderSequence","asSorting");R(e,"orderDataType","sortDataType");var t=e.aDataSort;typeof t!=="number"||Array.isArray(t)||(e.aDataSort=[t])}
/**
 * Browser feature detection for capabilities, quirks
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function E(e){if(!r.__browser){var a={};r.__browser=a;var n=t("<div/>").css({position:"fixed",top:0,left:-1*window.pageXOffset,height:1,width:1,overflow:"hidden"}).append(t("<div/>").css({position:"absolute",top:1,left:1,width:100,overflow:"scroll"}).append(t("<div/>").css({width:"100%",height:10}))).appendTo("body");var i=n.children();var o=i.children();a.barWidth=i[0].offsetWidth-i[0].clientWidth;a.bScrollbarLeft=Math.round(o.offset().left)!==1;n.remove()}t.extend(e.oBrowser,r.__browser);e.oScroll.iBarWidth=r.__browser.barWidth}
/**
 * Add a column to the list used for the table with default values
 *  @param {object} oSettings dataTables settings object
 *  @memberof DataTable#oApi
 */function k(e){var a=r.defaults.column;var n=e.aoColumns.length;var i=t.extend({},r.models.oColumn,a,{aDataSort:a.aDataSort?a.aDataSort:[n],mData:a.mData?a.mData:n,idx:n,searchFixed:{},colEl:t("<col>").attr("data-dt-column",n)});e.aoColumns.push(i);var o=e.aoPreSearchCols;o[n]=t.extend({},r.models.oSearch,o[n])}
/**
 * Apply options for a column
 *  @param {object} oSettings dataTables settings object
 *  @param {int} iCol column index to consider
 *  @param {object} oOptions object with sType, bVisible and bSearchable etc
 *  @memberof DataTable#oApi
 */function M(e,a,n){var i=e.aoColumns[a];if(n!==void 0&&n!==null){P(n);O(r.defaults.column,n,true);n.mDataProp===void 0||n.mData||(n.mData=n.mDataProp);n.sType&&(i._sManualType=n.sType);n.className&&!n.sClass&&(n.sClass=n.className);var o=i.sClass;t.extend(i,n);gt(i,n,"sWidth","sWidthOrig");o!==i.sClass&&(i.sClass=o+" "+i.sClass);n.iDataSort!==void 0&&(i.aDataSort=[n.iDataSort]);gt(i,n,"aDataSort")}var l=i.mData;var s=oe(l);if(i.mRender&&Array.isArray(i.mRender)){var u=i.mRender.slice();var c=u.shift();i.mRender=r.render[c].apply(window,u)}i._render=i.mRender?oe(i.mRender):null;var f=function(e){return typeof e==="string"&&e.indexOf("@")!==-1};i._bAttrSrc=t.isPlainObject(l)&&(f(l.sort)||f(l.type)||f(l.filter));i._setter=null;i.fnGetData=function(e,t,r){var a=s(e,t,void 0,r);return i._render&&t?i._render(a,t,e,r):a};i.fnSetData=function(e,t,r){return le(l)(e,t,r)};typeof l==="number"||i._isArrayHost||(e._rowReadObject=true);e.oFeatures.bSort||(i.bSortable=false)}
/**
 * Adjust the table column widths for new data. Note: you would probably want to
 * do a redraw after calling this function!
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function H(e){Ke(e);W(e);var t=e.oScroll;t.sY===""&&t.sX===""||Ze(e);Dt(e,null,"column-sizing",[e])}
/**
 * Apply column sizes
 *
 * @param {*} settings DataTables settings object
 */function W(e){var t=e.aoColumns;for(var r=0;r<t.length;r++){var a=J(e,[r],false,false);t[r].colEl.css("width",a);e.oScroll.sX&&t[r].colEl.css("min-width",a)}}
/**
 * Convert the index of a visible column to the index in the data array (take account
 * of hidden columns)
 *  @param {object} oSettings dataTables settings object
 *  @param {int} iMatch Visible column index to lookup
 *  @returns {int} i the data index
 *  @memberof DataTable#oApi
 */function X(e,t){var r=q(e,"bVisible");return typeof r[t]==="number"?r[t]:null}
/**
 * Convert the index of an index in the data array and convert it to the visible
 *   column index (take account of hidden columns)
 *  @param {int} iMatch Column index to lookup
 *  @param {object} oSettings dataTables settings object
 *  @returns {int} i the data index
 *  @memberof DataTable#oApi
 */function V(e,t){var r=q(e,"bVisible");var a=r.indexOf(t);return a!==-1?a:null}
/**
 * Get the number of visible columns
 *  @param {object} oSettings dataTables settings object
 *  @returns {int} i the number of visible columns
 *  @memberof DataTable#oApi
 */function B(e){var r=e.aoHeader;var a=e.aoColumns;var n=0;if(r.length)for(var i=0,o=r[0].length;i<o;i++)a[i].bVisible&&t(r[0][i].cell).css("display")!=="none"&&n++;return n}
/**
 * Get an array of column indexes that match a given property
 *  @param {object} oSettings dataTables settings object
 *  @param {string} sParam Parameter in aoColumns to look for - typically
 *    bVisible or bSearchable
 *  @returns {array} Array of indexes with matched properties
 *  @memberof DataTable#oApi
 */function q(e,t){var r=[];e.aoColumns.map((function(e,a){e[t]&&r.push(a)}));return r}
/**
 * Allow the result from a type detection function to be `true` while
 * translating that into a string. Old type detection functions will
 * return the type name if it passes. An obect store would be better,
 * but not backwards compatible.
 *
 * @param {*} typeDetect Object or function for type detection
 * @param {*} res Result from the type detection function
 * @returns Type name or false
 */function U(e,t){return t===true?e._name:t}
/**
 * Calculate the 'type' of a column
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function z(e){var t=e.aoColumns;var n=e.aoData;var i=r.ext.type.detect;var o,l,s,u,c,f;var d,v,p;for(o=0,l=t.length;o<l;o++){d=t[o];p=[];if(!d.sType&&d._sManualType)d.sType=d._sManualType;else if(!d.sType){if(!e.typeDetect)return;for(s=0,u=i.length;s<u;s++){var g=i[s];var m=g.oneOf;var b=g.allOf||g;var y=g.init;var D=false;v=null;if(y){v=U(g,y(e,d,o));if(v){d.sType=v;break}}for(c=0,f=n.length;c<f;c++)if(n[c]){p[c]===void 0&&(p[c]=ee(e,c,o,"type"));m&&!D&&(D=U(g,m(p[c],e)));v=U(g,b(p[c],e));if(!v&&s!==i.length-3)break;if(v==="html"&&!h(p[c]))break}if(m&&D&&v||!m&&v){d.sType=v;break}}d.sType||(d.sType="string")}var w=a.type.className[d.sType];if(w){Y(e.aoHeader,o,w);Y(e.aoFooter,o,w)}var x=a.type.render[d.sType];if(x&&!d._render){d._render=r.util.get(x);$(e,o)}}}function $(e,t){var r=e.aoData;for(var a=0;a<r.length;a++)if(r[a].nTr){var n=ee(e,a,t,"display");r[a].displayData[t]=n;re(r[a].anCells[t],n)}}function Y(e,t,r){e.forEach((function(e){e[t]&&e[t].unique&&N(e[t].cell,r)}))}
/**
 * Take the column definitions and static columns arrays and calculate how
 * they relate to column indexes. The callback function will then apply the
 * definition found for a column to a suitable configuration object.
 *  @param {object} oSettings dataTables settings object
 *  @param {array} aoColDefs The aoColumnDefs array that is to be applied
 *  @param {array} aoCols The aoColumns array that defines columns individually
 *  @param {array} headerLayout Layout for header as it was loaded
 *  @param {function} fn Callback function - takes two parameters, the calculated
 *    column index and the definition for that column.
 *  @memberof DataTable#oApi
 */function G(e,r,a,n,i){var o,l,s,u,c,f,d;var v=e.aoColumns;if(a)for(o=0,l=a.length;o<l;o++)a[o]&&a[o].name&&(v[o].sName=a[o].name);if(r)for(o=r.length-1;o>=0;o--){d=r[o];var h=d.target!==void 0?d.target:d.targets!==void 0?d.targets:d.aTargets;Array.isArray(h)||(h=[h]);for(s=0,u=h.length;s<u;s++){var p=h[s];if(typeof p==="number"&&p>=0){while(v.length<=p)k(e);i(p,d)}else if(typeof p==="number"&&p<0)i(v.length+p,d);else if(typeof p==="string")for(c=0,f=v.length;c<f;c++)p==="_all"?i(c,d):p.indexOf(":name")!==-1?v[c].sName===p.replace(":name","")&&i(c,d):n.forEach((function(e){if(e[c]){var r=t(e[c].cell);p.match(/^[a-z][\w-]*$/i)&&(p="."+p);r.is(p)&&i(c,d)}}))}}if(a)for(o=0,l=a.length;o<l;o++)i(o,a[o])}
/**
 * Get the width for a given set of columns
 *
 * @param {*} settings DataTables settings object
 * @param {*} targets Columns - comma separated string or array of numbers
 * @param {*} original Use the original width (true) or calculated (false)
 * @param {*} incVisible Include visible columns (true) or not (false)
 * @returns Combined CSS value
 */function J(e,t,r,a){Array.isArray(t)||(t=Z(t));var n=0;var i;var o=e.aoColumns;for(var l=0,s=t.length;l<s;l++){var u=o[t[l]];var c=r?u.sWidthOrig:u.sWidth;if(a||u.bVisible!==false){if(c===null||c===void 0)return null;if(typeof c==="number"){i="px";n+=c}else{var f=c.match(/([\d\.]+)([^\d]*)/);if(f){n+=f[1]*1;i=f.length===3?f[2]:"px"}}}}return n+i}function Z(e){var r=t(e).closest("[data-dt-column]").attr("data-dt-column");return r?r.split(",").map((function(e){return e*1})):[]}
/**
 * Add a data array to the table, creating DOM node etc. This is the parallel to
 * _fnGatherData, but for adding rows from a Javascript source, rather than a
 * DOM source.
 *  @param {object} settings dataTables settings object
 *  @param {array} data data array to be added
 *  @param {node} [tr] TR element to add to the table - optional. If not given,
 *    DataTables will create a row automatically
 *  @param {array} [tds] Array of TD|TH elements for the row - must be given
 *    if nTr is.
 *  @returns {int} >=0 if successful (index of new aoData entry), -1 if failed
 *  @memberof DataTable#oApi
 */function K(e,a,n,i){var o=e.aoData.length;var l=t.extend(true,{},r.models.oRow,{src:n?"dom":"data",idx:o});l._aData=a;e.aoData.push(l);var s=e.aoColumns;for(var u=0,c=s.length;u<c;u++)s[u].sType=null;e.aiDisplayMaster.push(o);var f=e.rowIdFn(a);f!==void 0&&(e.aIds[f]=l);!n&&e.oFeatures.bDeferRender||ve(e,o,n,i);return o}
/**
 * Add one or more TR elements to the table. Generally we'd expect to
 * use this for reading data from a DOM sourced table, but it could be
 * used for an TR element. Note that if a TR is given, it is used (i.e.
 * it is not cloned).
 *  @param {object} settings dataTables settings object
 *  @param {array|node|jQuery} trs The TR element(s) to add to the table
 *  @returns {array} Array of indexes for the added rows
 *  @memberof DataTable#oApi
 */function Q(e,r){var a;r instanceof t||(r=t(r));return r.map((function(t,r){a=fe(e,r);return K(e,a.data,r,a.cells)}))}
/**
 * Get the data for a given cell from the internal cache, taking into account data mapping
 *  @param {object} settings dataTables settings object
 *  @param {int} rowIdx aoData row id
 *  @param {int} colIdx Column index
 *  @param {string} type data get type ('display', 'type' 'filter|search' 'sort|order')
 *  @returns {*} Cell data
 *  @memberof DataTable#oApi
 */function ee(e,t,a,n){n==="search"?n="filter":n==="order"&&(n="sort");var i=e.aoData[t];if(i){var o=e.iDraw;var l=e.aoColumns[a];var s=i._aData;var u=l.sDefaultContent;var c=l.fnGetData(s,n,{settings:e,row:t,col:a});n!=="display"&&c&&typeof c==="object"&&c.nodeName&&(c=c.innerHTML);if(c===void 0){if(e.iDrawError!=o&&u===null){pt(e,0,"Requested unknown parameter "+(typeof l.mData=="function"?"{function}":"'"+l.mData+"'")+" for row "+t+", column "+a,4);e.iDrawError=o}return u}if(c!==s&&c!==null||u===null||n===void 0){if(typeof c==="function")return c.call(s)}else c=u;if(c===null&&n==="display")return"";if(n==="filter"){var f=r.ext.type.search;f[l.sType]&&(c=f[l.sType](c))}return c}}
/**
 * Set the value for a specific cell, into the internal data cache
 *  @param {object} settings dataTables settings object
 *  @param {int} rowIdx aoData row id
 *  @param {int} colIdx Column index
 *  @param {*} val Value to set
 *  @memberof DataTable#oApi
 */function te(e,t,r,a){var n=e.aoColumns[r];var i=e.aoData[t]._aData;n.fnSetData(i,a,{settings:e,row:t,col:r})}
/**
 * Write a value to a cell
 * @param {*} td Cell
 * @param {*} val Value
 */function re(e,r){r&&typeof r==="object"&&r.nodeName?t(e).empty().append(r):e.innerHTML=r}var ae=/\[.*?\]$/;var ne=/\(\)$/;
/**
 * Split string on periods, taking into account escaped periods
 * @param  {string} str String to split
 * @return {array} Split string
 */function ie(e){var t=e.match(/(\\.|[^.])+/g)||[""];return t.map((function(e){return e.replace(/\\\./g,".")}))}
/**
 * Return a function that can be used to get data from a source object, taking
 * into account the ability to use nested objects as a source
 *  @param {string|int|function} mSource The data source for the object
 *  @returns {function} Data get function
 *  @memberof DataTable#oApi
 */var oe=r.util.get;
/**
 * Return a function that can be used to set data from a source object, taking
 * into account the ability to use nested objects as a source
 *  @param {string|int|function} mSource The data source for the object
 *  @returns {function} Data set function
 *  @memberof DataTable#oApi
 */var le=r.util.set;
/**
 * Return an array with the full table data
 *  @param {object} oSettings dataTables settings object
 *  @returns array {array} aData Master data array
 *  @memberof DataTable#oApi
 */function se(e){return D(e.aoData,"_aData")}
/**
 * Nuke the table
 *  @param {object} oSettings dataTables settings object
 *  @memberof DataTable#oApi
 */function ue(e){e.aoData.length=0;e.aiDisplayMaster.length=0;e.aiDisplay.length=0;e.aIds={}}
/**
 * Mark cached data as invalid such that a re-read of the data will occur when
 * the cached data is next requested. Also update from the data source object.
 *
 * @param {object} settings DataTables settings object
 * @param {int}    rowIdx   Row index to invalidate
 * @param {string} [src]    Source to invalidate from: undefined, 'auto', 'dom'
 *     or 'data'
 * @param {int}    [colIdx] Column index to invalidate. If undefined the whole
 *     row will be invalidated
 * @memberof DataTable#oApi
 *
 * @todo For the modularisation of v1.11 this will need to become a callback, so
 *   the sort and filter methods can subscribe to it. That will required
 *   initialisation options for sorting, which is why it is not already baked in
 */function ce(e,t,r,a){var n=e.aoData[t];var i,o;n._aSortData=null;n._aFilterData=null;n.displayData=null;if(r!=="dom"&&(r&&r!=="auto"||n.src!=="dom")){var l=n.anCells;var s=de(e,t);if(l)if(a!==void 0)re(l[a],s[a]);else for(i=0,o=l.length;i<o;i++)re(l[i],s[i])}else n._aData=fe(e,n,a,a===void 0?void 0:n._aData).data;var u=e.aoColumns;if(a!==void 0){u[a].sType=null;u[a].maxLenString=null}else{for(i=0,o=u.length;i<o;i++){u[i].sType=null;u[i].maxLenString=null}he(e,n)}}
/**
 * Build a data source object from an HTML row, reading the contents of the
 * cells that are in the row.
 *
 * @param {object} settings DataTables settings object
 * @param {node|object} TR element from which to read data or existing row
 *   object from which to re-read the data from the cells
 * @param {int} [colIdx] Optional column index
 * @param {array|object} [d] Data source object. If `colIdx` is given then this
 *   parameter should also be given and will be used to write the data into.
 *   Only the column in question will be written
 * @returns {object} Object with two parameters: `data` the data read, in
 *   document order, and `cells` and array of nodes (they can be useful to the
 *   caller, so rather than needing a second traversal to get them, just return
 *   them from here).
 * @memberof DataTable#oApi
 */function fe(e,t,r,a){var n,i,o,l=[],s=t.firstChild,u=0,c=e.aoColumns,f=e._rowReadObject;a=a!==void 0?a:f?{}:[];var d=function(e,t){if(typeof e==="string"){var r=e.indexOf("@");if(r!==-1){var n=e.substring(r+1);var i=le(e);i(a,t.getAttribute(n))}}};var v=function(e){if(r===void 0||r===u){i=c[u];o=e.innerHTML.trim();if(i&&i._bAttrSrc){var t=le(i.mData._);t(a,o);d(i.mData.sort,e);d(i.mData.type,e);d(i.mData.filter,e)}else if(f){i._setter||(i._setter=le(i.mData));i._setter(a,o)}else a[u]=o}u++};if(s)while(s){n=s.nodeName.toUpperCase();if(n=="TD"||n=="TH"){v(s);l.push(s)}s=s.nextSibling}else{l=t.anCells;for(var h=0,p=l.length;h<p;h++)v(l[h])}var g=t.firstChild?t:t.nTr;if(g){var m=g.getAttribute("id");m&&le(e.rowId)(a,m)}return{data:a,cells:l}}
/**
 * Render and cache a row's display data for the columns, if required
 * @returns 
 */function de(e,t){var r=e.aoData[t];var a=e.aoColumns;if(!r.displayData){r.displayData=[];for(var n=0,i=a.length;n<i;n++)r.displayData.push(ee(e,t,n,"display"))}return r.displayData}
/**
 * Create a new TR element (and it's TD children) for a row
 *  @param {object} oSettings dataTables settings object
 *  @param {int} iRow Row to consider
 *  @param {node} [nTrIn] TR element to add to the table - optional. If not given,
 *    DataTables will create a row automatically
 *  @param {array} [anTds] Array of TD|TH elements for the row - must be given
 *    if nTr is.
 *  @memberof DataTable#oApi
 */function ve(e,r,a,n){var i,o,l,s,u,c,f=e.aoData[r],d=f._aData,v=[],h=e.oClasses.tbody.row;if(f.nTr===null){i=a||document.createElement("tr");f.nTr=i;f.anCells=v;N(i,h);i._DT_RowIndex=r;he(e,f);for(s=0,u=e.aoColumns.length;s<u;s++){l=e.aoColumns[s];c=!a||!n[s];o=c?document.createElement(l.sCellType):n[s];o||pt(e,0,"Incorrect column count",18);o._DT_CellIndex={row:r,column:s};v.push(o);var p=de(e,r);!c&&(!l.mRender&&l.mData===s||t.isPlainObject(l.mData)&&l.mData._===s+".display")||re(o,p[s]);N(o,l.sClass);l.bVisible&&c?i.appendChild(o):l.bVisible||c||o.parentNode.removeChild(o);l.fnCreatedCell&&l.fnCreatedCell.call(e.oInstance,o,ee(e,r,s),d,r,s)}Dt(e,"aoRowCreatedCallback","row-created",[i,d,r,v])}else N(f.nTr,h)}
/**
 * Add attributes to a row based on the special `DT_*` parameters in a data
 * source object.
 *  @param {object} settings DataTables settings object
 *  @param {object} DataTables row object for the row to be modified
 *  @memberof DataTable#oApi
 */function he(e,r){var a=r.nTr;var n=r._aData;if(a){var i=e.rowIdFn(n);i&&(a.id=i);if(n.DT_RowClass){var o=n.DT_RowClass.split(" ");r.__rowc=r.__rowc?L(r.__rowc.concat(o)):o;t(a).removeClass(r.__rowc.join(" ")).addClass(n.DT_RowClass)}n.DT_RowAttr&&t(a).attr(n.DT_RowAttr);n.DT_RowData&&t(a).data(n.DT_RowData)}}
/**
 * Create the HTML header for the table
 *  @param {object} oSettings dataTables settings object
 *  @memberof DataTable#oApi
 */function pe(e,r){var a=e.oClasses;var n=e.aoColumns;var i,o,l;var s=r==="header"?e.nTHead:e.nTFoot;var u=r==="header"?"sTitle":r;if(s){if(r==="header"||D(e.aoColumns,u).join("")){l=t("tr",s);l.length||(l=t("<tr/>").appendTo(s));if(l.length===1){var c=0;t("td, th",l).each((function(){c+=this.colSpan}));for(i=c,o=n.length;i<o;i++)t("<th/>").html(n[i][u]||"").appendTo(l)}}var f=Ie(e,s,true);if(r==="header"){e.aoHeader=f;t("tr",s).addClass(a.thead.row)}else{e.aoFooter=f;t("tr",s).addClass(a.tfoot.row)}t(s).children("tr").children("th, td").each((function(){xt(e,r)(e,t(this),a)}))}}
/**
 * Build a layout structure for a header or footer
 *
 * @param {*} settings DataTables settings
 * @param {*} source Source layout array
 * @param {*} incColumns What columns should be included
 * @returns Layout array in column index order
 */function ge(e,r,a){var n,i,o;var l=[];var s=[];var u=e.aoColumns;var c=u.length;var f,d;if(r){a||(a=x(c).filter((function(e){return u[e].bVisible})));for(n=0;n<r.length;n++){l[n]=r[n].slice().filter((function(e,t){return a.includes(t)}));s.push([])}for(n=0;n<l.length;n++)for(i=0;i<l[n].length;i++){f=1;d=1;if(s[n][i]===void 0){o=l[n][i].cell;while(l[n+f]!==void 0&&l[n][i].cell==l[n+f][i].cell){s[n+f][i]=null;f++}while(l[n][i+d]!==void 0&&l[n][i].cell==l[n][i+d].cell){for(var v=0;v<f;v++)s[n+v][i+d]=null;d++}var h=t("span.dt-column-title",o);s[n][i]={cell:o,colspan:d,rowspan:f,title:h.length?h.html():t(o).html()}}}return s}}
/**
 * Draw the header (or footer) element based on the column visibility states.
 *
 *  @param object oSettings dataTables settings object
 *  @param array aoSource Layout array from _fnDetectHeader
 *  @memberof DataTable#oApi
 */function me(e,r){var a=ge(e,r);var n,i;for(var o=0;o<r.length;o++){n=r[o].row;if(n)while(i=n.firstChild)n.removeChild(i);for(var l=0;l<a[o].length;l++){var s=a[o][l];s&&t(s.cell).appendTo(n).attr("rowspan",s.rowspan).attr("colspan",s.colspan)}}}
/**
 * Insert the required TR nodes into the table for display
 *  @param {object} oSettings dataTables settings object
 *  @param ajaxComplete true after ajax call to complete rendering
 *  @memberof DataTable#oApi
 */function be(e,r){Le(e);var n=Dt(e,"aoPreDrawCallback","preDraw",[e]);if(n.indexOf(false)===-1){var i=[];var o=0;var l=St(e)=="ssp";var s=e.aiDisplay;var u=e._iDisplayStart;var c=e.fnDisplayEnd();var f=e.aoColumns;var d=t(e.nTBody);e.bDrawing=true;if(e.deferLoading){e.deferLoading=false;e.iDraw++;Ye(e,false)}else if(l){if(!e.bDestroying&&!r){e.iDraw===0&&d.empty().append(De(e));Ne(e);return}}else e.iDraw++;if(s.length!==0){var v=l?0:u;var h=l?e.aoData.length:c;for(var p=v;p<h;p++){var g=s[p];var m=e.aoData[g];m.nTr===null&&ve(e,g);var b=m.nTr;for(var y=0;y<f.length;y++){var D=f[y];var w=m.anCells[y];N(w,a.type.className[D.sType]);N(w,e.oClasses.tbody.cell)}Dt(e,"aoRowCallback",null,[b,m._aData,o,p,g]);i.push(b);o++}}else i[0]=De(e);Dt(e,"aoHeaderCallback","header",[t(e.nTHead).children("tr")[0],se(e),u,c,s]);Dt(e,"aoFooterCallback","footer",[t(e.nTFoot).children("tr")[0],se(e),u,c,s]);if(d[0].replaceChildren)d[0].replaceChildren.apply(d[0],i);else{d.children().detach();d.append(t(i))}t(e.nTableWrapper).toggleClass("dt-empty-footer",t("tr",e.nTFoot).length===0);Dt(e,"aoDrawCallback","draw",[e],true);e.bSorted=false;e.bFiltered=false;e.bDrawing=false}else Ye(e,false)}
/**
 * Redraw the table - taking account of the various features which are enabled
 *  @param {object} oSettings dataTables settings object
 *  @param {boolean} [holdPosition] Keep the current paging position. By default
 *    the paging is reset to the first page
 *  @memberof DataTable#oApi
 */function ye(e,t,r){var a=e.oFeatures,n=a.bSort,i=a.bFilter;if(r===void 0||r===true){z(e);n&&st(e);i?Pe(e,e.oPreviousSearch):e.aiDisplay=e.aiDisplayMaster.slice()}t!==true&&(e._iDisplayStart=0);e._drawHold=t;be(e);e.api.one("draw",(function(){e._drawHold=false}))}function De(e){var r=e.oLanguage;var a=r.sZeroRecords;var n=St(e);n!=="ssp"&&n!=="ajax"||e.json?r.sEmptyTable&&e.fnRecordsTotal()===0&&(a=r.sEmptyTable):a=r.sLoadingRecords;return t("<tr/>").append(t("<td />",{colSpan:B(e),class:e.oClasses.empty.row}).html(a))[0]}function we(e,r,a){if(Array.isArray(a))for(var n=0;n<a.length;n++)we(e,r,a[n]);else{var i=e[r];if(t.isPlainObject(a))if(a.features){a.rowId&&(e.id=a.rowId);a.rowClass&&(e.className=a.rowClass);i.id=a.id;i.className=a.className;we(e,r,a.features)}else Object.keys(a).map((function(e){i.contents.push({feature:e,opts:a[e]})}));else i.contents.push(a)}}function xe(e,t,r){var a;for(var n=0;n<e.length;n++){a=e[n];if(a.rowNum===t&&(r==="full"&&a.full||(r==="start"||r==="end")&&(a.start||a.end))){a[r]||(a[r]={contents:[]});return a}}a={rowNum:t};a[r]={contents:[]};e.push(a);return a}
/**
 * Convert a `layout` object given by a user to the object structure needed
 * for the renderer. This is done twice, once for above and once for below
 * the table. Ordering must also be considered.
 *
 * @param {*} settings DataTables settings object
 * @param {*} layout Layout object to convert
 * @param {string} side `top` or `bottom`
 * @returns Converted array structure - one item for each row.
 */function Se(e,r,a){var n=[];t.each(r,(function(e,t){if(t!==null){var r=e.match(/^([a-z]+)([0-9]*)([A-Za-z]*)$/);var i=r[2]?r[2]*1:0;var o=r[3]?r[3].toLowerCase():"full";if(r[1]===a){var l=xe(n,i,o);we(l,o,t)}}}));n.sort((function(e,t){var r=e.rowNum;var n=t.rowNum;if(r===n){var i=e.full&&!t.full?-1:1;return a==="bottom"?i*-1:i}return n-r}));a==="bottom"&&n.reverse();for(var i=0;i<n.length;i++){delete n[i].rowNum;Te(e,n[i])}return n}
/**
 * Convert the contents of a row's layout object to nodes that can be inserted
 * into the document by a renderer. Execute functions, look up plug-ins, etc.
 *
 * @param {*} settings DataTables settings object
 * @param {*} row Layout object for this row
 */function Te(e,r){var n=function(t,r){a.features[t]||pt(e,0,"Unknown feature: "+t);return a.features[t].apply(this,[e,r])};var i=function(a){if(r[a]){var i=r[a].contents;for(var o=0,l=i.length;o<l;o++)if(i[o])if(typeof i[o]==="string")i[o]=n(i[o],null);else if(t.isPlainObject(i[o]))i[o]=n(i[o].feature,i[o].opts);else if(typeof i[o].node==="function")i[o]=i[o].node(e);else if(typeof i[o]==="function"){var s=i[o](e);i[o]=typeof s.node==="function"?s.node():s}}};i("start");i("end");i("full")}
/**
 * Add the options to the page HTML for the table
 *  @param {object} settings DataTables settings object
 *  @memberof DataTable#oApi
 */function _e(e){var r=e.oClasses;var a=t(e.nTable);var n=t("<div/>").attr({id:e.sTableId+"_wrapper",class:r.container}).insertBefore(a);e.nTableWrapper=n[0];if(e.sDom)Ce(e,e.sDom,n);else{var i=Se(e,e.layout,"top");var o=Se(e,e.layout,"bottom");var l=xt(e,"layout");i.forEach((function(t){l(e,n,t)}));l(e,n,{full:{table:true,contents:[Je(e)]}});o.forEach((function(t){l(e,n,t)}))}$e(e)}
/**
 * Draw the table with the legacy DOM property
 * @param {*} settings DT settings object
 * @param {*} dom DOM string
 * @param {*} insert Insert point
 */function Ce(e,a,n){var i=a.match(/(".*?")|('.*?')|./g);var o,l,s,u,c;for(var f=0;f<i.length;f++){o=null;l=i[f];if(l=="<"){s=t("<div/>");u=i[f+1];if(u[0]=="'"||u[0]=='"'){c=u.replace(/['"]/g,"");var d,v="";if(c.indexOf(".")!=-1){var h=c.split(".");v=h[0];d=h[1]}else c[0]=="#"?v=c:d=c;s.attr("id",v.substring(1)).addClass(d);f++}n.append(s);n=s}else l==">"?n=n.parent():l=="t"?o=Je(e):r.ext.feature.forEach((function(t){l==t.cFeature&&(o=t.fnInit(e))}));o&&n.append(o)}}
/**
 * Use the DOM source to create up an array of header cells. The idea here is to
 * create a layout grid (array) of rows x columns, which contains a reference
 * to the cell that that point in the grid (regardless of col/rowspan), such that
 * any column / row could be removed and the new grid constructed
 *  @param {node} thead The header/footer element for the table
 *  @returns {array} Calculated layout array
 *  @memberof DataTable#oApi
 */function Ie(e,r,a){var n=e.aoColumns;var i=t(r).children("tr");var o,l;var s,u,c,f,d,v,h,p;var g=e.titleRow;var m=r&&r.nodeName.toLowerCase()==="thead";var b=[];var y;var D=function(e,t,r){var a=e[t];while(a[r])r++;return r};for(s=0,f=i.length;s<f;s++)b.push([]);for(s=0,f=i.length;s<f;s++){o=i[s];v=0;l=o.firstChild;while(l){if(l.nodeName.toUpperCase()=="TD"||l.nodeName.toUpperCase()=="TH"){var w=[];var x=t(l);h=l.getAttribute("colspan")*1;p=l.getAttribute("rowspan")*1;h=h&&h!==0&&h!==1?h:1;p=p&&p!==0&&p!==1?p:1;d=D(b,s,v);y=h===1;if(a){if(y){M(e,d,x.data());var S=n[d];var _=l.getAttribute("width")||null;var C=l.style.width.match(/width:\s*(\d+[pxem%]+)/);C&&(_=C[1]);S.sWidthOrig=S.sWidth||_;if(m){S.sTitle===null||S.autoTitle||(g===true&&s===0||g===false&&s===i.length-1||g===s||g===null)&&(l.innerHTML=S.sTitle);if(!S.sTitle&&y){S.sTitle=T(l.innerHTML);S.autoTitle=true}}else S.footer&&(l.innerHTML=S.footer);S.ariaTitle||(S.ariaTitle=x.attr("aria-label")||S.sTitle);S.className&&x.addClass(S.className)}t("span.dt-column-title",l).length===0&&t("<span>").addClass("dt-column-title").append(l.childNodes).appendTo(l);e.orderIndicators&&m&&x.filter(":not([data-dt-order=disable])").length!==0&&x.parent(":not([data-dt-order=disable])").length!==0&&t("span.dt-column-order",l).length===0&&t("<span>").addClass("dt-column-order").appendTo(l);var I=m?"header":"footer";t("span.dt-column-"+I,l).length===0&&t("<div>").addClass("dt-column-"+I).append(l.childNodes).appendTo(l)}for(c=0;c<h;c++){for(u=0;u<p;u++){b[s+u][d+c]={cell:l,unique:y};b[s+u].row=o}w.push(d+c)}l.setAttribute("data-dt-column",L(w).join(","))}l=l.nextSibling}}return b}
/**
 * Set the start position for draw
 *  @param {object} oSettings dataTables settings object
 */function Le(e){var t=St(e)=="ssp";var r=e.iInitDisplayStart;if(r!==void 0&&r!==-1){e._iDisplayStart=t?r:r>=e.fnRecordsDisplay()?0:r;e.iInitDisplayStart=-1}}
/**
 * Create an Ajax call based on the table's settings, taking into account that
 * parameters can have multiple forms, and backwards compatibility.
 *
 * @param {object} oSettings dataTables settings object
 * @param {array} data Data to send to the server, required by
 *     DataTables - may be augmented by developer callbacks
 * @param {function} fn Callback function to run when data is obtained
 */function Ae(e,a,n){var i;var o=e.ajax;var l=e.oInstance;var s=function(t){var r=e.jqXHR?e.jqXHR.status:null;if(t===null||typeof r==="number"&&r==204){t={};Re(e,t,[])}var a=t.error||t.sError;a&&pt(e,0,a);if(t.d&&typeof t.d==="string")try{t=JSON.parse(t.d)}catch(e){}e.json=t;Dt(e,null,"xhr",[e,t,e.jqXHR],true);n(t)};if(t.isPlainObject(o)&&o.data){i=o.data;var u=typeof i==="function"?i(a,e):i;a=typeof i==="function"&&u?u:t.extend(true,a,u);delete o.data}var c={url:typeof o==="string"?o:"",data:a,success:s,dataType:"json",cache:false,type:e.sServerMethod,error:function(t,r){var a=Dt(e,null,"xhr",[e,null,e.jqXHR],true);a.indexOf(true)===-1&&(r=="parsererror"?pt(e,0,"Invalid JSON response",1):t.readyState===4&&pt(e,0,"Ajax error",7));Ye(e,false)}};t.isPlainObject(o)&&t.extend(c,o);e.oAjaxData=a;Dt(e,null,"preXhr",[e,a,c],true);c.submitAs==="json"&&typeof a==="object"&&(c.data=JSON.stringify(a));if(typeof o==="function")e.jqXHR=o.call(l,a,s,e);else if(o.url===""){var f={};r.util.set(o.dataSrc)(f,[]);s(f)}else e.jqXHR=t.ajax(c);i&&(o.data=i)}
/**
 * Update the table using an Ajax call
 *  @param {object} settings dataTables settings object
 *  @returns {boolean} Block the table drawing or not
 *  @memberof DataTable#oApi
 */function Ne(e){e.iDraw++;Ye(e,true);Ae(e,Fe(e),(function(t){Oe(e,t)}))}
/**
 * Build up the parameters in an object needed for a server-side processing
 * request.
 *  @param {object} oSettings dataTables settings object
 *  @returns {bool} block the table drawing or not
 *  @memberof DataTable#oApi
 */function Fe(e){var t=e.aoColumns,r=e.oFeatures,a=e.oPreviousSearch,n=e.aoPreSearchCols,i=function(e,r){return typeof t[e][r]==="function"?"function":t[e][r]};return{draw:e.iDraw,columns:t.map((function(e,t){return{data:i(t,"mData"),name:e.sName,searchable:e.bSearchable,orderable:e.bSortable,search:{value:n[t].search,regex:n[t].regex,fixed:Object.keys(e.searchFixed).map((function(t){return{name:t,term:e.searchFixed[t].toString()}}))}}})),order:lt(e).map((function(e){return{column:e.col,dir:e.dir,name:i(e.col,"sName")}})),start:e._iDisplayStart,length:r.bPaginate?e._iDisplayLength:-1,search:{value:a.search,regex:a.regex,fixed:Object.keys(e.searchFixed).map((function(t){return{name:t,term:e.searchFixed[t].toString()}}))}}}
/**
 * Data the data from the server (nuking the old) and redraw the table
 *  @param {object} oSettings dataTables settings object
 *  @param {object} json json data return from the server.
 *  @param {string} json.sEcho Tracking flag for DataTables to match requests
 *  @param {int} json.iTotalRecords Number of records in the data set, not accounting for filtering
 *  @param {int} json.iTotalDisplayRecords Number of records in the data set, accounting for filtering
 *  @param {array} json.aaData The data to display on this page
 *  @param {string} [json.sColumns] Column ordering (sName, comma separated)
 *  @memberof DataTable#oApi
 */function Oe(e,t){var r=Re(e,t);var a=je(e,"draw",t);var n=je(e,"recordsTotal",t);var i=je(e,"recordsFiltered",t);if(a!==void 0){if(a*1<e.iDraw)return;e.iDraw=a*1}r||(r=[]);ue(e);e._iRecordsTotal=parseInt(n,10);e._iRecordsDisplay=parseInt(i,10);for(var o=0,l=r.length;o<l;o++)K(e,r[o]);e.aiDisplay=e.aiDisplayMaster.slice();z(e);be(e,true);qe(e);Ye(e,false)}
/**
 * Get the data from the JSON data source to use for drawing a table. Using
 * `_fnGetObjectDataFn` allows the data to be sourced from a property of the
 * source object, or from a processing function.
 *  @param {object} settings dataTables settings object
 *  @param  {object} json Data source object / array from the server
 *  @return {array} Array of data to use
 */function Re(e,r,a){var n="data";if(t.isPlainObject(e.ajax)&&e.ajax.dataSrc!==void 0){var i=e.ajax.dataSrc;typeof i==="string"||typeof i==="function"?n=i:i.data!==void 0&&(n=i.data)}if(!a)return n==="data"?r.aaData||r[n]:n!==""?oe(n)(r):r;le(n)(r,a)}
/**
 * Very similar to _fnAjaxDataSrc, but for the other SSP properties
 * @param {*} settings DataTables settings object
 * @param {*} param Target parameter
 * @param {*} json JSON data
 * @returns Resolved value
 */function je(e,r,a){var n=t.isPlainObject(e.ajax)?e.ajax.dataSrc:null;if(n&&n[r])return oe(n[r])(a);var i="";r==="draw"?i="sEcho":r==="recordsTotal"?i="iTotalRecords":r==="recordsFiltered"&&(i="iTotalDisplayRecords");return a[i]!==void 0?a[i]:a[r]}
/**
 * Filter the table using both the global filter and column based filtering
 *  @param {object} settings dataTables settings object
 *  @param {object} input search information
 *  @memberof DataTable#oApi
 */function Pe(e,r){var a=e.aoPreSearchCols;if(St(e)!="ssp"){Ve(e);e.aiDisplay=e.aiDisplayMaster.slice();ke(e.aiDisplay,e,r.search,r);t.each(e.searchFixed,(function(t,r){ke(e.aiDisplay,e,r,{})}));for(var n=0;n<a.length;n++){var i=a[n];ke(e.aiDisplay,e,i.search,i,n);t.each(e.aoColumns[n].searchFixed,(function(t,r){ke(e.aiDisplay,e,r,{},n)}))}Ee(e)}e.bFiltered=true;Dt(e,null,"search",[e])}
/**
 * Apply custom filtering functions
 * 
 * This is legacy now that we have named functions, but it is widely used
 * from 1.x, so it is not yet deprecated.
 *  @param {object} oSettings dataTables settings object
 *  @memberof DataTable#oApi
 */function Ee(e){var t=r.ext.search;var a=e.aiDisplay;var n,i;for(var o=0,l=t.length;o<l;o++){var s=[];for(var u=0,c=a.length;u<c;u++){i=a[u];n=e.aoData[i];t[o](e,n._aFilterData,i,n._aData,u)&&s.push(i)}a.length=0;_t(a,s)}}function ke(e,t,r,a,n){if(r!==""){var i=0;var o=[];var l=typeof r==="function"?r:null;var s=r instanceof RegExp?r:l?null:Me(r,a);for(i=0;i<e.length;i++){var u=t.aoData[e[i]];var c=n===void 0?u._sFilterRow:u._aFilterData[n];(l&&l(c,u._aData,e[i],n)||s&&s.test(c))&&o.push(e[i])}e.length=o.length;for(i=0;i<o.length;i++)e[i]=o[i]}}
/**
 * Build a regular expression object suitable for searching a table
 *  @param {string} sSearch string to search for
 *  @param {bool} bRegex treat as a regular expression or not
 *  @param {bool} bSmart perform smart filtering or not
 *  @param {bool} bCaseInsensitive Do case insensitive matching or not
 *  @returns {RegExp} constructed object
 *  @memberof DataTable#oApi
 */function Me(e,r){var a=[];var n=t.extend({},{boundary:false,caseInsensitive:true,exact:false,regex:false,smart:true},r);typeof e!=="string"&&(e=e.toString());e=C(e);if(n.exact)return new RegExp("^"+He(e)+"$",n.caseInsensitive?"i":"");e=n.regex?e:He(e);if(n.smart){var i=e.match(/!?["\u201C][^"\u201D]+["\u201D]|[^ ]+/g)||[""];var o=i.map((function(e){var t=false;var r;if(e.charAt(0)==="!"){t=true;e=e.substring(1)}if(e.charAt(0)==='"'){r=e.match(/^"(.*)"$/);e=r?r[1]:e}else if(e.charAt(0)==="“"){r=e.match(/^\u201C(.*)\u201D$/);e=r?r[1]:e}if(t){e.length>1&&a.push("(?!"+e+")");e=""}return e.replace(/"/g,"")}));var l=a.length?a.join(""):"";var s=n.boundary?"\\b":"";e="^(?=.*?"+s+o.join(")(?=.*?"+s)+")("+l+".)*$"}return new RegExp(e,n.caseInsensitive?"i":"")}
/**
 * Escape a string such that it can be used in a regular expression
 *  @param {string} sVal string to escape
 *  @returns {string} escaped string
 *  @memberof DataTable#oApi
 */var He=r.util.escapeRegex;var We=t("<div>")[0];var Xe=We.textContent!==void 0;function Ve(e){var t=e.aoColumns;var r=e.aoData;var a;var n,i,o,l,s;var u=false;for(var c=0;c<r.length;c++)if(r[c]){s=r[c];if(!s._aFilterData){o=[];for(n=0,i=t.length;n<i;n++){a=t[n];if(a.bSearchable){l=ee(e,c,n,"filter");l===null&&(l="");typeof l!=="string"&&l.toString&&(l=l.toString())}else l="";if(l.indexOf&&l.indexOf("&")!==-1){We.innerHTML=l;l=Xe?We.textContent:We.innerText}l.replace&&(l=l.replace(/[\r\n\u2028]/g,""));o.push(l)}s._aFilterData=o;s._sFilterRow=o.join("  ");u=true}}return u}
/**
 * Draw the table for the first time, adding all required features
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function Be(e){var r;var a=e.oInit;var n=e.deferLoading;var i=St(e);if(e.bInitialised){pe(e,"header");pe(e,"footer");vt(e,a,(function(){me(e,e.aoHeader);me(e,e.aoFooter);var o=e.iInitDisplayStart;if(a.aaData)for(r=0;r<a.aaData.length;r++)K(e,a.aaData[r]);else(n||i=="dom")&&Q(e,t(e.nTBody).children("tr"));e.aiDisplay=e.aiDisplayMaster.slice();_e(e);at(e);rt(e);Ye(e,true);Dt(e,null,"preInit",[e],true);ye(e);if(i!="ssp"||n)if(i=="ajax")Ae(e,{},(function(t){var a=Re(e,t);for(r=0;r<a.length;r++)K(e,a[r]);e.iInitDisplayStart=o;ye(e);Ye(e,false);qe(e)}),e);else{qe(e);Ye(e,false)}}))}else setTimeout((function(){Be(e)}),200)}
/**
 * Draw the table for the first time, adding all required features
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function qe(e){if(!e._bInitComplete){var t=[e,e.json];e._bInitComplete=true;H(e);Dt(e,null,"plugin-init",t,true);Dt(e,"aoInitComplete","init",t,true)}}function Ue(e,t){var r=parseInt(t,10);e._iDisplayLength=r;wt(e);Dt(e,null,"length",[e,r])}
/**
 * Alter the display settings to change the page
 *  @param {object} settings DataTables settings object
 *  @param {string|int} action Paging action to take: "first", "previous",
 *    "next" or "last" or page number to jump to (integer)
 *  @param [bool] redraw Automatically draw the update or not
 *  @returns {bool} true page has changed, false - no change
 *  @memberof DataTable#oApi
 */function ze(e,t,r){var a=e._iDisplayStart,n=e._iDisplayLength,i=e.fnRecordsDisplay();if(i===0||n===-1)a=0;else if(typeof t==="number"){a=t*n;a>i&&(a=0)}else if(t=="first")a=0;else if(t=="previous"){a=n>=0?a-n:0;a<0&&(a=0)}else if(t=="next")a+n<i&&(a+=n);else if(t=="last")a=Math.floor((i-1)/n)*n;else{if(t==="ellipsis")return;pt(e,0,"Unknown paging action: "+t,5)}var o=e._iDisplayStart!==a;e._iDisplayStart=a;Dt(e,null,o?"page":"page-nc",[e]);o&&r&&be(e);return o}
/**
 * Generate the node required for the processing node
 *  @param {object} settings DataTables settings object
 */function $e(e){var r=e.nTable;var a=e.oScroll.sX!==""||e.oScroll.sY!=="";if(e.oFeatures.bProcessing){var n=t("<div/>",{id:e.sTableId+"_processing",class:e.oClasses.processing.container,role:"status"}).html(e.oLanguage.sProcessing).append("<div><div></div><div></div><div></div><div></div></div>");a?n.prependTo(t("div.dt-scroll",e.nTableWrapper)):n.insertBefore(r);t(r).on("processing.dt.DT",(function(e,t,r){n.css("display",r?"block":"none")}))}}
/**
 * Display or hide the processing indicator
 *  @param {object} settings DataTables settings object
 *  @param {bool} show Show the processing indicator (true) or not (false)
 */function Ye(e,t){e.bDrawing&&t===false||Dt(e,null,"processing",[e,t])}
/**
 * Show the processing element if an action takes longer than a given time
 *
 * @param {*} settings DataTables settings object
 * @param {*} enable Do (true) or not (false) async processing (local feature enablement)
 * @param {*} run Function to run
 */function Ge(e,t,r){if(t){Ye(e,true);setTimeout((function(){r();Ye(e,false)}),0)}else r()}
/**
 * Add any control elements for the table - specifically scrolling
 *  @param {object} settings dataTables settings object
 *  @returns {node} Node to add to the DOM
 *  @memberof DataTable#oApi
 */function Je(e){var r=t(e.nTable);var a=e.oScroll;if(a.sX===""&&a.sY==="")return e.nTable;var n=a.sX;var i=a.sY;var o=e.oClasses.scrolling;var l=e.captionNode;var s=l?l._captionSide:null;var u=t(r[0].cloneNode(false));var c=t(r[0].cloneNode(false));var f=r.children("tfoot");var d="<div/>";var v=function(e){return e?tt(e):null};f.length||(f=null);var h=t(d,{class:o.container}).append(t(d,{class:o.header.self}).css({overflow:"hidden",position:"relative",border:0,width:n?v(n):"100%"}).append(t(d,{class:o.header.inner}).css({"box-sizing":"content-box",width:a.sXInner||"100%"}).append(u.removeAttr("id").css("margin-left",0).append(s==="top"?l:null).append(r.children("thead"))))).append(t(d,{class:o.body}).css({position:"relative",overflow:"auto",width:v(n)}).append(r));f&&h.append(t(d,{class:o.footer.self}).css({overflow:"hidden",border:0,width:n?v(n):"100%"}).append(t(d,{class:o.footer.inner}).append(c.removeAttr("id").css("margin-left",0).append(s==="bottom"?l:null).append(r.children("tfoot")))));var p=h.children();var g=p[0];var m=p[1];var b=f?p[2]:null;t(m).on("scroll.DT",(function(){var e=this.scrollLeft;g.scrollLeft=e;f&&(b.scrollLeft=e)}));t("th, td",g).on("focus",(function(){var e=g.scrollLeft;m.scrollLeft=e;f&&(m.scrollLeft=e)}));t(m).css("max-height",i);a.bCollapse||t(m).css("height",i);e.nScrollHead=g;e.nScrollBody=m;e.nScrollFoot=b;e.aoDrawCallback.push(Ze);return h[0]}
/**
 * Update the header, footer and body tables for resizing - i.e. column
 * alignment.
 *
 * Welcome to the most horrible function DataTables. The process that this
 * function follows is basically:
 *   1. Re-create the table inside the scrolling div
 *   2. Correct colgroup > col values if needed
 *   3. Copy colgroup > col over to header and footer
 *   4. Clean up
 *
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function Ze(e){var r,a,n=e.oScroll,i=n.iBarWidth,o=t(e.nScrollHead),l=o.children("div"),s=l.children("table"),u=e.nScrollBody,c=t(u),f=t(e.nScrollFoot),d=f.children("div"),v=d.children("table"),h=t(e.nTHead),p=t(e.nTable),g=e.nTFoot&&t("th, td",e.nTFoot).length?t(e.nTFoot):null,m=e.oBrowser;var b=u.scrollHeight>u.clientHeight;if(e.scrollBarVis===b||e.scrollBarVis===void 0){e.scrollBarVis=b;p.children("thead, tfoot").remove();r=h.clone().prependTo(p);r.find("th, td").removeAttr("tabindex");r.find("[id]").removeAttr("id");if(g){a=g.clone().prependTo(p);a.find("[id]").removeAttr("id")}if(e.aiDisplay.length){var y=null;var D=St(e)!=="ssp"?e._iDisplayStart:0;for(T=D;T<D+e.aiDisplay.length;T++){var w=e.aiDisplay[T];var x=e.aoData[w].nTr;if(x){y=x;break}}if(y){var S=t(y).children("th, td").map((function(r){return{idx:X(e,r),width:t(this).outerWidth()}}));for(var T=0;T<S.length;T++){var _=e.aoColumns[S[T].idx].colEl[0];var C=_.style.width.replace("px","");if(C!==S[T].width){_.style.width=S[T].width+"px";n.sX&&(_.style.minWidth=S[T].width+"px")}}}}s.find("colgroup").remove();s.append(e.colgroup.clone());if(g){v.find("colgroup").remove();v.append(e.colgroup.clone())}t("th, td",r).each((function(){t(this.childNodes).wrapAll('<div class="dt-scroll-sizing">')}));g&&t("th, td",a).each((function(){t(this.childNodes).wrapAll('<div class="dt-scroll-sizing">')}));var I=Math.floor(p.height())>u.clientHeight||c.css("overflow-y")=="scroll";var L="padding"+(m.bScrollbarLeft?"Left":"Right");var A=p.outerWidth();s.css("width",tt(A));l.css("width",tt(A)).css(L,I?i+"px":"0px");if(g){v.css("width",tt(A));d.css("width",tt(A)).css(L,I?i+"px":"0px")}p.children("colgroup").prependTo(p);c.trigger("scroll");!e.bSorted&&!e.bFiltered||e._drawHold||(u.scrollTop=0)}else{e.scrollBarVis=b;H(e)}}
/**
 * Calculate the width of columns for the table
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function Ke(e){if(e.oFeatures.bAutoWidth){var n,i,o,l=e.nTable,s=e.aoColumns,u=e.oScroll,c=u.sY,f=u.sX,d=u.sXInner,v=q(e,"bVisible"),h=l.getAttribute("width"),p=l.parentNode;var g=l.style.width;var m=Qe(e);if(m===e.containerWidth)return false;e.containerWidth=m;if(!g&&!h){l.style.width="100%";g="100%"}g&&g.indexOf("%")!==-1&&(h=g);Dt(e,null,"column-calc",{visible:v},false);var b=t(l.cloneNode()).css("visibility","hidden").removeAttr("id");b.append("<tbody>");var y=t("<tr/>").appendTo(b.find("tbody"));b.append(t(e.nTHead).clone()).append(t(e.nTFoot).clone());b.find("tfoot th, tfoot td").css("width","");b.find("thead th, thead td").each((function(){var r=J(e,this,true,false);if(r){this.style.width=r;if(f){this.style.minWidth=r;t(this).append(t("<div/>").css({width:r,margin:0,padding:0,border:0,height:1}))}}else this.style.width=""}));for(n=0;n<v.length;n++){o=v[n];i=s[o];var D=et(e,o);var w=a.type.className[i.sType];var x=D+i.sContentPadding;var S=D.indexOf("<")===-1?document.createTextNode(x):x;t("<td/>").addClass(w).addClass(i.sClass).append(S).appendTo(y)}t("[name]",b).removeAttr("name");var T=t("<div/>").css(f||c?{position:"absolute",top:0,left:0,height:1,right:0,overflow:"hidden"}:{}).append(b).appendTo(p);if(f&&d)b.width(d);else if(f){b.css("width","auto");b.removeAttr("width");b.outerWidth()<p.clientWidth&&h&&b.outerWidth(p.clientWidth)}else c?b.outerWidth(p.clientWidth):h&&b.outerWidth(h);var _=0;var C=b.find("tbody tr").eq(0).children();for(n=0;n<v.length;n++){var I=C[n].getBoundingClientRect().width;_+=I;s[v[n]].sWidth=tt(I)}l.style.width=tt(_);T.remove();h&&(l.style.width=tt(h));if((h||f)&&!e._reszEvt){var L=r.util.throttle((function(){var t=Qe(e);e.bDestroying||t===0||H(e)}));if(window.ResizeObserver){var A=t(e.nTableWrapper).is(":visible");var N=t("<div>").css({width:"100%",height:0}).addClass("dt-autosize").appendTo(e.nTableWrapper);e.resizeObserver=new ResizeObserver((function(e){A?A=false:L()}));e.resizeObserver.observe(N[0])}else t(window).on("resize.DT-"+e.sInstance,L);e._reszEvt=true}}}
/**
 * Get the width of the DataTables wrapper element
 *
 * @param {*} settings DataTables settings object
 * @returns Width
 */function Qe(e){return t(e.nTableWrapper).is(":visible")?t(e.nTableWrapper).width():0}
/**
 * Get the maximum strlen for each data column
 *  @param {object} settings dataTables settings object
 *  @param {int} colIdx column of interest
 *  @returns {string} string of the max length
 *  @memberof DataTable#oApi
 */function et(e,t){var r=e.aoColumns[t];if(!r.maxLenString){var a,n="",i=-1;for(var o=0,l=e.aiDisplayMaster.length;o<l;o++){var s=e.aiDisplayMaster[o];var u=de(e,s)[t];var c=u&&typeof u==="object"&&u.nodeType?u.innerHTML:u+"";c=c.replace(/id=".*?"/g,"").replace(/name=".*?"/g,"");a=T(c).replace(/&nbsp;/g," ");if(a.length>i){n=c;i=a.length}}r.maxLenString=n}return r.maxLenString}
/**
 * Append a CSS unit (only if required) to a string
 *  @param {string} value to css-ify
 *  @returns {string} value with css unit
 *  @memberof DataTable#oApi
 */function tt(e){return e===null?"0px":typeof e=="number"?e<0?"0px":e+"px":e.match(/\d$/)?e+"px":e}
/**
 * Re-insert the `col` elements for current visibility
 *
 * @param {*} settings DT settings
 */function rt(e){var t=e.aoColumns;e.colgroup.empty();for(gr=0;gr<t.length;gr++)t[gr].bVisible&&e.colgroup.append(t[gr].colEl)}function at(e){var t=e.nTHead;var r=t.querySelectorAll("tr");var a=e.titleRow;var n=':not([data-dt-order="disable"]):not([data-dt-order="icon-only"])';a===true?t=r[0]:a===false?t=r[r.length-1]:a!==null&&(t=r[a]);e.orderHandler&&nt(e,t,t===e.nTHead?"tr"+n+" th"+n+", tr"+n+" td"+n:"th"+n+", td"+n);var i=[];ot(e,i,e.aaSorting);e.aaSorting=i}function nt(e,t,r,a,n){bt(t,r,(function(t){var r=false;var i=a===void 0?Z(t.target):Array.isArray(a)?a:[a];if(i.length){for(var o=0,l=i.length;o<l;o++){var s=ut(e,i[o],o,t.shiftKey);s!==false&&(r=true);if(e.aaSorting.length===1&&e.aaSorting[0][1]==="")break}r&&Ge(e,true,(function(){st(e);it(e,e.aiDisplay);ye(e,false,false);n&&n()}))}}))}
/**
 * Sort the display array to match the master's order
 * @param {*} settings
 */function it(e,t){if(!(t.length<2)){var r=e.aiDisplayMaster;var a={};var n={};var i;for(i=0;i<r.length;i++)a[r[i]]=i;for(i=0;i<t.length;i++)n[t[i]]=a[t[i]];t.sort((function(e,t){return n[e]-n[t]}))}}function ot(e,r,a){var n=function(a){if(t.isPlainObject(a)){if(a.idx!==void 0)r.push([a.idx,a.dir]);else if(a.name){var n=D(e.aoColumns,"sName");var i=n.indexOf(a.name);i!==-1&&r.push([i,a.dir])}}else r.push(a)};if(t.isPlainObject(a))n(a);else if(a.length&&typeof a[0]==="number")n(a);else if(a.length)for(var i=0;i<a.length;i++)n(a[i])}function lt(e){var a,n,i,o,l,s,u,c=[],f=r.ext.type.order,d=e.aoColumns,v=e.aaSortingFixed,h=t.isPlainObject(v),p=[];if(!e.oFeatures.bSort)return c;Array.isArray(v)&&ot(e,p,v);h&&v.pre&&ot(e,p,v.pre);ot(e,p,e.aaSorting);h&&v.post&&ot(e,p,v.post);for(a=0;a<p.length;a++){u=p[a][0];if(d[u]){o=d[u].aDataSort;for(n=0,i=o.length;n<i;n++){l=o[n];s=d[l].sType||"string";p[a]._idx===void 0&&(p[a]._idx=d[l].asSorting.indexOf(p[a][1]));p[a][1]&&c.push({src:u,col:l,dir:p[a][1],index:p[a]._idx,type:s,formatter:f[s+"-pre"],sorter:f[s+"-"+p[a][1]]})}}}return c}
/**
 * Change the order of the table
 *  @param {object} oSettings dataTables settings object
 *  @memberof DataTable#oApi
 */function st(e,t,a){var n,i,o,l,s,u=[],c=r.ext.type.order,f=e.aoData,d=e.aiDisplayMaster;z(e);if(t!==void 0){var v=e.aoColumns[t];s=[{src:t,col:t,dir:a,index:0,type:v.sType,formatter:c[v.sType+"-pre"],sorter:c[v.sType+"-"+a]}];d=d.slice()}else s=lt(e);for(n=0,i=s.length;n<i;n++){l=s[n];ft(e,l.col)}if(St(e)!="ssp"&&s.length!==0){for(n=0,o=d.length;n<o;n++)u[n]=n;s.length&&s[0].dir==="desc"&&e.orderDescReverse&&u.reverse();d.sort((function(e,t){var r,a,n,i,o,l=s.length,c=f[e]._aSortData,d=f[t]._aSortData;for(n=0;n<l;n++){o=s[n];r=c[o.col];a=d[o.col];if(o.sorter){i=o.sorter(r,a);if(i!==0)return i}else{i=r<a?-1:r>a?1:0;if(i!==0)return o.dir==="asc"?i:-i}}r=u[e];a=u[t];return r<a?-1:r>a?1:0}))}else s.length===0&&d.sort((function(e,t){return e<t?-1:e>t?1:0}));if(t===void 0){e.bSorted=true;e.sortDetails=s;Dt(e,null,"order",[e,s])}return d}
/**
 * Function to run on user sort request
 *  @param {object} settings dataTables settings object
 *  @param {node} attachTo node to attach the handler to
 *  @param {int} colIdx column sorting index
 *  @param {int} addIndex Counter
 *  @param {boolean} [shift=false] Shift click add
 *  @param {function} [callback] callback function
 *  @memberof DataTable#oApi
 */function ut(e,t,r,a){var n=e.aoColumns[t];var i=e.aaSorting;var o=n.asSorting;var l;var s=function(e,t){var r=e._idx;r===void 0&&(r=o.indexOf(e[1]));return r+1<o.length?r+1:t?null:0};if(!n.bSortable)return false;typeof i[0]==="number"&&(i=e.aaSorting=[i]);if((a||r)&&e.oFeatures.bSortMulti){var u=D(i,"0").indexOf(t);if(u!==-1){l=s(i[u],true);l===null&&i.length===1&&(l=0);if(l===null)i.splice(u,1);else{i[u][1]=o[l];i[u]._idx=l}}else if(a){i.push([t,o[0],0]);i[i.length-1]._idx=0}else{i.push([t,i[0][1],0]);i[i.length-1]._idx=0}}else if(i.length&&i[0][0]==t){l=s(i[0]);i.length=1;i[0][1]=o[l];i[0]._idx=l}else{i.length=0;i.push([t,o[0]]);i[0]._idx=0}}
/**
 * Set the sorting classes on table's body, Note: it is safe to call this function
 * when bSort and bSortClasses are false
 *  @param {object} oSettings dataTables settings object
 *  @memberof DataTable#oApi
 */function ct(e){var r=e.aLastSort;var a=e.oClasses.order.position;var n=lt(e);var i=e.oFeatures;var o,l,s;if(i.bSort&&i.bSortClasses){for(o=0,l=r.length;o<l;o++){s=r[o].src;t(D(e.aoData,"anCells",s)).removeClass(a+(o<2?o+1:3))}for(o=0,l=n.length;o<l;o++){s=n[o].src;t(D(e.aoData,"anCells",s)).addClass(a+(o<2?o+1:3))}}e.aLastSort=n}function ft(e,t){var a=e.aoColumns[t];var n=r.ext.order[a.sSortDataType];var i;n&&(i=n.call(e.oInstance,e,t,V(e,t)));var o,l;var s=r.ext.type.order[a.sType+"-pre"];var u=e.aoData;for(var c=0;c<u.length;c++)if(u[c]){o=u[c];o._aSortData||(o._aSortData=[]);if(!o._aSortData[t]||n){l=n?i[c]:ee(e,c,t,"sort");o._aSortData[t]=s?s(l,e):l}}}
/**
 * State information for a table
 *
 * @param {*} settings
 * @returns State object
 */function dt(e){if(!e._bLoadingState){var r=[];ot(e,r,e.aaSorting);var a=e.aoColumns;var n={time:+new Date,start:e._iDisplayStart,length:e._iDisplayLength,order:r.map((function(e){return a[e[0]]&&a[e[0]].sName?[a[e[0]].sName,e[1]]:e.slice()})),search:t.extend({},e.oPreviousSearch),columns:e.aoColumns.map((function(r,a){return{name:r.sName,visible:r.bVisible,search:t.extend({},e.aoPreSearchCols[a])}}))};e.oSavedState=n;Dt(e,"aoStateSaveParams","stateSaveParams",[e,n]);e.oFeatures.bStateSave&&!e.bDestroying&&e.fnStateSaveCallback.call(e.oInstance,e,n)}}
/**
 * Attempt to load a saved table state
 *  @param {object} oSettings dataTables settings object
 *  @param {object} oInit DataTables init object so we can override settings
 *  @param {function} callback Callback to execute when the state has been loaded
 *  @memberof DataTable#oApi
 */function vt(e,t,r){if(e.oFeatures.bStateSave){var a=function(t){ht(e,t,r)};var n=e.fnStateLoadCallback.call(e.oInstance,e,a);n!==void 0&&ht(e,n,r);return true}r()}function ht(e,a,n){var i,o;var l=e.aoColumns;var s=D(e.aoColumns,"sName");e._bLoadingState=true;var u=e._bInitComplete?new r.Api(e):null;if(a&&a.time){var c=e.iStateDuration;if(c>0&&a.time<+new Date-c*1e3){e._bLoadingState=false;n()}else{var f=Dt(e,"aoStateLoadParams","stateLoadParams",[e,a]);if(f.indexOf(false)===-1){e.oLoadedState=t.extend(true,{},a);Dt(e,null,"stateLoadInit",[e,a],true);a.length!==void 0&&(u?u.page.len(a.length):e._iDisplayLength=a.length);if(a.start!==void 0)if(u===null){e._iDisplayStart=a.start;e.iInitDisplayStart=a.start}else ze(e,a.start/e._iDisplayLength);if(a.order!==void 0){e.aaSorting=[];t.each(a.order,(function(t,r){var a=[r[0],r[1]];if(typeof r[0]==="string"){var n=s.indexOf(r[0]);if(n<0)return;a[0]=n}else if(a[0]>=l.length)return;e.aaSorting.push(a)}))}a.search!==void 0&&t.extend(e.oPreviousSearch,a.search);if(a.columns){var d=a.columns;var v=D(a.columns,"name");if(v.join("").length&&v.join("")!==s.join("")){d=[];for(i=0;i<s.length;i++)if(s[i]!=""){var h=v.indexOf(s[i]);h>=0?d.push(a.columns[h]):d.push({})}else d.push({})}if(d.length===l.length){for(i=0,o=d.length;i<o;i++){var p=d[i];p.visible!==void 0&&(u?u.column(i).visible(p.visible,false):l[i].bVisible=p.visible);p.search!==void 0&&t.extend(e.aoPreSearchCols[i],p.search)}u&&u.columns.adjust()}}e._bLoadingState=false;Dt(e,"aoStateLoaded","stateLoaded",[e,a]);n()}else{e._bLoadingState=false;n()}}}else{e._bLoadingState=false;n()}}
/**
 * Log an error message
 *  @param {object} settings dataTables settings object
 *  @param {int} level log error messages, or display them to the user
 *  @param {string} msg error message
 *  @param {int} tn Technical note id to get more information about the error.
 *  @memberof DataTable#oApi
 */function pt(e,t,a,n){a="DataTables warning: "+(e?"table id="+e.sTableId+" - ":"")+a;n&&(a+=". For more information about this error, please see https://datatables.net/tn/"+n);if(t)window.console&&console.log&&console.log(a);else{var i=r.ext;var o=i.sErrMode||i.errMode;e&&Dt(e,null,"dt-error",[e,n,a],true);if(o=="alert")alert(a);else{if(o=="throw")throw new Error(a);typeof o=="function"&&o(e,n,a)}}}
/**
 * See if a property is defined on one object, if so assign it to the other object
 *  @param {object} ret target object
 *  @param {object} src source object
 *  @param {string} name property
 *  @param {string} [mappedName] name to map too - optional, name used if not given
 *  @memberof DataTable#oApi
 */function gt(e,r,a,n){if(Array.isArray(a))t.each(a,(function(t,a){Array.isArray(a)?gt(e,r,a[0],a[1]):gt(e,r,a)}));else{n===void 0&&(n=a);r[a]!==void 0&&(e[n]=r[a])}}
/**
 * Extend objects - very similar to jQuery.extend, but deep copy objects, and
 * shallow copy arrays. The reason we need to do this, is that we don't want to
 * deep copy array init values (such as aaSorting) since the dev wouldn't be
 * able to override them, but we do want to deep copy arrays.
 *  @param {object} out Object to extend
 *  @param {object} extender Object from which the properties will be applied to
 *      out
 *  @param {boolean} breakRefs If true, then arrays will be sliced to take an
 *      independent copy with the exception of the `data` or `aaData` parameters
 *      if they are present. This is so you can pass in a collection to
 *      DataTables and have that used as your data source without breaking the
 *      references
 *  @returns {object} out Reference, just for convenience - out === the return.
 *  @memberof DataTable#oApi
 *  @todo This doesn't take account of arrays inside the deep copied objects.
 */function mt(e,r,a){var n;for(var i in r)if(Object.prototype.hasOwnProperty.call(r,i)){n=r[i];if(t.isPlainObject(n)){t.isPlainObject(e[i])||(e[i]={});t.extend(true,e[i],n)}else a&&i!=="data"&&i!=="aaData"&&Array.isArray(n)?e[i]=n.slice():e[i]=n}return e}
/**
 * Bind an event handers to allow a click or return key to activate the callback.
 * This is good for accessibility since a return on the keyboard will have the
 * same effect as a click, if the element has focus.
 *  @param {element} n Element to bind the action to
 *  @param {object|string} selector Selector (for delegated events) or data object
 *   to pass to the triggered function
 *  @param {function} fn Callback function for when the event is triggered
 *  @memberof DataTable#oApi
 */function bt(e,r,a){t(e).on("click.DT",r,(function(e){a(e)})).on("keypress.DT",r,(function(e){if(e.which===13){e.preventDefault();a(e)}})).on("selectstart.DT",r,(function(){return false}))}
/**
 * Register a callback function. Easily allows a callback function to be added to
 * an array store of callback functions that can then all be called together.
 *  @param {object} settings dataTables settings object
 *  @param {string} store Name of the array storage for the callbacks in oSettings
 *  @param {function} fn Function to be called back
 *  @memberof DataTable#oApi
 */function yt(e,t,r){r&&e[t].push(r)}
/**
 * Fire callback functions and trigger events. Note that the loop over the
 * callback array store is done backwards! Further note that you do not want to
 * fire off triggers in time sensitive applications (for example cell creation)
 * as its slow.
 *  @param {object} settings dataTables settings object
 *  @param {string} callbackArr Name of the array storage for the callbacks in
 *      oSettings
 *  @param {string} eventName Name of the jQuery custom event to trigger. If
 *      null no trigger is fired
 *  @param {array} args Array of arguments to pass to the callback function /
 *      trigger
 *  @param {boolean} [bubbles] True if the event should bubble
 *  @memberof DataTable#oApi
 */function Dt(e,r,a,n,i){var o=[];r&&(o=e[r].slice().reverse().map((function(t){return t.apply(e.oInstance,n)})));if(a!==null){var l=t.Event(a+".dt");var s=t(e.nTable);l.dt=e.api;s[i?"trigger":"triggerHandler"](l,n);i&&s.parents("body").length===0&&t("body").trigger(l,n);o.push(l.result)}return o}function wt(e){var t=e._iDisplayStart,r=e.fnDisplayEnd(),a=e._iDisplayLength;t>=r&&(t=r-a);t-=t%a;(a===-1||t<0)&&(t=0);e._iDisplayStart=t}function xt(e,a){var n=e.renderer;var i=r.ext.renderer[a];return t.isPlainObject(n)&&n[a]?i[n[a]]||i._:typeof n==="string"&&i[n]||i._}
/**
 * Detect the data source being used for the table. Used to simplify the code
 * a little (ajax) and to make it compress a little smaller.
 *
 *  @param {object} settings dataTables settings object
 *  @returns {string} Data source
 *  @memberof DataTable#oApi
 */function St(e){return e.oFeatures.bServerSide?"ssp":e.ajax?"ajax":"dom"}
/**
 * Common replacement for language strings
 *
 * @param {*} settings DT settings object
 * @param {*} str String with values to replace
 * @param {*} entries Plural number for _ENTRIES_ - can be undefined
 * @returns String
 */function Tt(e,t,r){var a=e.fnFormatNumber,n=e._iDisplayStart+1,i=e._iDisplayLength,o=e.fnRecordsDisplay(),l=e.fnRecordsTotal(),s=i===-1;return t.replace(/_START_/g,a.call(e,n)).replace(/_END_/g,a.call(e,e.fnDisplayEnd())).replace(/_MAX_/g,a.call(e,l)).replace(/_TOTAL_/g,a.call(e,o)).replace(/_PAGE_/g,a.call(e,s?1:Math.ceil(n/i))).replace(/_PAGES_/g,a.call(e,s?1:Math.ceil(o/i))).replace(/_ENTRIES_/g,e.api.i18n("entries","",r)).replace(/_ENTRIES-MAX_/g,e.api.i18n("entries","",l)).replace(/_ENTRIES-TOTAL_/g,e.api.i18n("entries","",o))}
/**
 * Add elements to an array as quickly as possible, but stack stafe.
 *
 * @param {*} arr Array to add the data to
 * @param {*} data Data array that is to be added
 * @returns 
 */function _t(e,t){if(t)if(t.length<1e4)e.push.apply(e,t);else for(gr=0;gr<t.length;gr++)e.push(t[gr])}
/**
 * Add one or more listeners to the table
 *
 * @param {*} that JQ for the table
 * @param {*} name Event name
 * @param {*} src Listener(s)
 */function Ct(e,t,r){Array.isArray(r)||(r=[r]);for(gr=0;gr<r.length;gr++)e.on(t+".dt",r[gr])}
/**
 * Computed structure of the DataTables API, defined by the options passed to
 * `DataTable.Api.register()` when building the API.
 *
 * The structure is built in order to speed creation and extension of the Api
 * objects since the extensions are effectively pre-parsed.
 *
 * The array is an array of objects with the following structure, where this
 * base array represents the Api prototype base:
 *
 *     [
 *       {
 *         name:      'data'                -- string   - Property name
 *         val:       function () {},       -- function - Api method (or undefined if just an object
 *         methodExt: [ ... ],              -- array    - Array of Api object definitions to extend the method result
 *         propExt:   [ ... ]               -- array    - Array of Api object definitions to extend the property
 *       },
 *       {
 *         name:     'row'
 *         val:       {},
 *         methodExt: [ ... ],
 *         propExt:   [
 *           {
 *             name:      'data'
 *             val:       function () {},
 *             methodExt: [ ... ],
 *             propExt:   [ ... ]
 *           },
 *           ...
 *         ]
 *       }
 *     ]
 *
 * @type {Array}
 * @ignore
 */var It=[];
/**
 * `Array.prototype` reference.
 *
 * @type object
 * @ignore
 */var Lt=Array.prototype;
/**
 * Abstraction for `context` parameter of the `Api` constructor to allow it to
 * take several different forms for ease of use.
 *
 * Each of the input parameter types will be converted to a DataTables settings
 * object where possible.
 *
 * @param  {string|node|jQuery|object} mixed DataTable identifier. Can be one
 *   of:
 *
 *   * `string` - jQuery selector. Any DataTables' matching the given selector
 *     with be found and used.
 *   * `node` - `TABLE` node which has already been formed into a DataTable.
 *   * `jQuery` - A jQuery object of `TABLE` nodes.
 *   * `object` - DataTables settings object
 *   * `DataTables.Api` - API instance
 * @return {array|null} Matching DataTables settings objects. `null` or
 *   `undefined` is returned if no matching DataTable is found.
 * @ignore
 */var At=function(e){var a,n;var i=r.settings;var o=D(i,"nTable");if(!e)return[];if(e.nTable&&e.oFeatures)return[e];if(e.nodeName&&e.nodeName.toLowerCase()==="table"){a=o.indexOf(e);return a!==-1?[i[a]]:null}if(e&&typeof e.settings==="function")return e.settings().toArray();typeof e==="string"?n=t(e).get():e instanceof t&&(n=e.get());return n?i.filter((function(e,t){return n.includes(o[t])})):void 0};
/**
 * DataTables API class - used to control and interface with  one or more
 * DataTables enhanced tables.
 *
 * The API class is heavily based on jQuery, presenting a chainable interface
 * that you can use to interact with tables. Each instance of the API class has
 * a "context" - i.e. the tables that it will operate on. This could be a single
 * table, all tables on a page or a sub-set thereof.
 *
 * Additionally the API is designed to allow you to easily work with the data in
 * the tables, retrieving and manipulating it as required. This is done by
 * presenting the API class as an array like interface. The contents of the
 * array depend upon the actions requested by each method (for example
 * `rows().nodes()` will return an array of nodes, while `rows().data()` will
 * return an array of objects or arrays depending upon your table's
 * configuration). The API object has a number of array like methods (`push`,
 * `pop`, `reverse` etc) as well as additional helper methods (`each`, `pluck`,
 * `unique` etc) to assist your working with the data held in a table.
 *
 * Most methods (those which return an Api instance) are chainable, which means
 * the return from a method call also has all of the methods available that the
 * top level object had. For example, these two calls are equivalent:
 *
 *     // Not chained
 *     api.row.add( {...} );
 *     api.draw();
 *
 *     // Chained
 *     api.row.add( {...} ).draw();
 *
 * @class DataTable.Api
 * @param {array|object|string|jQuery} context DataTable identifier. This is
 *   used to define which DataTables enhanced tables this API will operate on.
 *   Can be one of:
 *
 *   * `string` - jQuery selector. Any DataTables' matching the given selector
 *     with be found and used.
 *   * `node` - `TABLE` node which has already been formed into a DataTable.
 *   * `jQuery` - A jQuery object of `TABLE` nodes.
 *   * `object` - DataTables settings object
 * @param {array} [data] Data to initialise the Api instance with.
 *
 * @example
 *   // Direct initialisation during DataTables construction
 *   var api = $('#example').DataTable();
 *
 * @example
 *   // Initialisation using a DataTables jQuery object
 *   var api = $('#example').dataTable().api();
 *
 * @example
 *   // Initialisation as a constructor
 *   var api = new DataTable.Api( 'table.dataTable' );
 */n=function(e,t){if(!(this instanceof n))return new n(e,t);var r;var a=[];var i=function(e){var t=At(e);t&&a.push.apply(a,t)};if(Array.isArray(e))for(r=0;r<e.length;r++)i(e[r]);else i(e);this.context=a.length>1?L(a):a;_t(this,t);this.selector={rows:null,cols:null,opts:null};n.extend(this,this,It)};r.Api=n;t.extend(n.prototype,{any:function(){return this.count()!==0},context:[],count:function(){return this.flatten().length},each:function(e){for(var t=0,r=this.length;t<r;t++)e.call(this,this[t],t,this);return this},eq:function(e){var t=this.context;return t.length>e?new n(t[e],this[e]):null},filter:function(e){var t=Lt.filter.call(this,e,this);return new n(this.context,t)},flatten:function(){var e=[];return new n(this.context,e.concat.apply(e,this.toArray()))},get:function(e){return this[e]},join:Lt.join,includes:function(e){return this.indexOf(e)!==-1},indexOf:Lt.indexOf,iterator:function(e,t,r,a){var i,o,l,s,u,c,f,d,v=[],h=this.context,p=this.selector;if(typeof e==="string"){a=r;r=t;t=e;e=false}for(o=0,l=h.length;o<l;o++){var g=new n(h[o]);if(t==="table"){i=r.call(g,h[o],o);i!==void 0&&v.push(i)}else if(t==="columns"||t==="rows"){i=r.call(g,h[o],this[o],o);i!==void 0&&v.push(i)}else if(t==="every"||t==="column"||t==="column-rows"||t==="row"||t==="cell"){f=this[o];t==="column-rows"&&(c=kt(h[o],p.opts));for(s=0,u=f.length;s<u;s++){d=f[s];i=t==="cell"?r.call(g,h[o],d.row,d.column,o,s):r.call(g,h[o],d,o,s,c);i!==void 0&&v.push(i)}}}if(v.length||a){var m=new n(h,e?v.concat.apply([],v):v);var b=m.selector;b.rows=p.rows;b.cols=p.cols;b.opts=p.opts;return m}return this},lastIndexOf:Lt.lastIndexOf,length:0,map:function(e){var t=Lt.map.call(this,e,this);return new n(this.context,t)},pluck:function(e){var t=r.util.get(e);return this.map((function(e){return t(e)}))},pop:Lt.pop,push:Lt.push,reduce:Lt.reduce,reduceRight:Lt.reduceRight,reverse:Lt.reverse,selector:null,shift:Lt.shift,slice:function(){return new n(this.context,this)},sort:Lt.sort,splice:Lt.splice,toArray:function(){return Lt.slice.call(this)},to$:function(){return t(this)},toJQuery:function(){return t(this)},unique:function(){return new n(this.context,L(this.toArray()))},unshift:Lt.unshift});function Nt(e,t,r){return function(){var a=t.apply(e||this,arguments);n.extend(a,a,r.methodExt);return a}}function Ft(e,t){for(var r=0,a=e.length;r<a;r++)if(e[r].name===t)return e[r];return null}window.__apiStruct=It;n.extend=function(e,t,r){if(r.length&&t&&(t instanceof n||t.__dt_wrapper)){var a,i,o;for(a=0,i=r.length;a<i;a++){o=r[a];if(o.name!=="__proto__"){t[o.name]=o.type==="function"?Nt(e,o.val,o):o.type==="object"?{}:o.val;t[o.name].__dt_wrapper=true;n.extend(e,t[o.name],o.propExt)}}}};n.register=i=function(e,r){if(Array.isArray(e))for(var a=0,i=e.length;a<i;a++)n.register(e[a],r);else{var o,l,s,u,c=e.split("."),f=It;for(o=0,l=c.length;o<l;o++){u=c[o].indexOf("()")!==-1;s=u?c[o].replace("()",""):c[o];var d=Ft(f,s);if(!d){d={name:s,val:{},methodExt:[],propExt:[],type:"object"};f.push(d)}if(o===l-1){d.val=r;d.type=typeof r==="function"?"function":t.isPlainObject(r)?"object":"other"}else f=u?d.methodExt:d.propExt}}};n.registerPlural=o=function(e,t,r){n.register(e,r);n.register(t,(function(){var e=r.apply(this,arguments);return e===this?this:e instanceof n?e.length?Array.isArray(e[0])?new n(e.context,e[0]):e[0]:void 0:e}))};
/**
 * Selector for HTML tables. Apply the given selector to the give array of
 * DataTables settings objects.
 *
 * @param {string|integer} [selector] jQuery selector string or integer
 * @param  {array} Array of DataTables settings objects to be filtered
 * @return {array}
 * @ignore
 */var Ot=function(e,r){if(Array.isArray(e)){var a=[];e.forEach((function(e){var t=Ot(e,r);_t(a,t)}));return a.filter((function(e){return e}))}if(typeof e==="number")return[r[e]];var n=r.map((function(e){return e.nTable}));return t(n).filter(e).map((function(){var e=n.indexOf(this);return r[e]})).toArray()};
/**
 * Context selector for the API's context (i.e. the tables the API instance
 * refers to.
 *
 * @name    DataTable.Api#tables
 * @param {string|integer} [selector] Selector to pick which tables the iterator
 *   should operate on. If not given, all tables in the current context are
 *   used. This can be given as a jQuery selector (for example `':gt(0)'`) to
 *   select multiple tables or as an integer to select a single table.
 * @returns {DataTable.Api} Returns a new API instance if a selector is given.
 */i("tables()",(function(e){return e!==void 0&&e!==null?new n(Ot(e,this.context)):this}));i("table()",(function(e){var t=this.tables(e);var r=t.context;return r.length?new n(r[0]):t}));[["nodes","node","nTable"],["body","body","nTBody"],["header","header","nTHead"],["footer","footer","nTFoot"]].forEach((function(e){o("tables()."+e[0]+"()","table()."+e[1]+"()",(function(){return this.iterator("table",(function(t){return t[e[2]]}),1)}))}));[["header","aoHeader"],["footer","aoFooter"]].forEach((function(e){i("table()."+e[0]+".structure()",(function(t){var r=this.columns(t).indexes().flatten().toArray();var a=this.context[0];var n=ge(a,a[e[1]],r);var i=r.slice().sort((function(e,t){return e-t}));return n.map((function(e){return r.map((function(t){return e[i.indexOf(t)]}))}))}))}));o("tables().containers()","table().container()",(function(){return this.iterator("table",(function(e){return e.nTableWrapper}),1)}));i("tables().every()",(function(e){var t=this;return this.iterator("table",(function(r,a){e.call(t.table(a),a)}))}));i("caption()",(function(e,r){var a=this.context;if(e===void 0){var n=a[0].captionNode;return n&&a.length?n.innerHTML:null}return this.iterator("table",(function(a){var n=t(a.nTable);var i=t(a.captionNode);var o=t(a.nTableWrapper);if(!i.length){i=t("<caption/>").html(e);a.captionNode=i[0];if(!r){n.prepend(i);r=i.css("caption-side")}}i.html(e);if(r){i.css("caption-side",r);i[0]._captionSide=r}if(o.find("div.dataTables_scroll").length){var l=r==="top"?"Head":"Foot";o.find("div.dataTables_scroll"+l+" table").prepend(i)}else n.prepend(i)}),1)}));i("caption.node()",(function(){var e=this.context;return e.length?e[0].captionNode:null}));i("draw()",(function(e){return this.iterator("table",(function(t){if(e==="page")be(t);else{typeof e==="string"&&(e=e!=="full-hold");ye(t,e===false)}}))}));
/**
 * Set the current page.
 *
 * Note that if you attempt to show a page which does not exist, DataTables will
 * not throw an error, but rather reset the paging.
 *
 * @param {integer|string} action The paging action to take. This can be one of:
 *  * `integer` - The page index to jump to
 *  * `string` - An action to take:
 *    * `first` - Jump to first page.
 *    * `next` - Jump to the next page
 *    * `previous` - Jump to previous page
 *    * `last` - Jump to the last page.
 * @returns {DataTables.Api} this
 */i("page()",(function(e){return e===void 0?this.page.info().page:this.iterator("table",(function(t){ze(t,e)}))}));i("page.info()",(function(){if(this.context.length!==0){var e=this.context[0],t=e._iDisplayStart,r=e.oFeatures.bPaginate?e._iDisplayLength:-1,a=e.fnRecordsDisplay(),n=r===-1;return{page:n?0:Math.floor(t/r),pages:n?1:Math.ceil(a/r),start:t,end:e.fnDisplayEnd(),length:r,recordsTotal:e.fnRecordsTotal(),recordsDisplay:a,serverSide:St(e)==="ssp"}}}));
/**
 * Set the current page length.
 *
 * @param {integer} Page length to set. Use `-1` to show all records.
 * @returns {DataTables.Api} this
 */i("page.len()",(function(e){return e===void 0?this.context.length!==0?this.context[0]._iDisplayLength:void 0:this.iterator("table",(function(t){Ue(t,e)}))}));var Rt=function(e,t,r){if(r){var a=new n(e);a.one("draw",(function(){r(a.ajax.json())}))}if(St(e)=="ssp")ye(e,t);else{Ye(e,true);var i=e.jqXHR;i&&i.readyState!==4&&i.abort();Ae(e,{},(function(r){ue(e);var a=Re(e,r);for(var n=0,i=a.length;n<i;n++)K(e,a[n]);ye(e,t);qe(e);Ye(e,false)}))}};i("ajax.json()",(function(){var e=this.context;if(e.length>0)return e[0].json}));i("ajax.params()",(function(){var e=this.context;if(e.length>0)return e[0].oAjaxData}));
/**
 * Reload tables from the Ajax data source. Note that this function will
 * automatically re-draw the table when the remote data has been loaded.
 *
 * @param {boolean} [reset=true] Reset (default) or hold the current paging
 *   position. A full re-sort and re-filter is performed when this method is
 *   called, which is why the pagination reset is the default action.
 * @returns {DataTables.Api} this
 */i("ajax.reload()",(function(e,t){return this.iterator("table",(function(r){Rt(r,t===false,e)}))}));
/**
 * Set the Ajax URL. Note that this will set the URL for all tables in the
 * current context.
 *
 * @param {string} url URL to set.
 * @returns {DataTables.Api} this
 */i("ajax.url()",(function(e){var r=this.context;if(e===void 0){if(r.length===0)return;r=r[0];return t.isPlainObject(r.ajax)?r.ajax.url:r.ajax}return this.iterator("table",(function(r){t.isPlainObject(r.ajax)?r.ajax.url=e:r.ajax=e}))}));
/**
 * Load data from the newly set Ajax URL. Note that this method is only
 * available when `ajax.url()` is used to set a URL. Additionally, this method
 * has the same effect as calling `ajax.reload()` but is provided for
 * convenience when setting a new URL. Like `ajax.reload()` it will
 * automatically redraw the table once the remote data has been loaded.
 *
 * @returns {DataTables.Api} this
 */i("ajax.url().load()",(function(e,t){return this.iterator("table",(function(r){Rt(r,t===false,e)}))}));var jt=function(e,t,r,n,i){var o,l,s,u=[],c=typeof t;t&&c!=="string"&&c!=="function"&&t.length!==void 0||(t=[t]);for(l=0,s=t.length;l<s;l++){o=r(typeof t[l]==="string"?t[l].trim():t[l]);o=o.filter((function(e){return e!==null&&e!==void 0}));o&&o.length&&(u=u.concat(o))}var f=a.selector[e];if(f.length)for(l=0,s=f.length;l<s;l++)u=f[l](n,i,u);return L(u)};var Pt=function(e){e||(e={});e.filter&&e.search===void 0&&(e.search=e.filter);return t.extend({columnOrder:"implied",search:"none",order:"current",page:"all"},e)};var Et=function(e){var t=new n(e.context[0]);e.length&&t.push(e[0]);t.selector=e.selector;t.length&&t[0].length>1&&t[0].splice(1);return t};var kt=function(e,t){var r,a,n,i=[],o=e.aiDisplay,l=e.aiDisplayMaster;var s=t.search,u=t.order,c=t.page;if(St(e)=="ssp")return s==="removed"?[]:x(0,l.length);if(c=="current")for(r=e._iDisplayStart,a=e.fnDisplayEnd();r<a;r++)i.push(o[r]);else if(u=="current"||u=="applied"){if(s=="none")i=l.slice();else if(s=="applied")i=o.slice();else if(s=="removed"){var f={};for(r=0,a=o.length;r<a;r++)f[o[r]]=null;l.forEach((function(e){Object.prototype.hasOwnProperty.call(f,e)||i.push(e)}))}}else if(u=="index"||u=="original"){for(r=0,a=e.aoData.length;r<a;r++)if(e.aoData[r])if(s=="none")i.push(r);else{n=o.indexOf(r);(n===-1&&s=="removed"||n>=0&&s=="applied")&&i.push(r)}}else if(typeof u==="number"){var d=st(e,u,"asc");if(s==="none")i=d;else for(r=0;r<d.length;r++){n=o.indexOf(d[r]);(n===-1&&s=="removed"||n>=0&&s=="applied")&&i.push(d[r])}}return i};var Mt=function(e,r,a){var n;var i=function(r){var i=p(r);var o=e.aoData;if(i!==null&&!a)return[i];n||(n=kt(e,a));if(i!==null&&n.indexOf(i)!==-1)return[i];if(r===null||r===void 0||r==="")return n;if(typeof r==="function")return n.map((function(e){var t=o[e];return r(e,t._aData,t.nTr)?e:null}));if(r.nodeName){var l=r._DT_RowIndex;var s=r._DT_CellIndex;if(l!==void 0)return o[l]&&o[l].nTr===r?[l]:[];if(s)return o[s.row]&&o[s.row].nTr===r.parentNode?[s.row]:[];var u=t(r).closest("*[data-dt-row]");return u.length?[u.data("dt-row")]:[]}if(typeof r==="string"&&r.charAt(0)==="#"){var c=e.aIds[r.replace(/^#/,"")];if(c!==void 0)return[c.idx]}var f=S(w(e.aoData,n,"nTr"));return t(f).filter(r).map((function(){return this._DT_RowIndex})).toArray()};var o=jt("row",r,i,e,a);a.order!=="current"&&a.order!=="applied"||it(e,o);return o};i("rows()",(function(e,r){if(e===void 0)e="";else if(t.isPlainObject(e)){r=e;e=""}r=Pt(r);var a=this.iterator("table",(function(t){return Mt(t,e,r)}),1);a.selector.rows=e;a.selector.opts=r;return a}));i("rows().nodes()",(function(){return this.iterator("row",(function(e,t){return e.aoData[t].nTr||void 0}),1)}));i("rows().data()",(function(){return this.iterator(true,"rows",(function(e,t){return w(e.aoData,t,"_aData")}),1)}));o("rows().cache()","row().cache()",(function(e){return this.iterator("row",(function(t,r){var a=t.aoData[r];return e==="search"?a._aFilterData:a._aSortData}),1)}));o("rows().invalidate()","row().invalidate()",(function(e){return this.iterator("row",(function(t,r){ce(t,r,e)}))}));o("rows().indexes()","row().index()",(function(){return this.iterator("row",(function(e,t){return t}),1)}));o("rows().ids()","row().id()",(function(e){var t=[];var r=this.context;for(var a=0,i=r.length;a<i;a++)for(var o=0,l=this[a].length;o<l;o++){var s=r[a].rowIdFn(r[a].aoData[this[a][o]]._aData);t.push((e===true?"#":"")+s)}return new n(r,t)}));o("rows().remove()","row().remove()",(function(){this.iterator("row",(function(e,t){var r=e.aoData;var a=r[t];var n=e.aiDisplayMaster.indexOf(t);n!==-1&&e.aiDisplayMaster.splice(n,1);e._iRecordsDisplay>0&&e._iRecordsDisplay--;wt(e);var i=e.rowIdFn(a._aData);i!==void 0&&delete e.aIds[i];r[t]=null}));return this}));i("rows.add()",(function(e){var t=this.iterator("table",(function(t){var r,a,n;var i=[];for(a=0,n=e.length;a<n;a++){r=e[a];r.nodeName&&r.nodeName.toUpperCase()==="TR"?i.push(Q(t,r)[0]):i.push(K(t,r))}return i}),1);var r=this.rows(-1);r.pop();_t(r,t);return r}));i("row()",(function(e,t){return Et(this.rows(e,t))}));i("row().data()",(function(e){var t=this.context;if(e===void 0)return t.length&&this.length&&this[0].length?t[0].aoData[this[0]]._aData:void 0;var r=t[0].aoData[this[0]];r._aData=e;Array.isArray(e)&&r.nTr&&r.nTr.id&&le(t[0].rowId)(e,r.nTr.id);ce(t[0],this[0],"data");return this}));i("row().node()",(function(){var e=this.context;if(e.length&&this.length&&this[0].length){var t=e[0].aoData[this[0]];if(t&&t.nTr)return t.nTr}return null}));i("row.add()",(function(e){e instanceof t&&e.length&&(e=e[0]);var r=this.iterator("table",(function(t){return e.nodeName&&e.nodeName.toUpperCase()==="TR"?Q(t,e)[0]:K(t,e)}));return this.row(r[0])}));t(document).on("plugin-init.dt",(function(e,t){var r=new n(t);r.on("stateSaveParams.DT",(function(e,t,r){var a=t.rowIdFn;var n=t.aiDisplayMaster;var i=[];for(var o=0;o<n.length;o++){var l=n[o];var s=t.aoData[l];s._detailsShow&&i.push("#"+a(s._aData))}r.childRows=i}));r.on("stateLoaded.DT",(function(e,t,a){Ht(r,a)}));Ht(r,r.state.loaded())}));var Ht=function(e,t){t&&t.childRows&&e.rows(t.childRows.map((function(e){return e.replace(/([^:\\]*(?:\\.[^:\\]*)*):/g,"$1\\:")}))).every((function(){Dt(e.settings()[0],null,"requestChild",[this])}))};var Wt=function(e,r,a,n){var i=[];var o=function(a,n){if(Array.isArray(a)||a instanceof t)for(var l=0,s=a.length;l<s;l++)o(a[l],n);else if(a.nodeName&&a.nodeName.toLowerCase()==="tr"){a.setAttribute("data-dt-row",r.idx);i.push(a)}else{var u=t("<tr><td></td></tr>").attr("data-dt-row",r.idx).addClass(n);t("td",u).addClass(n).html(a)[0].colSpan=B(e);i.push(u[0])}};o(a,n);r._details&&r._details.detach();r._details=t(i);r._detailsShow&&r._details.insertAfter(r.nTr)};var Xt=r.util.throttle((function(e){dt(e[0])}),500);var Vt=function(e,r){var a=e.context;if(a.length){var n=a[0].aoData[r!==void 0?r:e[0]];if(n&&n._details){n._details.remove();n._detailsShow=void 0;n._details=void 0;t(n.nTr).removeClass("dt-hasChild");Xt(a)}}};var Bt=function(e,r){var a=e.context;if(a.length&&e.length){var n=a[0].aoData[e[0]];if(n._details){n._detailsShow=r;if(r){n._details.insertAfter(n.nTr);t(n.nTr).addClass("dt-hasChild")}else{n._details.detach();t(n.nTr).removeClass("dt-hasChild")}Dt(a[0],null,"childRow",[r,e.row(e[0])]);qt(a[0]);Xt(a)}}};var qt=function(e){var r=new n(e);var a=".dt.DT_details";var i="draw"+a;var o="column-sizing"+a;var l="destroy"+a;var s=e.aoData;r.off(i+" "+o+" "+l);if(D(s,"_details").length>0){r.on(i,(function(t,a){e===a&&r.rows({page:"current"}).eq(0).each((function(e){var t=s[e];t._detailsShow&&t._details.insertAfter(t.nTr)}))}));r.on(o,(function(r,a){if(e===a){var n,i=B(a);for(var o=0,l=s.length;o<l;o++){n=s[o];n&&n._details&&n._details.each((function(){var e=t(this).children("td");e.length==1&&e.attr("colspan",i)}))}}}));r.on(l,(function(t,a){if(e===a)for(var n=0,i=s.length;n<i;n++)s[n]&&s[n]._details&&Vt(r,n)}))}};var Ut="";var zt=Ut+"row().child";var $t=zt+"()";i($t,(function(e,t){var r=this.context;if(e===void 0)return r.length&&this.length&&r[0].aoData[this[0]]?r[0].aoData[this[0]]._details:void 0;e===true?this.child.show():e===false?Vt(this):r.length&&this.length&&Wt(r[0],r[0].aoData[this[0]],e,t);return this}));i([zt+".show()",$t+".show()"],(function(){Bt(this,true);return this}));i([zt+".hide()",$t+".hide()"],(function(){Bt(this,false);return this}));i([zt+".remove()",$t+".remove()"],(function(){Vt(this);return this}));i(zt+".isShown()",(function(){var e=this.context;return e.length&&this.length&&e[0].aoData[this[0]]&&e[0].aoData[this[0]]._detailsShow||false}));var Yt=/^([^:]+)?:(name|title|visIdx|visible)$/;var Gt=function(e,t,r,a,n,i){var o=[];for(var l=0,s=n.length;l<s;l++)o.push(ee(e,n[l],t,i));return o};var Jt=function(e,r,a){var n=e.aoHeader;var i=e.titleRow;var o=null;if(a!==void 0)o=a;else if(i===true)o=0;else if(i===false)o=n.length-1;else if(i!==null)o=i;else{for(var l=0;l<n.length;l++)n[l][r].unique&&t("span.dt-column-title",n[l][r].cell).text()&&(o=l);o===null&&(o=0)}return n[o][r].cell};var Zt=function(e){var t=[];for(var r=0;r<e.length;r++)for(var a=0;a<e[r].length;a++){var n=e[r][a].cell;t.includes(n)||t.push(n)}return t};var Kt=function(e,r,a){var n,i,o=e.aoColumns,l=Zt(e.aoHeader);var s=function(r){var s=p(r);if(r==="")return x(o.length);if(s!==null)return[s>=0?s:o.length+s];if(typeof r==="function"){var u=kt(e,a);return o.map((function(t,a){return r(a,Gt(e,a,0,0,u),Jt(e,a))?a:null}))}var c=typeof r==="string"?r.match(Yt):"";if(c)switch(c[2]){case"visIdx":case"visible":if(c[1]&&c[1].match(/^\d+$/)){var f=parseInt(c[1],10);if(f<0){var d=o.map((function(e,t){return e.bVisible?t:null}));return[d[d.length+f]]}return[X(e,f)]}return o.map((function(e,r){return e.bVisible?c[1]?t(l[r]).filter(c[1]).length>0?r:null:r:null}));case"name":n||(n=D(o,"sName"));return n.map((function(e,t){return e===c[1]?t:null}));case"title":i||(i=D(o,"sTitle"));return i.map((function(e,t){return e===c[1]?t:null}));default:return[]}if(r.nodeName&&r._DT_CellIndex)return[r._DT_CellIndex.column];var v=t(l).filter(r).map((function(){return Z(this)})).toArray().sort((function(e,t){return e-t}));if(v.length||!r.nodeName)return v;var h=t(r).closest("*[data-dt-column]");return h.length?[h.data("dt-column")]:[]};var u=jt("column",r,s,e,a);return a.columnOrder&&a.columnOrder==="index"?u.sort((function(e,t){return e-t})):u};var Qt=function(e,r,a){var n,i,o,l,s=e.aoColumns,u=s[r],c=e.aoData;if(a===void 0)return u.bVisible;if(u.bVisible===a)return false;if(a){var f=D(s,"bVisible").indexOf(true,r+1);for(i=0,o=c.length;i<o;i++)if(c[i]){l=c[i].nTr;n=c[i].anCells;l&&l.insertBefore(n[r],n[f]||null)}}else t(D(e.aoData,"anCells",r)).detach();u.bVisible=a;rt(e);return true};i("columns()",(function(e,r){if(e===void 0)e="";else if(t.isPlainObject(e)){r=e;e=""}r=Pt(r);var a=this.iterator("table",(function(t){return Kt(t,e,r)}),1);a.selector.cols=e;a.selector.opts=r;return a}));o("columns().header()","column().header()",(function(e){return this.iterator("column",(function(t,r){return Jt(t,r,e)}),1)}));o("columns().footer()","column().footer()",(function(e){return this.iterator("column",(function(t,r){var a=t.aoFooter;return a.length?t.aoFooter[e!==void 0?e:0][r].cell:null}),1)}));o("columns().data()","column().data()",(function(){return this.iterator("column-rows",Gt,1)}));o("columns().render()","column().render()",(function(e){return this.iterator("column-rows",(function(t,r,a,n,i){return Gt(t,r,a,n,i,e)}),1)}));o("columns().dataSrc()","column().dataSrc()",(function(){return this.iterator("column",(function(e,t){return e.aoColumns[t].mData}),1)}));o("columns().cache()","column().cache()",(function(e){return this.iterator("column-rows",(function(t,r,a,n,i){return w(t.aoData,i,e==="search"?"_aFilterData":"_aSortData",r)}),1)}));o("columns().init()","column().init()",(function(){return this.iterator("column",(function(e,t){return e.aoColumns[t]}),1)}));o("columns().names()","column().name()",(function(){return this.iterator("column",(function(e,t){return e.aoColumns[t].sName}),1)}));o("columns().nodes()","column().nodes()",(function(){return this.iterator("column-rows",(function(e,t,r,a,n){return w(e.aoData,n,"anCells",t)}),1)}));o("columns().titles()","column().title()",(function(e,r){return this.iterator("column",(function(a,n){if(typeof e==="number"){r=e;e=void 0}var i=t("span.dt-column-title",this.column(n).header(r));if(e!==void 0){i.html(e);return this}return i.html()}),1)}));o("columns().types()","column().type()",(function(){return this.iterator("column",(function(e,t){var r=e.aoColumns[t].sType;r||z(e);return r}),1)}));o("columns().visible()","column().visible()",(function(e,r){var a=this;var n=[];var i=this.iterator("column",(function(t,r){if(e===void 0)return t.aoColumns[r].bVisible;Qt(t,r,e)&&n.push(r)}));e!==void 0&&this.iterator("table",(function(i){me(i,i.aoHeader);me(i,i.aoFooter);i.aiDisplay.length||t(i.nTBody).find("td[colspan]").attr("colspan",B(i));dt(i);a.iterator("column",(function(t,a){n.includes(a)&&Dt(t,null,"column-visibility",[t,a,e,r])}));n.length&&(r===void 0||r)&&a.columns.adjust()}));return i}));o("columns().widths()","column().width()",(function(){var e=this.columns(":visible").count();var r=t("<tr>").html("<td>"+Array(e).join("</td><td>")+"</td>");t(this.table().body()).append(r);var a=r.children().map((function(){return t(this).outerWidth()}));r.remove();return this.iterator("column",(function(e,t){var r=V(e,t);return r!==null?a[r]:0}),1)}));o("columns().indexes()","column().index()",(function(e){return this.iterator("column",(function(t,r){return e==="visible"?V(t,r):r}),1)}));i("columns.adjust()",(function(){return this.iterator("table",(function(e){e.containerWidth=-1;H(e)}),1)}));i("column.index()",(function(e,t){if(this.context.length!==0){var r=this.context[0];if(e==="fromVisible"||e==="toData")return X(r,t);if(e==="fromData"||e==="toVisible")return V(r,t)}}));i("column()",(function(e,t){return Et(this.columns(e,t))}));var er=function(e,r,a){var n=e.aoData;var i=kt(e,a);var o=S(w(n,i,"anCells"));var l=t(A([],o));var s;var u=e.aoColumns.length;var c,f,d,v,h,p;var g=function(r){var a=typeof r==="function";if(r===null||r===void 0||a){c=[];for(f=0,d=i.length;f<d;f++){s=i[f];for(v=0;v<u;v++){h={row:s,column:v};if(a){p=n[s];r(h,ee(e,s,v),p.anCells?p.anCells[v]:null)&&c.push(h)}else c.push(h)}}return c}if(t.isPlainObject(r))return r.column!==void 0&&r.row!==void 0&&i.indexOf(r.row)!==-1?[r]:[];var o=l.filter(r).map((function(e,t){return{row:t._DT_CellIndex.row,column:t._DT_CellIndex.column}})).toArray();if(o.length||!r.nodeName)return o;p=t(r).closest("*[data-dt-row]");return p.length?[{row:p.data("dt-row"),column:p.data("dt-column")}]:[]};return jt("cell",r,g,e,a)};i("cells()",(function(e,r,a){if(t.isPlainObject(e))if(e.row===void 0){a=e;e=null}else{a=r;r=null}if(t.isPlainObject(r)){a=r;r=null}if(r===null||r===void 0)return this.iterator("table",(function(t){return er(t,e,Pt(a))}));var n=a?{page:a.page,order:a.order,search:a.search}:{};var i=this.columns(r,n);var o=this.rows(e,n);var l,s,u,c;var f=this.iterator("table",(function(e,t){var r=[];for(l=0,s=o[t].length;l<s;l++)for(u=0,c=i[t].length;u<c;u++)r.push({row:o[t][l],column:i[t][u]});return r}),1);var d=a&&a.selected?this.cells(f,a):f;t.extend(d.selector,{cols:r,rows:e,opts:a});return d}));o("cells().nodes()","cell().node()",(function(){return this.iterator("cell",(function(e,t,r){var a=e.aoData[t];return a&&a.anCells?a.anCells[r]:void 0}),1)}));i("cells().data()",(function(){return this.iterator("cell",(function(e,t,r){return ee(e,t,r)}),1)}));o("cells().cache()","cell().cache()",(function(e){e=e==="search"?"_aFilterData":"_aSortData";return this.iterator("cell",(function(t,r,a){return t.aoData[r][e][a]}),1)}));o("cells().render()","cell().render()",(function(e){return this.iterator("cell",(function(t,r,a){return ee(t,r,a,e)}),1)}));o("cells().indexes()","cell().index()",(function(){return this.iterator("cell",(function(e,t,r){return{row:t,column:r,columnVisible:V(e,r)}}),1)}));o("cells().invalidate()","cell().invalidate()",(function(e){return this.iterator("cell",(function(t,r,a){ce(t,r,e,a)}))}));i("cell()",(function(e,t,r){return Et(this.cells(e,t,r))}));i("cell().data()",(function(e){var t=this.context;var r=this[0];if(e===void 0)return t.length&&r.length?ee(t[0],r[0].row,r[0].column):void 0;te(t[0],r[0].row,r[0].column,e);ce(t[0],r[0].row,"data",r[0].column);return this}));
/**
 * Get current ordering (sorting) that has been applied to the table.
 *
 * @returns {array} 2D array containing the sorting information for the first
 *   table in the current context. Each element in the parent array represents
 *   a column being sorted upon (i.e. multi-sorting with two columns would have
 *   2 inner arrays). The inner arrays may have 2 or 3 elements. The first is
 *   the column index that the sorting condition applies to, the second is the
 *   direction of the sort (`desc` or `asc`) and, optionally, the third is the
 *   index of the sorting order from the `column.sorting` initialisation array.
 */
/**
 * Set the ordering for the table.
 *
 * @param {integer} order Column index to sort upon.
 * @param {string} direction Direction of the sort to be applied (`asc` or `desc`)
 * @returns {DataTables.Api} this
 */
/**
 * Set the ordering for the table.
 *
 * @param {array} order 1D array of sorting information to be applied.
 * @param {array} [...] Optional additional sorting conditions
 * @returns {DataTables.Api} this
 */
/**
 * Set the ordering for the table.
 *
 * @param {array} order 2D array of sorting information to be applied.
 * @returns {DataTables.Api} this
 */i("order()",(function(e,t){var r=this.context;var a=Array.prototype.slice.call(arguments);if(e===void 0)return r.length!==0?r[0].aaSorting:void 0;typeof e==="number"?e=[[e,t]]:a.length>1&&(e=a);return this.iterator("table",(function(t){var r=[];ot(t,r,e);t.aaSorting=r}))}));
/**
 * Attach a sort listener to an element for a given column
 *
 * @param {node|jQuery|string} node Identifier for the element(s) to attach the
 *   listener to. This can take the form of a single DOM node, a jQuery
 *   collection of nodes or a jQuery selector which will identify the node(s).
 * @param {integer} column the column that a click on this node will sort on
 * @param {function} [callback] callback function when sort is run
 * @returns {DataTables.Api} this
 */i("order.listener()",(function(e,t,r){return this.iterator("table",(function(a){nt(a,e,{},t,r)}))}));i("order.fixed()",(function(e){if(!e){var r=this.context;var a=r.length?r[0].aaSortingFixed:void 0;return Array.isArray(a)?{pre:a}:a}return this.iterator("table",(function(r){r.aaSortingFixed=t.extend(true,{},e)}))}));i(["columns().order()","column().order()"],(function(e){var t=this;return e?this.iterator("table",(function(r,a){r.aaSorting=t[a].map((function(t){return[t,e]}))})):this.iterator("column",(function(e,t){var r=lt(e);for(var a=0,n=r.length;a<n;a++)if(r[a].col===t)return r[a].dir;return null}),1)}));o("columns().orderable()","column().orderable()",(function(e){return this.iterator("column",(function(t,r){var a=t.aoColumns[r];return e?a.asSorting:a.bSortable}),1)}));i("processing()",(function(e){return this.iterator("table",(function(t){Ye(t,e)}))}));i("search()",(function(e,r,a,n){var i=this.context;return e===void 0?i.length!==0?i[0].oPreviousSearch.search:void 0:this.iterator("table",(function(i){i.oFeatures.bFilter&&Pe(i,typeof r==="object"?t.extend(i.oPreviousSearch,r,{search:e}):t.extend(i.oPreviousSearch,{search:e,regex:r!==null&&r,smart:a===null||a,caseInsensitive:n===null||n}))}))}));i("search.fixed()",(function(e,t){var r=this.iterator(true,"table",(function(r){var a=r.searchFixed;if(!e)return Object.keys(a);if(t===void 0)return a[e];t===null?delete a[e]:a[e]=t;return this}));return e!==void 0&&t===void 0?r[0]:r}));o("columns().search()","column().search()",(function(e,r,a,n){return this.iterator("column",(function(i,o){var l=i.aoPreSearchCols;if(e===void 0)return l[o].search;if(i.oFeatures.bFilter){typeof r==="object"?t.extend(l[o],r,{search:e}):t.extend(l[o],{search:e,regex:r!==null&&r,smart:a===null||a,caseInsensitive:n===null||n});Pe(i,i.oPreviousSearch)}}))}));i(["columns().search.fixed()","column().search.fixed()"],(function(e,t){var r=this.iterator(true,"column",(function(r,a){var n=r.aoColumns[a].searchFixed;if(!e)return Object.keys(n);if(t===void 0)return n[e]||null;t===null?delete n[e]:n[e]=t;return this}));return e!==void 0&&t===void 0?r[0]:r}));i("state()",(function(e,r){if(!e)return this.context.length?this.context[0].oSavedState:null;var a=t.extend(true,{},e);return this.iterator("table",(function(e){r!==false&&(a.time=+new Date+100);ht(e,a,(function(){}))}))}));i("state.clear()",(function(){return this.iterator("table",(function(e){e.fnStateSaveCallback.call(e.oInstance,e,{})}))}));i("state.loaded()",(function(){return this.context.length?this.context[0].oLoadedState:null}));i("state.save()",(function(){return this.iterator("table",(function(e){dt(e)}))}));var tr;var rr;r.use=function(e,a){var n=typeof e==="string"?a:e;var i=typeof a==="string"?a:e;if(n===void 0&&typeof i==="string")switch(i){case"lib":case"jq":return t;case"win":return window;case"datetime":return r.DateTime;case"luxon":return sr;case"moment":return ur;case"bootstrap":return tr||window.bootstrap;case"foundation":return rr||window.Foundation;default:return null}if(i==="lib"||i==="jq"||n&&n.fn&&n.fn.jquery)t=n;else if(i==="win"||n&&n.document){window=n;document=n.document}else i==="datetime"||n&&n.type==="DateTime"?r.DateTime=n:i==="luxon"||n&&n.FixedOffsetZone?sr=n:i==="moment"||n&&n.isMoment?ur=n:i==="bootstrap"||n&&n.Modal&&n.Modal.NAME==="modal"?tr=n:(i==="foundation"||n&&n.Reveal)&&(rr=n)};
/**
 * CommonJS factory function pass through. This will check if the arguments
 * given are a window object or a jQuery object. If so they are set
 * accordingly.
 * @param {*} root Window
 * @param {*} jq jQUery
 * @returns {boolean} Indicator
 */r.factory=function(e,r){var a=false;if(e&&e.document){window=e;document=e.document}if(r&&r.fn&&r.fn.jquery){t=r;a=true}return a};
/**
 * Provide a common method for plug-ins to check the version of DataTables being
 * used, in order to ensure compatibility.
 *
 *  @param {string} version Version string to check for, in the format "X.Y.Z".
 *    Note that the formats "X" and "X.Y" are also acceptable.
 *  @param {string} [version2=current DataTables version] As above, but optional.
 *   If not given the current DataTables version will be used.
 *  @returns {boolean} true if this version of DataTables is greater or equal to
 *    the required version, or false if this version of DataTales is not
 *    suitable
 *  @static
 *  @dtopt API-Static
 *
 *  @example
 *    alert( $.fn.dataTable.versionCheck( '1.9.0' ) );
 */r.versionCheck=function(e,t){var a=t?t.split("."):r.version.split(".");var n=e.split(".");var i,o;for(var l=0,s=n.length;l<s;l++){i=parseInt(a[l],10)||0;o=parseInt(n[l],10)||0;if(i!==o)return i>o}return true};
/**
 * Check if a `<table>` node is a DataTable table already or not.
 *
 *  @param {node|jquery|string} table Table node, jQuery object or jQuery
 *      selector for the table to test. Note that if more than more than one
 *      table is passed on, only the first will be checked
 *  @returns {boolean} true the table given is a DataTable, or false otherwise
 *  @static
 *  @dtopt API-Static
 *
 *  @example
 *    if ( ! $.fn.DataTable.isDataTable( '#example' ) ) {
 *      $('#example').dataTable();
 *    }
 */r.isDataTable=function(e){var a=t(e).get(0);var n=false;if(e instanceof r.Api)return true;t.each(r.settings,(function(e,r){var i=r.nScrollHead?t("table",r.nScrollHead)[0]:null;var o=r.nScrollFoot?t("table",r.nScrollFoot)[0]:null;r.nTable!==a&&i!==a&&o!==a||(n=true)}));return n};
/**
 * Get all DataTable tables that have been initialised - optionally you can
 * select to get only currently visible tables.
 *
 *  @param {boolean} [visible=false] Flag to indicate if you want all (default)
 *    or visible tables only.
 *  @returns {array} Array of `table` nodes (not DataTable instances) which are
 *    DataTables
 *  @static
 *  @dtopt API-Static
 *
 *  @example
 *    $.each( $.fn.dataTable.tables(true), function () {
 *      $(table).DataTable().columns.adjust();
 *    } );
 */r.tables=function(e){var a=false;if(t.isPlainObject(e)){a=e.api;e=e.visible}var i=r.settings.filter((function(r){return!!(!e||e&&t(r.nTable).is(":visible"))})).map((function(e){return e.nTable}));return a?new n(i):i};
/**
 * Convert from camel case parameters to Hungarian notation. This is made public
 * for the extensions to provide the same ability as DataTables core to accept
 * either the 1.9 style Hungarian notation, or the 1.10+ style camelCase
 * parameters.
 *
 *  @param {object} src The model object which holds all parameters that can be
 *    mapped.
 *  @param {object} user The object to convert from camel case to Hungarian.
 *  @param {boolean} force When set to `true`, properties which already have a
 *    Hungarian value in the `user` object will be overwritten. Otherwise they
 *    won't be.
 */r.camelToHungarian=O;i("$()",(function(e,r){var a=this.rows(r).nodes(),n=t(a);return t([].concat(n.filter(e).toArray(),n.find(e).toArray()))}));t.each(["on","one","off"],(function(e,r){i(r+"()",(function(){var e=Array.prototype.slice.call(arguments);e[0]=e[0].split(/\s/).map((function(e){return e.match(/\.dt\b/)?e:e+".dt"})).join(" ");var a=t(this.tables().nodes());a[r].apply(a,e);return this}))}));i("clear()",(function(){return this.iterator("table",(function(e){ue(e)}))}));i("error()",(function(e){return this.iterator("table",(function(t){pt(t,0,e)}))}));i("settings()",(function(){return new n(this.context,this.context)}));i("init()",(function(){var e=this.context;return e.length?e[0].oInit:null}));i("data()",(function(){return this.iterator("table",(function(e){return D(e.aoData,"_aData")})).flatten()}));i("trigger()",(function(e,t,r){return this.iterator("table",(function(a){return Dt(a,null,e,t,r)})).flatten()}));i("ready()",(function(e){var t=this.context;return e?this.tables().every((function(){var t=this;this.context[0]._bInitComplete?e.call(t):this.on("init.dt.DT",(function(){e.call(t)}))})):t.length?t[0]._bInitComplete||false:null}));i("destroy()",(function(e){e=e||false;return this.iterator("table",(function(a){var i=a.oClasses;var o=a.nTable;var l=a.nTBody;var s=a.nTHead;var u=a.nTFoot;var c=t(o);var f=t(l);var d=t(a.nTableWrapper);var v=a.aoData.map((function(e){return e?e.nTr:null}));var h=i.order;a.bDestroying=true;Dt(a,"aoDestroyCallback","destroy",[a],true);e||new n(a).columns().visible(true);a.resizeObserver&&a.resizeObserver.disconnect();d.off(".DT").find(":not(tbody *)").off(".DT");t(window).off(".DT-"+a.sInstance);if(o!=s.parentNode){c.children("thead").detach();c.append(s)}if(u&&o!=u.parentNode){c.children("tfoot").detach();c.append(u)}ar(s,"header");ar(u,"footer");a.colgroup.remove();a.aaSorting=[];a.aaSortingFixed=[];ct(a);t(c).find("th, td").removeClass(t.map(r.ext.type.className,(function(e){return e})).join(" "));t("th, td",s).removeClass(h.none+" "+h.canAsc+" "+h.canDesc+" "+h.isAsc+" "+h.isDesc).css("width","").removeAttr("aria-sort");f.children().detach();f.append(v);var p=a.nTableWrapper.parentNode;var g=a.nTableWrapper.nextSibling;var m=e?"remove":"detach";c[m]();d[m]();if(!e&&p){p.insertBefore(o,g);c.css("width",a.sDestroyWidth).removeClass(i.table)}var b=r.settings.indexOf(a);b!==-1&&r.settings.splice(b,1)}))}));t.each(["column","row","cell"],(function(e,t){i(t+"s().every()",(function(e){var r=this.selector.opts;var a=this;var n;var i=0;return this.iterator("every",(function(o,l,s){n=a[t](l,r);t==="cell"?e.call(n,n[0][0].row,n[0][0].column,s,i):e.call(n,l,s,i);i++}))}))}));i("i18n()",(function(e,r,a){var n=this.context[0];var i=oe(e)(n.oLanguage);i===void 0&&(i=r);t.isPlainObject(i)&&(i=a!==void 0&&i[a]!==void 0?i[a]:i._);return typeof i==="string"?i.replace("%d",a):i}));function ar(e,r){t(e).find("span.dt-column-order").remove();t(e).find("span.dt-column-title").each((function(){var e=t(this).html();t(this).parent().parent().append(e);t(this).remove()}));t(e).find("div.dt-column-"+r).remove();t("th, td",e).removeAttr("data-dt-column")}
/**
 * Version string for plug-ins to check compatibility. Allowed format is
 * `a.b.c-d` where: a:int, b:int, c:int, d:string(dev|beta|alpha). `d` is used
 * only for non-release builds. See https://semver.org/ for more information.
 *  @member
 *  @type string
 *  @default Version number
 */r.version="2.3.1";
/**
 * Private data store, containing all of the settings objects that are
 * created for the tables on a given page.
 *
 * Note that the `DataTable.settings` object is aliased to
 * `jQuery.fn.dataTableExt` through which it may be accessed and
 * manipulated, or `jQuery.fn.dataTable.settings`.
 *  @member
 *  @type array
 *  @default []
 *  @private
 */r.settings=[];r.models={};r.models.oSearch={caseInsensitive:true,search:"",regex:false,smart:true,return:false};r.models.oRow={nTr:null,anCells:null,_aData:[],_aSortData:null,_aFilterData:null,_sFilterRow:null,src:null,idx:-1,displayData:null};r.models.oColumn={idx:null,aDataSort:null,asSorting:null,bSearchable:null,bSortable:null,bVisible:null,_sManualType:null,_bAttrSrc:false,fnCreatedCell:null,fnGetData:null,fnSetData:null,mData:null,mRender:null,sClass:null,sContentPadding:null,sDefaultContent:null,sName:null,sSortDataType:"std",sSortingClass:null,sTitle:null,sType:null,sWidth:null,sWidthOrig:null,maxLenString:null,searchFixed:null};r.defaults={aaData:null,aaSorting:[[0,"asc"]],aaSortingFixed:[],ajax:null,aLengthMenu:[10,25,50,100],aoColumns:null,aoColumnDefs:null,aoSearchCols:[],bAutoWidth:true,bDeferRender:true,bDestroy:false,bFilter:true,
/**
	 * Used only for compatiblity with DT1
	 * @deprecated
	 */
bInfo:true,
/**
	 * Used only for compatiblity with DT1
	 * @deprecated
	 */
bLengthChange:true,bPaginate:true,bProcessing:false,bRetrieve:false,bScrollCollapse:false,bServerSide:false,bSort:true,bSortMulti:true,bSortCellsTop:null,titleRow:null,bSortClasses:true,bStateSave:false,fnCreatedRow:null,fnDrawCallback:null,fnFooterCallback:null,fnFormatNumber:function(e){return e.toString().replace(/\B(?=(\d{3})+(?!\d))/g,this.oLanguage.sThousands)},fnHeaderCallback:null,fnInfoCallback:null,fnInitComplete:null,fnPreDrawCallback:null,fnRowCallback:null,fnStateLoadCallback:function(e){try{return JSON.parse((e.iStateDuration===-1?sessionStorage:localStorage).getItem("DataTables_"+e.sInstance+"_"+location.pathname))}catch(e){return{}}},fnStateLoadParams:null,fnStateLoaded:null,fnStateSaveCallback:function(e,t){try{(e.iStateDuration===-1?sessionStorage:localStorage).setItem("DataTables_"+e.sInstance+"_"+location.pathname,JSON.stringify(t))}catch(e){}},fnStateSaveParams:null,iStateDuration:7200,iDisplayLength:10,iDisplayStart:0,iTabIndex:0,oClasses:{},oLanguage:{oAria:{orderable:": Activate to sort",orderableReverse:": Activate to invert sorting",orderableRemove:": Activate to remove sorting",paginate:{first:"First",last:"Last",next:"Next",previous:"Previous",number:""}},oPaginate:{sFirst:"«",sLast:"»",sNext:"›",sPrevious:"‹"},entries:{_:"entries",1:"entry"},lengthLabels:{"-1":"All"},sEmptyTable:"No data available in table",sInfo:"Showing _START_ to _END_ of _TOTAL_ _ENTRIES-TOTAL_",sInfoEmpty:"Showing 0 to 0 of 0 _ENTRIES-TOTAL_",sInfoFiltered:"(filtered from _MAX_ total _ENTRIES-MAX_)",sInfoPostFix:"",sDecimal:"",sThousands:",",sLengthMenu:"_MENU_ _ENTRIES_ per page",sLoadingRecords:"Loading...",sProcessing:"",sSearch:"Search:",
/**
		 * Assign a `placeholder` attribute to the search `input` element
		 *  @type string
		 *  @default 
		 *
		 *  @dtopt Language
		 *  @name DataTable.defaults.language.searchPlaceholder
		 */
sSearchPlaceholder:"",sUrl:"",sZeroRecords:"No matching records found"},orderDescReverse:true,oSearch:t.extend({},r.models.oSearch),layout:{topStart:"pageLength",topEnd:"search",bottomStart:"info",bottomEnd:"paging"},sDom:null,searchDelay:null,sPaginationType:"",sScrollX:"",sScrollXInner:"",sScrollY:"",sServerMethod:"GET",renderer:null,rowId:"DT_RowId",caption:null,iDeferLoading:null,on:null};F(r.defaults);r.defaults.column={aDataSort:null,iDataSort:-1,ariaTitle:"",asSorting:["asc","desc",""],bSearchable:true,bSortable:true,bVisible:true,fnCreatedCell:null,mData:null,mRender:null,sCellType:"td",sClass:"",sContentPadding:"",sDefaultContent:null,sName:"",sSortDataType:"std",sTitle:null,sType:null,sWidth:null};F(r.defaults.column);r.models.oSettings={oFeatures:{bAutoWidth:null,bDeferRender:null,bFilter:null,
/**
		 * Used only for compatiblity with DT1
		 * @deprecated
		 */
bInfo:true,
/**
		 * Used only for compatiblity with DT1
		 * @deprecated
		 */
bLengthChange:true,bPaginate:null,bProcessing:null,bServerSide:null,bSort:null,bSortMulti:null,bSortClasses:null,bStateSave:null},oScroll:{bCollapse:null,iBarWidth:0,sX:null,
/**
		 * Width to expand the table to when using x-scrolling. Typically you
		 * should not need to use this.
		 * Note that this parameter will be set by the initialisation routine. To
		 * set a default use {@link DataTable.defaults}.
		 *  @deprecated
		 */
sXInner:null,sY:null},oLanguage:{fnInfoCallback:null},oBrowser:{bScrollbarLeft:false,barWidth:0},ajax:null,aanFeatures:[],aoData:[],aiDisplay:[],aiDisplayMaster:[],aIds:{},aoColumns:[],aoHeader:[],aoFooter:[],oPreviousSearch:{},searchFixed:{},aoPreSearchCols:[],aaSorting:null,aaSortingFixed:[],sDestroyWidth:0,aoRowCallback:[],aoHeaderCallback:[],aoFooterCallback:[],aoDrawCallback:[],aoRowCreatedCallback:[],aoPreDrawCallback:[],aoInitComplete:[],aoStateSaveParams:[],aoStateLoadParams:[],aoStateLoaded:[],sTableId:"",nTable:null,nTHead:null,nTFoot:null,nTBody:null,nTableWrapper:null,bInitialised:false,aoOpenRows:[],sDom:null,searchDelay:null,sPaginationType:"two_button",pagingControls:0,iStateDuration:0,aoStateSave:[],aoStateLoad:[],oSavedState:null,oLoadedState:null,bAjaxDataGet:true,jqXHR:null,json:void 0,oAjaxData:void 0,sServerMethod:null,fnFormatNumber:null,aLengthMenu:null,iDraw:0,bDrawing:false,iDrawError:-1,_iDisplayLength:10,_iDisplayStart:0,_iRecordsTotal:0,_iRecordsDisplay:0,oClasses:{},
/**
	 * Flag attached to the settings object so you can check in the draw
	 * callback if filtering has been done in the draw. Deprecated in favour of
	 * events.
	 *  @deprecated
	 */
bFiltered:false,
/**
	 * Flag attached to the settings object so you can check in the draw
	 * callback if sorting has been done in the draw. Deprecated in favour of
	 * events.
	 *  @deprecated
	 */
bSorted:false,bSortCellsTop:null,oInit:null,aoDestroyCallback:[],fnRecordsTotal:function(){return St(this)=="ssp"?this._iRecordsTotal*1:this.aiDisplayMaster.length},fnRecordsDisplay:function(){return St(this)=="ssp"?this._iRecordsDisplay*1:this.aiDisplay.length},fnDisplayEnd:function(){var e=this._iDisplayLength,t=this._iDisplayStart,r=t+e,a=this.aiDisplay.length,n=this.oFeatures,i=n.bPaginate;return n.bServerSide?i===false||e===-1?t+a:Math.min(t+e,this._iRecordsDisplay):!i||r>a||e===-1?a:r},oInstance:null,sInstance:null,iTabIndex:0,nScrollHead:null,nScrollFoot:null,aLastSort:[],oPlugins:{},rowIdFn:null,rowId:null,caption:"",captionNode:null,colgroup:null,deferLoading:null,typeDetect:true,resizeObserver:null,containerWidth:-1,orderDescReverse:null,orderIndicators:true,orderHandler:true,titleRow:null};var nr=r.ext.pager;t.extend(nr,{simple:function(){return["previous","next"]},full:function(){return["first","previous","next","last"]},numbers:function(){return["numbers"]},simple_numbers:function(){return["previous","numbers","next"]},full_numbers:function(){return["first","previous","numbers","next","last"]},first_last:function(){return["first","last"]},first_last_numbers:function(){return["first","numbers","last"]},_numbers:Ir,numbers_length:7});t.extend(true,r.ext.renderer,{pagingButton:{_:function(e,r,a,n,i){var o=e.oClasses.paging;var l=[o.button];var s;n&&l.push(o.active);i&&l.push(o.disabled);s=r==="ellipsis"?t('<span class="ellipsis"></span>').html(a)[0]:t("<button>",{class:l.join(" "),role:"link",type:"button"}).html(a);return{display:s,clicker:s}}},pagingContainer:{_:function(e,t){return t}}});var ir=function(e,t){return function(r){if(h(r)||typeof r!=="string")return r;r=r.replace(s," ");e&&(r=T(r));t&&(r=C(r,false));return r}};function or(e,t,r,a,n){return ur?e[t](n):sr?e[r](n):a?e[a](n):e}var lr=false;var sr;var ur;function cr(){window.luxon&&!sr&&(sr=window.luxon);window.moment&&!ur&&(ur=window.moment)}function fr(e,t,r){var a;cr();if(ur){a=ur.utc(e,t,r,true);if(!a.isValid())return null}else if(sr){a=t&&typeof e==="string"?sr.DateTime.fromFormat(e,t):sr.DateTime.fromISO(e);if(!a.isValid)return null;a=a.setLocale(r)}else if(t){lr||alert("DataTables warning: Formatted date without Moment.js or Luxon - https://datatables.net/tn/17");lr=true}else a=new Date(e);return a}function dr(e){return function(t,a,n,i){if(arguments.length===0){n="en";a=null;t=null}else if(arguments.length===1){n="en";a=t;t=null}else if(arguments.length===2){n=a;a=t;t=null}var o="datetime"+(a?"-"+a:"");r.ext.type.order[o+"-pre"]||r.type(o,{detect:function(e){return e===o&&o},order:{pre:function(e){return e.valueOf()}},className:"dt-right"});return function(r,l){if(r===null||r===void 0)if(i==="--now"){var s=new Date;r=new Date(Date.UTC(s.getFullYear(),s.getMonth(),s.getDate(),s.getHours(),s.getMinutes(),s.getSeconds()))}else r="";if(l==="type")return o;if(r==="")return l!=="sort"?"":fr("0000-01-01 00:00:00",null,n);if(a!==null&&t===a&&l!=="sort"&&l!=="type"&&!(r instanceof Date))return r;var u=fr(r,t,n);if(u===null)return r;if(l==="sort")return u;var c=a===null?or(u,"toDate","toJSDate","")[e]():or(u,"format","toFormat","toISOString",a);return l==="display"?_(c):c}}}var vr=",";var hr=".";if(window.Intl!==void 0)try{var pr=(new Intl.NumberFormat).formatToParts(100000.1);for(var gr=0;gr<pr.length;gr++)pr[gr].type==="group"?vr=pr[gr].value:pr[gr].type==="decimal"&&(hr=pr[gr].value)}catch(e){}r.datetime=function(e,t){var a="datetime-"+e;t||(t="en");r.ext.type.order[a]||r.type(a,{detect:function(r){var n=fr(r,e,t);return!(r!==""&&!n)&&a},order:{pre:function(r){return fr(r,e,t)||0}},className:"dt-right"})};r.render={date:dr("toLocaleDateString"),datetime:dr("toLocaleString"),time:dr("toLocaleTimeString"),number:function(e,t,r,a,n){e!==null&&e!==void 0||(e=vr);t!==null&&t!==void 0||(t=hr);return{display:function(i){if(typeof i!=="number"&&typeof i!=="string")return i;if(i===""||i===null)return i;var o=i<0?"-":"";var l=parseFloat(i);var s=Math.abs(l);if(s>=1e11||s<1e-4&&s!==0){var u=l.toExponential(r).split(/e\+?/);return u[0]+" x 10<sup>"+u[1]+"</sup>"}if(isNaN(l))return _(i);l=l.toFixed(r);i=Math.abs(l);var c=parseInt(i,10);var f=r?t+(i-c).toFixed(r).substring(2):"";c===0&&parseFloat(f)===0&&(o="");return o+(a||"")+c.toString().replace(/\B(?=(\d{3})+(?!\d))/g,e)+f+(n||"")}}},text:function(){return{display:_,filter:_}}};var mr=r.ext.type;r.type=function(e,t,r){if(!t)return{className:mr.className[e],detect:mr.detect.find((function(t){return t._name===e})),order:{pre:mr.order[e+"-pre"],asc:mr.order[e+"-asc"],desc:mr.order[e+"-desc"]},render:mr.render[e],search:mr.search[e]};var a=function(t,r){mr[t][e]=r};var n=function(t){Object.defineProperty(t,"_name",{value:e});var r=mr.detect.findIndex((function(t){return t._name===e}));r===-1?mr.detect.unshift(t):mr.detect.splice(r,1,t)};var i=function(t){mr.order[e+"-pre"]=t.pre;mr.order[e+"-asc"]=t.asc;mr.order[e+"-desc"]=t.desc};if(r===void 0){r=t;t=null}if(t==="className")a("className",r);else if(t==="detect")n(r);else if(t==="order")i(r);else if(t==="render")a("render",r);else if(t==="search")a("search",r);else if(!t){r.className&&a("className",r.className);r.detect!==void 0&&n(r.detect);r.order&&i(r.order);r.render!==void 0&&a("render",r.render);r.search!==void 0&&a("search",r.search)}};r.types=function(){return mr.detect.map((function(e){return e._name}))};var br=function(e,t){e=e!==null&&e!==void 0?e.toString().toLowerCase():"";t=t!==null&&t!==void 0?t.toString().toLowerCase():"";return e.localeCompare(t,navigator.languages[0]||navigator.language,{numeric:true,ignorePunctuation:true})};var yr=function(e,t){e=T(e);t=T(t);return br(e,t)};r.type("string",{detect:function(){return"string"},order:{pre:function(e){return h(e)&&typeof e!=="boolean"?"":typeof e==="string"?e.toLowerCase():e.toString?e.toString():""}},search:ir(false,true)});r.type("string-utf8",{detect:{allOf:function(e){return true},oneOf:function(e){return!h(e)&&navigator.languages&&typeof e==="string"&&e.match(/[^\x00-\x7F]/)}},order:{asc:br,desc:function(e,t){return br(e,t)*-1}},search:ir(false,true)});r.type("html",{detect:{allOf:function(e){return h(e)||typeof e==="string"&&e.indexOf("<")!==-1},oneOf:function(e){return!h(e)&&typeof e==="string"&&e.indexOf("<")!==-1}},order:{pre:function(e){return h(e)?"":e.replace?T(e).trim().toLowerCase():e+""}},search:ir(true,true)});r.type("html-utf8",{detect:{allOf:function(e){return h(e)||typeof e==="string"&&e.indexOf("<")!==-1},oneOf:function(e){return navigator.languages&&!h(e)&&typeof e==="string"&&e.indexOf("<")!==-1&&typeof e==="string"&&e.match(/[^\x00-\x7F]/)}},order:{asc:yr,desc:function(e,t){return yr(e,t)*-1}},search:ir(true,true)});r.type("date",{className:"dt-type-date",detect:{allOf:function(e){if(e&&!(e instanceof Date)&&!f.test(e))return null;var t=Date.parse(e);return t!==null&&!isNaN(t)||h(e)},oneOf:function(e){return e instanceof Date||typeof e==="string"&&f.test(e)}},order:{pre:function(e){var t=Date.parse(e);return isNaN(t)?-Infinity:t}}});r.type("html-num-fmt",{className:"dt-type-numeric",detect:{allOf:function(e,t){var r=t.oLanguage.sDecimal;return y(e,r,true,false)},oneOf:function(e,t){var r=t.oLanguage.sDecimal;return y(e,r,true,false)}},order:{pre:function(e,t){var r=t.oLanguage.sDecimal;return Dr(e,r,u,v)}},search:ir(true,true)});r.type("html-num",{className:"dt-type-numeric",detect:{allOf:function(e,t){var r=t.oLanguage.sDecimal;return y(e,r,false,true)},oneOf:function(e,t){var r=t.oLanguage.sDecimal;return y(e,r,false,false)}},order:{pre:function(e,t){var r=t.oLanguage.sDecimal;return Dr(e,r,u)}},search:ir(true,true)});r.type("num-fmt",{className:"dt-type-numeric",detect:{allOf:function(e,t){var r=t.oLanguage.sDecimal;return m(e,r,true,true)},oneOf:function(e,t){var r=t.oLanguage.sDecimal;return m(e,r,true,false)}},order:{pre:function(e,t){var r=t.oLanguage.sDecimal;return Dr(e,r,v)}}});r.type("num",{className:"dt-type-numeric",detect:{allOf:function(e,t){var r=t.oLanguage.sDecimal;return m(e,r,false,true)},oneOf:function(e,t){var r=t.oLanguage.sDecimal;return m(e,r,false,false)}},order:{pre:function(e,t){var r=t.oLanguage.sDecimal;return Dr(e,r)}}});var Dr=function(e,t,r,a){if(e!==0&&(!e||e==="-"))return-Infinity;var n=typeof e;if(n==="number"||n==="bigint")return e;t&&(e=g(e,t));if(e.replace){r&&(e=e.replace(r,""));a&&(e=e.replace(a,""))}return e*1};t.extend(true,r.ext.renderer,{footer:{_:function(e,t,r){t.addClass(r.tfoot.cell)}},header:{_:function(e,r,a){r.addClass(a.thead.cell);e.oFeatures.bSort||r.addClass(a.order.none);var n=e.titleRow;var i=r.closest("thead").find("tr");var o=r.parent().index();r.attr("data-dt-order")==="disable"||r.parent().attr("data-dt-order")==="disable"||n===true&&o!==0||n===false&&o!==i.length-1||typeof n==="number"&&o!==n||t(e.nTable).on("order.dt.DT column-visibility.dt.DT",(function(t,n,i){if(e===n){var o=n.sortDetails;if(o){var l=D(o,"col");if(t.type!=="column-visibility"||l.includes(i)){var s;var u=a.order;var c=n.api.columns(r);var f=e.aoColumns[c.flatten()[0]];var d=c.orderable().includes(true);var v="";var h=c.indexes();var p=c.orderable(true).flatten();var g=e.iTabIndex;var m=n.orderHandler&&d;r.removeClass(u.isAsc+" "+u.isDesc).toggleClass(u.none,!d).toggleClass(u.canAsc,m&&p.includes("asc")).toggleClass(u.canDesc,m&&p.includes("desc"));var b=true;for(s=0;s<h.length;s++)l.includes(h[s])||(b=false);if(b){var y=c.order();r.addClass(y.includes("asc")?u.isAsc:""+y.includes("desc")?u.isDesc:"")}var w=-1;for(s=0;s<l.length;s++)if(e.aoColumns[l[s]].bVisible){w=l[s];break}if(h[0]==w){var x=o[0];var S=f.asSorting;r.attr("aria-sort",x.dir==="asc"?"ascending":"descending");v=S[x.index+1]?"Reverse":"Remove"}else r.removeAttr("aria-sort");if(d){var T=r.find(".dt-column-order");T.attr("role","button").attr("aria-label",d?f.ariaTitle+n.api.i18n("oAria.orderable"+v):f.ariaTitle);g!==-1&&T.attr("tabindex",g)}}}}}))}},layout:{_:function(e,a,n){var i=e.oClasses.layout;var o=t("<div/>").attr("id",n.id||null).addClass(n.className||i.row).appendTo(a);r.ext.renderer.layout._forLayoutRow(n,(function(e,r){if(e!=="id"&&e!=="className"){var a="";if(r.table){o.addClass(i.tableRow);a+=i.tableCell+" "}a+=e==="start"?i.start:e==="end"?i.end:i.full;t("<div/>").attr({id:r.id||null,class:r.className?r.className:i.cell+" "+a}).append(r.contents).appendTo(o)}}))},_forLayoutRow:function(e,t){var r=function(e){switch(e){case"":return 0;case"start":return 1;case"end":return 2;default:return 3}};Object.keys(e).sort((function(e,t){return r(e)-r(t)})).forEach((function(r){t(r,e[r])}))}}});r.feature={};r.feature.register=function(e,t,n){r.ext.features[e]=t;n&&a.feature.push({cFeature:n,fnInit:t})};function wr(e,t,r){r&&(e[t]=r)}r.feature.register("div",(function(e,r){var a=t("<div>")[0];if(r){wr(a,"className",r.className);wr(a,"id",r.id);wr(a,"innerHTML",r.html);wr(a,"textContent",r.text)}return a}));r.feature.register("info",(function(e,r){if(!e.oFeatures.bInfo)return null;var a=e.oLanguage,n=e.sTableId,i=t("<div/>",{class:e.oClasses.info.container});r=t.extend({callback:a.fnInfoCallback,empty:a.sInfoEmpty,postfix:a.sInfoPostFix,search:a.sInfoFiltered,text:a.sInfo},r);e.aoDrawCallback.push((function(e){xr(e,r,i)}));if(!e._infoEl){i.attr({"aria-live":"polite",id:n+"_info",role:"status"});t(e.nTable).attr("aria-describedby",n+"_info");e._infoEl=i}return i}),"i");
/**
 * Update the information elements in the display
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function xr(e,t,r){var a=e._iDisplayStart+1,n=e.fnDisplayEnd(),i=e.fnRecordsTotal(),o=e.fnRecordsDisplay(),l=o?t.text:t.empty;o!==i&&(l+=" "+t.search);l+=t.postfix;l=Tt(e,l);t.callback&&(l=t.callback.call(e.oInstance,e,a,n,i,o,l));r.html(l);Dt(e,null,"info",[e,r[0],l])}var Sr=0;r.feature.register("search",(function(e,a){if(!e.oFeatures.bFilter)return null;var n=e.oClasses.search;var i=e.sTableId;var o=e.oLanguage;var l=e.oPreviousSearch;var s='<input type="search" class="'+n.input+'"/>';a=t.extend({placeholder:o.sSearchPlaceholder,processing:false,text:o.sSearch},a);a.text.indexOf("_INPUT_")===-1&&(a.text+="_INPUT_");a.text=Tt(e,a.text);var u=a.text.match(/_INPUT_$/);var c=a.text.match(/^_INPUT_/);var f=a.text.replace(/_INPUT_/,"");var d="<label>"+a.text+"</label>";c?d="_INPUT_<label>"+f+"</label>":u&&(d="<label>"+f+"</label>_INPUT_");var v=t("<div>").addClass(n.container).append(d.replace(/_INPUT_/,s));v.find("label").attr("for","dt-search-"+Sr);v.find("input").attr("id","dt-search-"+Sr);Sr++;var h=function(t){var r=this.value;l.return&&t.key!=="Enter"||r!=l.search&&Ge(e,a.processing,(function(){l.search=r;Pe(e,l);e._iDisplayStart=0;be(e)}))};var p=e.searchDelay!==null?e.searchDelay:0;var g=t("input",v).val(l.search).attr("placeholder",a.placeholder).on("keyup.DT search.DT input.DT paste.DT cut.DT",p?r.util.debounce(h,p):h).on("mouseup.DT",(function(e){setTimeout((function(){h.call(g[0],e)}),10)})).on("keypress.DT",(function(e){if(e.keyCode==13)return false})).attr("aria-controls",i);t(e.nTable).on("search.dt.DT",(function(t,r){e===r&&g[0]!==document.activeElement&&g.val(typeof l.search!=="function"?l.search:"")}));return v}),"f");r.feature.register("paging",(function(e,a){if(!e.oFeatures.bPaginate)return null;a=t.extend({buttons:r.ext.pager.numbers_length,type:e.sPaginationType,boundaryNumbers:true,firstLast:true,previousNext:true,numbers:true},a);var n=t("<div/>").addClass(e.oClasses.paging.container+(a.type?" paging_"+a.type:"")).append(t("<nav>").attr("aria-label","pagination").addClass(e.oClasses.paging.nav));var i=function(){_r(e,n.children(),a)};e.aoDrawCallback.push(i);t(e.nTable).on("column-sizing.dt.DT",i);return n}),"p");function Tr(e){var t=[];e.numbers&&t.push("numbers");if(e.previousNext){t.unshift("previous");t.push("next")}if(e.firstLast){t.unshift("first");t.push("last")}return t}function _r(e,a,n){if(e._bInitComplete){var i=n.type?r.ext.pager[n.type]:Tr,o=e.oLanguage.oAria.paginate||{},l=e._iDisplayStart,s=e._iDisplayLength,u=e.fnRecordsDisplay(),c=s===-1,f=c?0:Math.ceil(l/s),d=c?1:Math.ceil(u/s),v=[],h=[],p=i(n).map((function(e){return e==="numbers"?Ir(f,d,n.buttons,n.boundaryNumbers):e}));v=v.concat.apply(v,p);for(var g=0;g<v.length;g++){var m=v[g];var b=Cr(e,m,f,d);var y=xt(e,"pagingButton")(e,m,b.display,b.active,b.disabled);var D=typeof m==="string"?o[m]:o.number?o.number+(m+1):null;t(y.clicker).attr({"aria-controls":e.sTableId,"aria-disabled":b.disabled?"true":null,"aria-current":b.active?"page":null,"aria-label":D,"data-dt-idx":m,tabIndex:b.disabled?-1:e.iTabIndex&&y.clicker[0].nodeName.toLowerCase()!=="span"?e.iTabIndex:null});typeof m!=="number"&&t(y.clicker).addClass(m);bt(y.clicker,{action:m},(function(t){t.preventDefault();ze(e,t.data.action,true)}));h.push(y.display)}var w=xt(e,"pagingContainer")(e,h);var x=a.find(document.activeElement).data("dt-idx");a.empty().append(w);x!==void 0&&a.find("[data-dt-idx="+x+"]").trigger("focus");if(h.length){var S=t(h[0]).outerHeight();n.buttons>1&&S>0&&t(a).height()>=S*2-10&&_r(e,a,t.extend({},n,{buttons:n.buttons-2}))}}}
/**
 * Get properties for a button based on the current paging state of the table
 *
 * @param {*} settings DT settings object
 * @param {*} button The button type in question
 * @param {*} page Table's current page
 * @param {*} pages Number of pages
 * @returns Info object
 */function Cr(e,t,r,a){var n=e.oLanguage.oPaginate;var i={display:"",active:false,disabled:false};switch(t){case"ellipsis":i.display="&#x2026;";break;case"first":i.display=n.sFirst;r===0&&(i.disabled=true);break;case"previous":i.display=n.sPrevious;r===0&&(i.disabled=true);break;case"next":i.display=n.sNext;a!==0&&r!==a-1||(i.disabled=true);break;case"last":i.display=n.sLast;a!==0&&r!==a-1||(i.disabled=true);break;default:if(typeof t==="number"){i.display=e.fnFormatNumber(t+1);r===t&&(i.active=true)}break}return i}
/**
 * Compute what number buttons to show in the paging control
 *
 * @param {*} page Current page
 * @param {*} pages Total number of pages
 * @param {*} buttons Target number of number buttons
 * @param {boolean} addFirstLast Indicate if page 1 and end should be included
 * @returns Buttons to show
 */function Ir(e,t,r,a){var n=[],i=Math.floor(r/2),o=a?2:1,l=a?1:0;if(t<=r)n=x(0,t);else if(r===1)n=[e];else if(r===3)if(e<=1)n=[0,1,"ellipsis"];else if(e>=t-2){n=x(t-2,t);n.unshift("ellipsis")}else n=["ellipsis",e,"ellipsis"];else if(e<=i){n=x(0,r-o);n.push("ellipsis");a&&n.push(t-1)}else if(e>=t-1-i){n=x(t-(r-o),t);n.unshift("ellipsis");a&&n.unshift(0)}else{n=x(e-i+o,e+i-l);n.push("ellipsis");n.unshift("ellipsis");if(a){n.push(t-1);n.unshift(0)}}return n}var Lr=0;r.feature.register("pageLength",(function(e,r){var a=e.oFeatures;if(!a.bPaginate||!a.bLengthChange)return null;r=t.extend({menu:e.aLengthMenu,text:e.oLanguage.sLengthMenu},r);var n,i=e.oClasses.length,o=e.sTableId,l=r.menu,s=[],u=[];if(Array.isArray(l[0])){s=l[0];u=l[1]}else for(n=0;n<l.length;n++)if(t.isPlainObject(l[n])){s.push(l[n].value);u.push(l[n].label)}else{s.push(l[n]);u.push(l[n])}var c=r.text.match(/_MENU_$/);var f=r.text.match(/^_MENU_/);var d=r.text.replace(/_MENU_/,"");var v="<label>"+r.text+"</label>";f?v="_MENU_<label>"+d+"</label>":c&&(v="<label>"+d+"</label>_MENU_");var h="tmp-"+ +new Date;var p=t("<div/>").addClass(i.container).append(v.replace("_MENU_",'<span id="'+h+'"></span>'));var g=[];Array.prototype.slice.call(p.find("label")[0].childNodes).forEach((function(e){e.nodeType===Node.TEXT_NODE&&g.push({el:e,text:e.textContent})}));var m=function(t){g.forEach((function(r){r.el.textContent=Tt(e,r.text,t)}))};var b=t("<select/>",{"aria-controls":o,class:i.select});for(n=0;n<s.length;n++){var y=e.api.i18n("lengthLabels."+s[n],null);y===null&&(y=typeof u[n]==="number"?e.fnFormatNumber(u[n]):u[n]);b[0][n]=new Option(y,s[n])}p.find("label").attr("for","dt-length-"+Lr);b.attr("id","dt-length-"+Lr);Lr++;p.find("#"+h).replaceWith(b);t("select",p).val(e._iDisplayLength).on("change.DT",(function(){Ue(e,t(this).val());be(e)}));t(e.nTable).on("length.dt.DT",(function(r,a,n){if(e===a){t("select",p).val(n);m(n)}}));m(e._iDisplayLength);return p}),"l");t.fn.dataTable=r;r.$=t;t.fn.dataTableSettings=r.settings;t.fn.dataTableExt=r.ext;t.fn.DataTable=function(e){return t(this).dataTable(e).api()};t.each(r,(function(e,r){t.fn.DataTable[e]=r}));export{r as default};

